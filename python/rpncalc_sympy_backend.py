from rpncalc_common import *
import sympy
import dice

import rpncalc_sympy_functions as functions
from rpncalc_sympy_backend_constants import constants, constantsArray

features = Feature.Symbolic | Feature.StringConversion

class OperandType(IntEnum):
    All = 0
    Integer = 1
    Float = 2

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

Backend.engineFunction("=", lambda op: sympy.N(op), operands=1)

Backend.engineFunction("+", lambda op: op[0] + op[1])
Backend.engineFunction("-", lambda op: op[0] - op[1])
Backend.engineFunction("^", lambda op: op[0] ** op[1])
Backend.engineFunction("10^x", lambda op: 10 ** op, operands=1)
Backend.engineFunction("x^2", lambda op: op ** 2, operands=1)
Backend.engineFunction("neg", lambda op: op * -1, operands=1)
Backend.engineFunction("simplify", lambda op: sympy.simplify(op), operands=1)
Backend.engineFunction("%", lambda op: op[0] * op[1] / 100)
Backend.engineFunction("inv", lambda op: 1 / op, operands=1)
Backend.engineFunction("sqrt", lambda op: sympy.sqrt(op), operands=1)
Backend.engineFunction("nthroot", lambda op: sympy.root(op[0], op[1]))
Backend.engineFunction("log", lambda op: sympy.log(op[0], 10), operands=1)
Backend.engineFunction("ln", lambda op: sympy.log(op), operands=1)
Backend.engineFunction("e^x", lambda op: sympy.exp(op), operands=1)
Backend.engineFunction("factorial", lambda op: sympy.factorial(op), operands=1)

@Backend.engineFunction(operands=2)
def mul(op):
    expr = None
    if issubclass(type(op[1]), functions.Dice):
        expr = op[1] * op[0] # Force use of Dice __mul__ function
    else:
        expr = op[0] * op[1]
    return expr

@Backend.engineFunction(operands=2)
def div(op):
    expr = None
    if issubclass(type(op[1]), functions.Dice):
        expr = op[1] / op[0] # Force use of Dice __truediv__ function
    else:
        expr = op[0] / op[1]
    return expr

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

@Bitwise.engineFunction
def _and(op):
    res = int(op[0]) & int(op[1])
    return sympy.S(res)

@Bitwise.engineFunction
def _nand(op):
    res = int(op[0]) & int(op[1])
    res = ~res
    return sympy.S(res)

@Bitwise.engineFunction
def _or(op):
    res = int(op[0]) | int(op[1])
    return sympy.S(res)

@Bitwise.engineFunction
def _nor(op):
    res = int(op[0]) | int(op[1])
    res = ~res
    return sympy.S(res)

@Bitwise.engineFunction
def _and(op):
    res = int(op[0]) & int(op[1])
    return sympy.S(res)

@Bitwise.engineFunction
def _nand(op):
    res = int(op[0]) & int(op[1])
    res = ~res
    return sympy.S(res)

@Bitwise.engineFunction
def _xor(op):
    res = int(op[0]) ^ int(op[1])
    return sympy.S(res)

@Bitwise.engineFunction
def _xnor(op):
    res = int(op[0]) ^ int(op[1])
    res = ~res
    return sympy.S(res)

@Bitwise.engineFunction
def _shl(op):
    res = int(op[0]) << int(op[1])
    return sympy.S(res)

@Bitwise.engineFunction
def _shr(op):
    res = int(op[0]) >> int(op[1])
    return sympy.S(res)

@Bitwise.engineFunction(operands=1)
def _not(op):
    res = int(op)
    res = ~res
    return sympy.S(res)

@Bitwise.engineFunction(operands=1)
def _2cmp(op):
    res = int(op)
    res = ~res + 1
    return sympy.S(res)

@Bitwise.engineFunction(operands=1)
def u8bit(op):
    res = int(op) & 0xff
    return sympy.S(res)

@Bitwise.engineFunction(operands=1)
def u16bit(op):
    res = int(op) & 0xffff
    return sympy.S(res)

@Backend.engineFunction(operands=1)
def cos(op):
    op = convertToRadians(op)
    return sympy.cos(op)

@Backend.engineFunction(operands=1)
def acos(op):
    expr = sympy.acos(op)
    return convertFromRadians(expr)

@Backend.engineFunction(operands=1)
def sin(op):
    op = convertToRadians(op)
    return sympy.sin(op)

@Backend.engineFunction(operands=1)
def asin(op):
    expr = sympy.asin(op)
    return convertFromRadians(expr)

@Backend.engineFunction(operands=1)
def tan(op):
    op = convertToRadians(op)
    return sympy.tan(op)

@Backend.engineFunction(operands=1)
def atan(op):
    expr = sympy.atan(op)
    return convertFromRadians(expr)

@Backend.engineFunction(operands=0)
def d4(op):
    expr = functions.d4(1)
    return expr

@Backend.engineFunction(operands=0)
def d6(op):
    expr = functions.d6(1)
    return expr

@Backend.engineFunction(operands=0)
def d8(op):
    expr = functions.d8(1)
    return expr

@Backend.engineFunction(operands=0)
def d10(op):
    expr = functions.d10(1)
    return expr

@Backend.engineFunction(operands=0)
def d12(op):
    expr = functions.d12(1)
    return expr

@Backend.engineFunction(operands=0)
def d20(op):
    expr = functions.d20(1)
    return expr

@Backend.engineFunction(operands=0)
def d100(op):
    expr = functions.d100(1)
    return expr

def convertToRadians(expr):
    newExpr = None
    if trigUnit == TrigUnit.Degrees:
        newExpr = sympy.rad(expr)
    elif trigUnit == TrigUnit.Gradients:
        newExpr = expr * sympy.pi / 200
    else:
        newExpr = expr

    return newExpr

def convertFromRadians(expr):
    newExpr = None
    if trigUnit == TrigUnit.Degrees:
        newExpr = sympy.deg(expr)
    elif trigUnit == TrigUnit.Gradients:
        newExpr = expr * 200 / sympy.pi
    else:
        newExpr = expr

    return newExpr

def stringExpressionValid(str):
    try:
        sympy.S(str)
        return True
    except sympy.SympifyError as err:
        print(err)
        return False

def stringToExpr(str):
    return sympy.S(str)

def exprToStr(expr, prec = 9):
    try:
        s = None
        if expr.is_Float is True:
            s = str(eval(expr, prec))
        else:
            s = str(expr)
            s = s.replace("**", "^")
            s = s.replace("pi", "π")
            s = s.replace("sqrt", "√")
            s = s.replace("log", "ln")
        return s
    except:
        raise UnsupportedBackendExpressionException()

def eval(expr, prec = 9):
    try:
        return expr.evalf(prec);
    except:
        raise UnsupportedBackendExpressionException()

def addSymbol(s):
    return sympy.S(s)
