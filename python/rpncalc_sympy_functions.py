import sympy
import dice

class d6(sympy.Function):

    is_real = False

    def __init__(self, arg = 1):
        self.nb = arg

    def __mul__(self, other):
        if isinstance(other, sympy.Number):
            return d6(other * self.nb)
        elif isinstance(other, int):
            return d6(other * self.nb)

    def __rmul__(self, other):
        if isinstance(other, sympy.Number):
            return d6(other * self.nb)
        elif isinstance(other, int):
            return d6(other * self.nb)


    def _eval_evalf(self, prec):
        return sympy.Integer(self.__int__())

    def __int__(self):
        return dice.roll(str(self.nb) + "d6t")

    def __str__(self,*args):
        return str(self.nb) + "d6"

    def _sympystr(self,*args):
        return str(self.nb) + "d6"
