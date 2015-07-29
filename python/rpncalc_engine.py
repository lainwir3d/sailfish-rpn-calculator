import sys
import platform

(major, minor, micro, release, serial) = sys.version_info
sys.path.append("/usr/share/harbour-rpncalc/lib/python" + str(major) + "." + str(minor) + "/site-packages/");

import pyotherside
from enum import Enum, IntEnum, unique

import threading
sympy = None
rpncalc_constants = None
rpncalc_functions = None

class NotEnoughOperandsException(Exception):
    def __init__(self, nbRequested, nbAvailable):
        self.nbRequested = nbRequested
        self.nbAvailable = nbAvailable

    def __str__(self):
        return "Not enough operands available. " + str(self.nbRequested) + " but only " + str(self.nbAvailable) + " available."

class OperandType(IntEnum):
    All = 0
    Integer = 1
    Float = 2

class TrigUnit(IntEnum):
    Radians = 0
    Degrees = 1
    Gradients = 2

class WrongOperandsException(Exception):
    def __init__(self, expectedTypes, nb=0):
        try:
            _ = (t for t in expectedTypes)  # check for iterable
            self.expectedTypes = expectedTypes
        except TypeError:
            self.expectedTypes = (expectedTypes,)

        self.nb = nb

    def __str__(self):
        return "Wrong operands inputed. Expected " + str(self.expectedTypes) + "."

class CannotVerifyOperandsTypeException(Exception):
    def __init__(self):
        pass

    def __str__(self):
        return "Cannot verify operands type, array are not the same length."

class ExpressionNotValidException(Exception):
    def __init__(self):
        pass

    def __str__(self):
        return "Expression not valid."

