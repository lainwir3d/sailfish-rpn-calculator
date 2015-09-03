from rpncalc_common import *
import mpmath

from rpncalc_mpmath_backend_constants import constants

features = Feature.StringConversion

class Backend:
    objs={}

    undo = True
    operands = 2
    operandTypes = OperandType.All

    def __init__(self, *args, **nargs):
        pass

    @classmethod
    def engineFunction(*args, **nargs):
        f_operands = nargs.get("operands", __class__.operands)
        f_operandTypes = nargs.get("operandTypes", Backend.operandTypes)
        f_undo = nargs.get("undo", Backend.undo)

        if args:
            f = None
            name = None
            classref = None

            if len(args) == 1:  # Decorator + named args
                classref = args[0]
                def wrap(f):
                    f.undo = nargs.get("undo", classref.undo)
                    f.operands = nargs.get("operands", classref.operands)
                    f.operandTypes = nargs.get("operandTypes", classref.operandTypes)

                    Backend.objs[f.__name__] = {"undo": f_undo, "operands": f_operands, "operandTypes": f_operandTypes, "func": f}

                    return f
                return wrap
            elif len(args) == 2: # Decorator
                classref = args[0]
                f = args[1]
                name = f.__name__
            elif len(args) == 3: # inline lambda
                classref = args[0]
                name = args[1]
                f = args[2]

            f.undo = nargs.get("undo", classref.undo)
            f.operands = nargs.get("operands", classref.operands)
            f.operandTypes = nargs.get("operandTypes", classref.operandTypes)
            Backend.objs[name] = {"undo": f.undo, "operands": f.operands, "operandTypes": f.operandTypes, "func": f}
            return f

    def __call__(self):
        pass

class Bitwise(Backend):
    operands = 2
    operandTypes = OperandType.Integer

objs = Backend.objs
trigUnit = TrigUnit.Radians

Backend.engineFunction("=", lambda op: mpmath.mpmathify(op), operands=1)

Backend.engineFunction("+", lambda op: op[0] + op[1])
Backend.engineFunction("-", lambda op: op[0] - op[1])
Backend.engineFunction("mul", lambda op: op[0] * op[1])
Backend.engineFunction("div", lambda op: op[0] / op[1])
Backend.engineFunction("^", lambda op: op[0] ** op[1])
Backend.engineFunction("10^x", lambda op: 10 ** op, operands=1)
Backend.engineFunction("x^2", lambda op: op ** 2, operands=1)
Backend.engineFunction("neg", lambda op: op * -1, operands=1)
Backend.engineFunction("%", lambda op: op[0] * op[1] / 100)
Backend.engineFunction("inv", lambda op: 1 / op, operands=1)
Backend.engineFunction("sqrt", lambda op: mpmath.sqrt(op), operands=1)
Backend.engineFunction("nthroot", lambda op: mpmath.root(op[0], op[1]))
Backend.engineFunction("log", lambda op: mpmath.log(op, b=10), operands=1)
Backend.engineFunction("ln", lambda op: mpmath.log(op), operands=1)
Backend.engineFunction("e^x", lambda op: mpmath.exp(op), operands=1)
Backend.engineFunction("factorial", lambda op: mpmath.factorial(op), operands=1)

@Backend.engineFunction(operands=-1)
def addall(op):
    expr = op[0]
    for i in range(1, len(op)):
        expr = expr + op[i]
    return expr

@Backend.engineFunction(operands=-1)
def suball(op):
    expr = op[0]
    for i in range(1, len(op)):
        expr = expr - op[i]
    return expr

@Backend.engineFunction(operands=1)
def cos(op):
    op = convertToRadians(op)
    return mpmath.cos(op)

@Backend.engineFunction(operands=1)
def acos(op):
    expr = mpmath.acos(op)
    return convertFromRadians(expr)

@Backend.engineFunction(operands=1)
def sin(op):
    op = convertToRadians(op)
    return mpmath.sin(op)

@Backend.engineFunction(operands=1)
def asin(op):
    expr = mpmath.asin(op)
    return convertFromRadians(expr)

@Backend.engineFunction(operands=1)
def tan(op):
    op = convertToRadians(op)
    return mpmath.tan(op)

@Backend.engineFunction(operands=1)
def atan(op):
    expr = mpmath.atan(op)
    return convertFromRadians(expr)


def convertToRadians(expr):
    newExpr = None
    if trigUnit == TrigUnit.Degrees:
        newExpr = mpmath.radians(expr)
    elif trigUnit == TrigUnit.Gradients:
        newExpr = expr * mpmath.pi / 200
    else:
        newExpr = expr

    return newExpr

def convertFromRadians(expr):
    newExpr = None
    if trigUnit == TrigUnit.Degrees:
        newExpr = mpmath.degrees(expr)
    elif trigUnit == TrigUnit.Gradients:
        newExpr = expr * 200 / mpmath.pi
    else:
        newExpr = expr

    return newExpr

def stringExpressionValid(str):
    try:
        mpmath.mpmathify(str)
        return True
    except Exception as err:
        print(err)
        return False

def stringToExpr(str):
    return mpmath.mpmathify(str)

def exprToStr(expr, prec = 9):
    try:
        return eval(expr, prec)
    except:
        raise UnsupportedBackendExpressionException()

def eval(expr, prec = 9):
    try:
        return mpmath.nstr(expr, prec)
    except:
        raise UnsupportedBackendExpressionException()
