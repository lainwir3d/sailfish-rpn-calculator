import sympy
import dice

class Dice(sympy.Function):

    is_real = False

    diceString = "d4"

    def __init__(self, arg = 1):
        self.nb = arg

    def __add__(self, other):
        if isinstance(other, self.__class__):
            return self.__class__(self.nb + other.nb)
        else:
            return super().__add__(other)
    
    def __radd__(self, other):
        if isinstance(other, self.__class__):
            return self.__class__(other.nb + self.nb)
        else:
            return super().__radd__(other)

    def __sub__(self, other):
        if isinstance(other, self.__class__):
            return self.__class__(self.nb - other.nb)
        else:
            return super().__add__(other)
    
    def __rsub__(self, other):
        if isinstance(other, self.__class__):
            return self.__class__(other.nb - self.nb)
        else:
            return super().__radd__(other)

    def __mul__(self, other):
        value = self.nb * sympy.S(other)
        if value % 1 == 0:
            return self.__class__(int(value))
        else:
            return super().__mul__(other)

    def __rmul__(self, other):
        value = sympy.S(other) * self.nb
        if value % 1 == 0:
            return self.__class__(int(value))
        else:
            return super().__rmul__(other)

    def __truediv__(self, other):
        value = self.nb / sympy.S(other)
        if value % 1 == 0:
            return self.__class__(int(value))
        else:
            return super().__truediv__(other)

    def __rtruediv__(self, other):
        value = sympy.S(other) / self.nb
        if value % 1 == 0:
            return self.__class__(int(value))
        else:
            return super().__truediv__(other)

    def _eval_evalf(self, prec):
        return sympy.Integer(self.__int__())

    def __int__(self):
        factor = str(self.nb)

        sign = None
        if factor[0] == "-":
            sign = -1
            factor = factor[1:len(factor)]
        else:
            sign = 1

        toRoll = factor + self.__class__.diceString + "t"
        result = dice.roll(toRoll)

        return sympy.S(result * sign)

    def __str__(self,*args):
        return str(self.nb) + self.__class__.diceString

    def _sympystr(self,*args):
        return str(self.nb) + self.__class__.diceString

class d4(Dice):
    diceString = "d4"

class d6(Dice):
    diceString = "d6"

class d8(Dice):
    diceString = "d8"

class d10(Dice):
    diceString = "d10"

class d12(Dice):
    diceString = "d12"

class d20(Dice):
    diceString = "d20"

class d100(Dice):
    diceString = "d100"

