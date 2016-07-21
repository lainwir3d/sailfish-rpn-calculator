import mpmath

class Constants():

    constants = {}

    @classmethod
    def addConstant(*args):
        if len(args) == 2:
            Constants.constants[args[1].__qualname__] = args[1]()
            return args[1]
        elif len(args) == 3:
            Constants.constants[args[1]] = args[2]

constants = Constants.constants

Constants.addConstant("pi", mpmath.pi)
