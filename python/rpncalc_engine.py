import sys
import platform
sys.path.append("/usr/share/harbour-rpncalc/lib/python/");


import numpy
import sympy
import pyotherside

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
        else:
            print(type)

    def stackInputProcessor(self, input):

        if input == "enter":
            self.undoStack = self.stack

            expr = sympy.S(self.currentOperand)
            self.stackPush(expr)

    def operationInputProcessor(self, input):
        if input == "+":
            self.undoStack = self.stack

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

            expr = op1 + op2
            print(expr)
            print(type(expr))
            self.stackPush(expr)


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
