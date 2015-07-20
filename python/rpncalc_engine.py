import sys
import platform
sys.path.append("/usr/share/harbour-rpncalc/lib/python/");

import numpy
import sympy
import pyotherside
from enum import Enum, IntEnum, unique

class NotEnoughOperandsException(Exception):
    def __init__(self, nbRequested, nbAvailable):
        self.nbRequested = nbRequested
        self.nbAvailable = nbAvailable

    def __str__(self):
        return "Not enough operands available. " + str(self.nbRequested) + " but only " + str(self.nbAvailable) + " available."

class OperandType(IntEnum):
    Integer = 1
    Float = 2

class WrongOperandsException(Exception):
    def __init__(self, expectedTypes):
        self.expectedTypes = expectedTypes

    def __str__(self):
        return "Wrong operands inputed. Expected " + str(self.expectedTypes) + "."

class Engine:

    def __init__(self, beautifier):
        self.stack = []
        self.undoStack = []
        self.currentOperand = ""

        self.beautifier = beautifier

    def getStack(self):
        return self.stack

    def processInput(self, input, type):

        if type == "number":
            self.currentOperand += input
            self.currentOperandChanged()
        elif type == "stack":
            self.stackInputProcessor(input)
        elif type == "operation":
            try:
                self.operationInputProcessor(input)
            except NotEnoughOperandsException as err:
                print(err)
                pyotherside.send("NotEnoughOperandsException", err.nbRequested, err.nbAvailable)
            except WrongOperandsException as err:
                print(err)
                pyotherside.send("WrongOperandsException", err.expectedTypes)
        elif type == "constant":
            self.constantInputProcessor(input)
        elif type == "real":
            if len(self.currentOperand) > 0 and '.' not in self.currentOperand:
                self.currentOperand += input
                self.currentOperandChanged()
        else:
            print(type)

    def stackInputProcessor(self, input):

        if input == "enter":
            self.undoStack = self.stack

            expr = None
            if self.currentOperand != "":
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



    def constantInputProcessor(self, input):

        if input == "pi":
            self.undoStack = self.stack
            self.stackPush(sympy.pi)

    def operationInputProcessor(self, input):
        if input == "+":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            expr = op1 + op2
            self.stackPush(expr)
        elif input == "-":
            self.undoStack = self.stack

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

            (op1) = self.getOperands(1)
            expr = op1 * -1

            self.stackPush(expr)
        elif input == "and":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            if op1.is_integer and op2.is_integer:
                op1 = int(sympy.N(op1))
                op2 = int(sympy.N(op2))
                expr = op1 & op2
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer,OperandType.Integer))

        elif input == "nand":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            if op1.is_integer and op2.is_integer:
                op1 = int(sympy.N(op1))
                op2 = int(sympy.N(op2))
                expr = ~(op1 & op2)
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer,OperandType.Integer))
        elif input == "or":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            if op1.is_integer and op2.is_integer:
                op1 = int(sympy.N(op1))
                op2 = int(sympy.N(op2))
                expr = op1 | op2
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer,OperandType.Integer))
        elif input == "nor":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            if op1.is_integer and op2.is_integer:
                op1 = int(sympy.N(op1))
                op2 = int(sympy.N(op2))
                expr = ~(op1 | op2)
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer,OperandType.Integer))
        elif input == "xor":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            if op1.is_integer and op2.is_integer:
                op1 = int(sympy.N(op1))
                op2 = int(sympy.N(op2))
                expr = op1 ^ op2
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer,OperandType.Integer))
        elif input == "xnor":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            if op1.is_integer and op2.is_integer:
                op1 = int(sympy.N(op1))
                op2 = int(sympy.N(op2))
                expr = ~(op1 ^ op2)
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer,OperandType.Integer))
        elif input == "shl":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            if op1.is_integer and op2.is_integer:
                op1 = int(sympy.N(op1))
                op2 = int(sympy.N(op2))
                expr = op1 << op2
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer,OperandType.Integer))
        elif input == "shr":
            self.undoStack = self.stack

            (op1, op2) = self.getOperands(2)
            if op1.is_integer and op2.is_integer:
                op1 = int(sympy.N(op1))
                op2 = int(sympy.N(op2))
                expr = op1 >> op2
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer,OperandType.Integer))
        elif input == "not":
            self.undoStack = self.stack

            (op1) = self.getOperands(1)
            if op1.is_integer:
                op1 = int(sympy.N(op1))
                expr = ~op1
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer))
        elif input == "2cmp":
            self.undoStack = self.stack

            (op1) = self.getOperands(1)
            if op1.is_integer:
                op1 = int(sympy.N(op1))
                expr = (~op1) + 1
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer))
        elif input == "u8bit":
            self.undoStack = self.stack

            (op1) = self.getOperands(1)
            if op1.is_integer:
                op1 = int(sympy.N(op1))
                expr = op1 & 0xff
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer))
        elif input == "u16bit":
            self.undoStack = self.stack

            (op1) = self.getOperands(1)
            if op1.is_integer:
                op1 = int(sympy.N(op1))
                expr = op1 & 0xffff
                expr = sympy.S(expr)
                self.stackPush(expr)
            else:
                raise WrongOperandsException((OperandType.Integer))


    def getOperands(self, nb=2):
        nbAvailable = 0

        if self.currentOperand != "":
            nbAvailable = 1
        nbAvailable += len(self.stack)

        if nb <= nbAvailable:
            if nb == 2:
                op1 = None
                op2 = None
                if self.currentOperand == "":
                    op1 = self.stack[1]
                    op2 = self.stack[0]
                    self.__stackPop(2)
                else:
                    op1 = self.stack[0]
                    op2 = sympy.S(self.currentOperand)
                    self.__stackPop(1)
                return (op1, op2)
            elif nb == 1:
                if self.currentOperand == "":
                    op1 = self.stack[0]
                    self.__stackPop(1)
                else:
                    op1 = sympy.S(self.currentOperand)
                return (op1)
            else:
                raise NotImplementedError()
        else:
            raise NotEnoughOperandsException(nb, nbAvailable)


    def __stackPop(self, nb = 1):
        for i in range(0, nb):
            self.stack.pop(0)

    def stackPush(self, expr):
        self.stack.insert(0, expr)
        print(expr)
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
            el = {"index": index, "expr": expr, "value": value}
            model.append(el)
            index += 1

        return model


beauty = SimpleBeautifier()
engine = Engine(beauty)
