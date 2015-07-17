import sys
import platform
sys.path.append("/usr/share/harbour-rpncalc/lib/python/");

import numpy
import sympy
import pyotherside

class NotEnoughOperandsException(Exception):
    def __init__(self, nbRequested, nbAvailable):
        self.nbRequested = nbRequested
        self.nbAvailable = nbAvailable

    def __str__(self):
        return "Not enough operands available. " + self.nbRequested + " but only " + self.nbAvailable + " available."

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
            self.operationInputProcessor(input)
        elif type == "constant":
            self.constantInputProcessor(input)
        else:
            print(type)

    def stackInputProcessor(self, input):

        if input == "enter":
            self.undoStack = self.stack

            expr = sympy.S(self.currentOperand)
            self.stackPush(expr)

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
                    op1 = self.stack[0]
                    op2 = self.stack[1]
                    self.stackPop(2)
                else:
                    op1 = sympy.S(self.currentOperand)
                    op2 = self.stack[0]
                    self.stackPop(1)
                return (op1, op2)
            elif nb == 1:
                if self.currentOperand == "":
                    op1 = self.stack[0]
                    self.stackPop(1)
                else:
                    op1 = sympy.S(self.currentOperand)
                return (op1)
            else:
                raise NotImplementedError()
        else:
            raise NotEnoughOperandsException(nb, nbAvailable)


    def stackPop(self, nb = 1):

        for i in range(0, nb):
            self.stack.pop(0)


    def stackPush(self, expr):
        self.stack.insert(0, expr)
        print(expr)
        self.clearCurrentOperand()
        self.stackChanged()

    def strToNumber(self, str):
        if "." in str:
            return float(self.currentOperand)
        else:
            return int(self.currentOperand)

    def clearCurrentOperand(self):
        self.currentOperand = "";
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
            el = {"index": index, "expr": expr, "value": value}
            model.append(el)
            index += 1

        return model


beauty = SimpleBeautifier()
engine = Engine(beauty)
