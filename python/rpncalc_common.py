from enum import Enum, IntEnum, unique

class OperandType(IntEnum):
    All = 0
    Integer = 1
    Float = 2

class TrigUnit(IntEnum):
    Radians = 0
    Degrees = 1
    Gradients = 2

class Feature(IntEnum):
    Symbolic = 1
    StringConversion = 2

class NotEnoughOperandsException(Exception):
    def __init__(self, nbRequested, nbAvailable):
        self.nbRequested = nbRequested
        self.nbAvailable = nbAvailable

    def __str__(self):
        return "Not enough operands available. " + str(self.nbRequested) + " but only " + str(self.nbAvailable) + " available."

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

class FeatureNotSupportedException(Exception):
    def __init__(self):
        pass

    def __str__(self):
        return "Feature not supported by Backend."

class UnsupportedBackendExpressionException(Exception):
    def __init__(self):
        pass

    def __str__(self):
        return "Expression is not a supported backend type."