class Engine:

    def __init__(self, beautifier):
        self.engineLoaded = False
        self.extendedFunctionLoaded = False
        self.stack = []
        self.undoStack = []
        self.currentOperand = ""

        self.beautifier = beautifier
        self.trigUnit = TrigUnit.Radians

        t = threading.Timer(0.1, self.loadEngine)
        t.start()


    def loadEngine(self):
        global sympy
        import sympy

        global rpncalc_constants
        import rpncalc_constants

        global rpncalc_functions
        import rpncalc_functions

        print("Engine loaded")
        self.engineLoaded = True
        self.extendedFunctionLoaded = True

        pyotherside.send("EngineLoaded")

    def getStack(self):
        return self.stack

    def processInput(self, input, type):

        try:
            if type == "number":
                self.currentOperand += input
                self.currentOperandChanged()
            elif type == "exp":
                if self.currentOperand == "":
                    self.currentOperand += "1e"
                else:
                    self.currentOperand += "e"
                self.currentOperandChanged()
            elif type == "stack":
                self.stackInputProcessor(input)
            elif type == "operation":
                self.operationInputProcessor(input)
            elif type == "constant":
                self.constantInputProcessor(input)
            elif type == "real":
                if len(self.currentOperand) > 0 and '.' not in self.currentOperand:
                    self.currentOperand += input
                    self.currentOperandChanged()
            elif type == "function":
                self.functionInputProcessor(input)
            else:
                print(type)
        except ExpressionNotValidException as err:
            print(err)
            pyotherside.send("ExpressionNotValidException")
        except NotEnoughOperandsException as err:
            print(err)
            pyotherside.send("NotEnoughOperandsException", err.nbRequested, err.nbAvailable)
        except WrongOperandsException as err:
            print(err)
            pyotherside.send("WrongOperandsException", err.expectedTypes, err.nb)


    def currentOperandValid(self):
        valid = True
        if self.currentOperand != "":
            lastChr = self.currentOperand[-1:]
            if lastChr == "e":
                valid = False
            elif lastChr == "-":
                valid = False

        return valid

    def currentOperandLastChr(self):
        lastChr = ""
        if self.currentOperand != "":
            lastChr = self.currentOperand[-1:]

        return lastChr

    def changeTrigonometricUnit(self, unit):
        print("Changing unit to " + str(unit))
        if unit == "Radian":
            self.trigUnit = TrigUnit.Radians
        elif unit == "Degree":
            self.trigUnit = TrigUnit.Degrees
        elif unit == "Gradient":
            self.trigUnit = TrigUnit.Gradients
        else:
            print("Invalid unit")

    def convertToRadians(self, expr):
        newExpr = None
        if self.trigUnit == TrigUnit.Degrees:
            newExpr = rpncalc_functions.rad(expr)
        elif self.trigUnit == TrigUnit.Gradients:
            newExpr = rpncalc_functions.rad(expr)
        else:
            newExpr = expr

        return newExpr

    def convertFromRadians(self, expr):
        newExpr = None
        if self.trigUnit == TrigUnit.Degrees:
            newExpr = rpncalc_functions.deg(expr)
        elif self.trigUnit == TrigUnit.Gradients:
            newExpr = rpncalc_functions.grad(expr)
        else:
            newExpr = expr

        return newExpr


    def stackInputProcessor(self, input):

        if input == "enter":
            self.undoStack = self.stack

            expr = None
            if self.currentOperand != "":
                if self.currentOperandValid() is False:
                    raise ExpressionNotValidException()

                expr = sympy.S(self.currentOperand)
            elif len(self.stack) > 0:
                expr = self.stack[0]

            if expr is not None:
                self.stackPush(expr)
        elif input == "swap":

            if len(self.stack) > 1:
                self.undoStack = self.stack

                op0 = self.stack[0]
                op1 = self.stack[1]

                self.stack[0] = op1;
                self.stack[1] = op0;

                self.stackChanged()
        elif input == "drop":
            self.stackDropFirst()
        elif input == "clr":
            self.stackDropAll()
        elif input == "undo":
            self.stack = self.undoStack
            self.stackChanged()
        elif input == "R-":
            if len(self.stack) > 1:
                self.stack.append(self.stack.pop(0))
                self.stackChanged()
        elif input == "R+":
            if len(self.stack) > 1:
                self.stack.insert(0, self.stack.pop())
                self.stackChanged()

    def functionInputProcessor(self, input):

        if input == "cos":
            self.undoStack = self.stack

            op = self.getOperands(1)
            op = self.convertToRadians(op)
            expr = sympy.cos(op)
            self.stackPush(expr)
        elif input == "acos":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = sympy.acos(op)
            expr = self.convertFromRadians(expr)
            self.stackPush(expr)

        elif input == "sin":
            self.undoStack = self.stack

            op = self.getOperands(1)
            op = self.convertToRadians(op)
            expr = sympy.sin(op)
            self.stackPush(expr)

        elif input == "asin":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = sympy.asin(op)
            expr = self.convertFromRadians(expr)
            self.stackPush(expr)

        elif input == "tan":
            self.undoStack = self.stack

            op = self.getOperands(1)
            op = self.convertToRadians(op)
            expr = sympy.tan(op)
            self.stackPush(expr)

        elif input == "atan":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = sympy.atan(op)
            expr = self.convertFromRadians(expr)
            self.stackPush(expr)

        elif input == "%":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            expr = op1 * op2 / 100
            self.stackPush(expr)

        elif input == "inv":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = 1 / op
            self.stackPush(expr)

        elif input == "sqrt":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = sympy.sqrt(op)
            self.stackPush(expr)

        elif input == "nthroot":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            expr = sympy.root(op1, op2)
            self.stackPush(expr)

        elif input == "log":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = sympy.log(op, 10)
            self.stackPush(expr)
        elif input == "ln":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = sympy.log(op)
            self.stackPush(expr)
        elif input == "e^x":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = sympy.exp(op)
            self.stackPush(expr)
        elif input == "factorial":
            self.undoStack = self.stack

            op = self.getOperands(1)
            expr = sympy.factorial(op)
            self.stackPush(expr)

    def constantInputProcessor(self, input):

        if input == "pi":
            self.undoStack = self.stack
            self.stackPush(sympy.pi)
        elif input == "light":
            self.undoStack = self.stack
            self.stackPush(rpncalc_constants.c)
        elif input == "magnetic":
            self.undoStack = self.stack
            self.stackPush(rpncalc_constants.magn)
        elif input == "elementary_charge":
            self.undoStack = self.stack
            self.stackPush(rpncalc_constants.q)
        elif input == "electrical":
            self.undoStack = self.stack
            self.stackPush(rpncalc_constants.e0)
        elif input == "boltzmann":
            self.undoStack = self.stack
            self.stackPush(rpncalc_constants.k)
        elif input == "gravitation":
            self.undoStack = self.stack
            self.stackPush(rpncalc_constants.G)

    def operationInputProcessor(self, input):
        if input == "+":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            expr = op1 + op2
            self.stackPush(expr)
        elif input == "-":
            self.undoStack = self.stack

            if self.currentOperandLastChr() == "e":
                self.currentOperand += "-"
                self.currentOperandChanged()
            else:
                (op1, op2) = self.getOperands(2)
                expr = op1 - op2
                self.stackPush(expr)
        elif input == "*":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            expr = op1 * op2
            self.stackPush(expr)
        elif input == "/":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            expr = op1 / op2
            self.stackPush(expr)
        elif input == "=":
            self.undoStack = self.stack

            (op1) = self.getOperands(1)
            expr = sympy.N(op1)
            self.stackPush(expr)
        elif input == "^":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            expr = op1 ** op2
            self.stackPush(expr)
        elif input == "10^x":
            self.undoStack = self.stack

            (op1) = self.getOperands(1)
            expr = 10 ** op1

            self.stackPush(expr)
        elif input == "x^2":
            self.undoStack = self.stack

            (op1) = self.getOperands(1)
            expr = op1 ** 2

            self.stackPush(expr)
        elif input == "neg":
            self.undoStack = self.stack

            if self.currentOperandLastChr() == "e":
                self.currentOperand += "-"
                self.currentOperandChanged()
            else:
                (op1) = self.getOperands(1)
                expr = op1 * -1
                self.stackPush(expr)

        elif input == "and":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2, (OperandType.Integer, OperandType.Integer)) # type verification tuple kept as reference, could be simplified as below
            op1 = int(sympy.N(op1))
            op2 = int(sympy.N(op2))
            expr = op1 & op2
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "nand":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2, OperandType.Integer)
            op1 = int(sympy.N(op1))
            op2 = int(sympy.N(op2))
            expr = ~(op1 & op2)
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "or":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2, OperandType.Integer)
            op1 = int(sympy.N(op1))
            op2 = int(sympy.N(op2))
            expr = op1 | op2
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "nor":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2, OperandType.Integer)
            op1 = int(sympy.N(op1))
            op2 = int(sympy.N(op2))
            expr = ~(op1 | op2)
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "xor":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2, OperandType.Integer)
            op1 = int(sympy.N(op1))
            op2 = int(sympy.N(op2))
            expr = op1 ^ op2
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "xnor":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2, OperandType.Integer)
            op1 = int(sympy.N(op1))
            op2 = int(sympy.N(op2))
            expr = ~(op1 ^ op2)
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "shl":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2, OperandType.Integer)
            op1 = int(sympy.N(op1))
            op2 = int(sympy.N(op2))
            expr = op1 << op2
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "shr":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2, OperandType.Integer)
            op1 = int(sympy.N(op1))
            op2 = int(sympy.N(op2))
            expr = op1 >> op2
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "not":
            self.undoStack = self.stack

            (op1) = self.getOperands(1, OperandType.Integer)
            op1 = int(sympy.N(op1))
            expr = ~op1
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "2cmp":
            self.undoStack = self.stack

            (op1) = self.getOperands(1, OperandType.Integer)
            op1 = int(sympy.N(op1))
            expr = (~op1) + 1
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "u8bit":
            self.undoStack = self.stack

            (op1) = self.getOperands(1, OperandType.Integer)
            op1 = int(sympy.N(op1))
            expr = op1 & 0xff
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "u16bit":
            self.undoStack = self.stack

            (op1) = self.getOperands(1, OperandType.Integer)
            op1 = int(sympy.N(op1))
            expr = op1 & 0xffff
            expr = sympy.S(expr)
            self.stackPush(expr)
        elif input == "Σ+":
            self.undoStack = self.stack

            ops = self.getOperands(-1)
            expr = ops[0]

            for i in range(1, len(ops)):
                expr = expr + ops[i]

            self.stackPush(expr)

        elif input == "Σ-":
            self.undoStack = self.stack

            ops = self.getOperands(-1)
            expr = ops[0]

            for i in range(1, len(ops)):
                expr = expr - ops[i]

            self.stackPush(expr)


    def getOperands(self, nb=2, types=OperandType.All):
        nbAvailable = 0

        if self.currentOperand != "":
            nbAvailable = 1
        nbAvailable += len(self.stack)

        if nb == -1:
            nb = len(self.stack)
            if self.currentOperand != "":
                nb += 1

        if nb <= nbAvailable:
            ops = ()
            nbToPop = 0;
            rangeStart = nb;
            if self.currentOperand != "":
                rangeStart -= 1;

            for i in reversed(range(0, rangeStart)):
                ops = ops + (self.stack[i],)
                nbToPop += 1

            if len(ops) < nb:
                if self.currentOperandValid() is False:
                    raise ExpressionNotValidException()

                ops = ops + (sympy.S(self.currentOperand),)


            typesOk = True
            exposedExceptionNb = 0
            try: # types is iterable, multiple types given. Checking against each operand.
                i = 0
                for t in types:
                    if len(types) != len(ops):  # late checking for length, because we had to know that it was iterable before
                        raise CannotVerifyOperandsTypeException()
                    typesOk = typesOk and self.__verifyType(ops[i], t)
                    i += 1
            except TypeError: # types is not iterable
                for o in ops:
                    typesOk = typesOk and self.__verifyType(o, types)
                exposedExceptionNb = nb  # expose number of required operand type to exception, since we do not have details.

            if typesOk is True:
                self.__stackPop(nbToPop)
                if len(ops) == 1:
                    return ops[0]
                else:
                    return ops
            else:
                raise WrongOperandsException(types, exposedExceptionNb)

        else:
            raise NotEnoughOperandsException(nb, nbAvailable)

    def __verifyType(self, op, type):

        if type == OperandType.All:
            return True
        elif type == OperandType.Integer:
            return op.is_integer
        elif type == OperandType.Float:
            return op.is_real

    def __stackPop(self, nb = 1):
        for i in range(0, nb):
            self.stack.pop(0)

    def stackPush(self, expr):
        self.stack.insert(0, expr)
        self.clearCurrentOperand()
        self.stackChanged()

    def stackDropFirst(self):
        if len(self.stack) > 0:
            self.stack.pop(0)
            self.stackChanged()

    def stackDropAll(self):
        if len(self.stack) > 0:
            self.stack.clear()
            self.stackChanged()

    def strToNumber(self, str):
        if "." in str:
            return float(self.currentOperand)
        else:
            return int(self.currentOperand)

    def clearCurrentOperand(self):
        self.currentOperand = "";
        self.currentOperandChanged();

    def delLastOperandCharacter(self):
        self.currentOperand = self.currentOperand[:-1]
        self.currentOperandChanged();

    def currentOperandChanged(self):
        pyotherside.send("currentOperand", self.currentOperand)

    def stackChanged(self):
        res = self.beautifier.beautifyStack(self.stack)
        pyotherside.send("newStack", res)

class StackManager:

    def __init__(self):
        pass

class SimpleBeautifier:

    def __init__(self):
        pass

    def beautifyNumber(self, number):
        pass

    def beautifyStack(self, stack):
        model = []

        index = 1
        for i in stack:
            value = str(sympy.N(i))
            expr = str(i)
            expr = expr.replace("**", "^")
            expr = expr.replace("pi", "π")
            expr = expr.replace("sqrt", "√")
            expr = expr.replace("log", "ln")
            el = {"index": index, "expr": expr, "value": value}
            model.append(el)
            index += 1

        return model


beauty = SimpleBeautifier()
engine = Engine(beauty)
