from sympy import N, S, pi, Function, Number, NumberSymbol, Symbol

class Celerity(NumberSymbol):

    is_real = True
    is_positive = True
    is_negative = False
    is_irrational = None
    is_number = True
    is_algebraic = False

    val='299792458'


    def _eval_evalf(self,prec):
        return N(self.val,prec)

    def __str__(self,*args):
        return 'c'

    def _sympystr(self,*args):
        return self.val

    def _latex(self,*args):
        return 'c'

c = Celerity()


class Boltzmann(NumberSymbol):

    is_real = True
    is_positive = True
    is_negative = False
    is_irrational = None
    is_number = True
    is_algebraic = False

    val='1.3806488e-23'


    def _eval_evalf(self,prec):
        return N(self.val,prec)

    def __str__(self,*args):
        return 'k'

    def _sympystr(self,*args):
        return self.val

    def _latex(self,*args):
        return 'k'

k = Boltzmann()


class Gravitation(NumberSymbol):

    is_real = True
    is_positive = True
    is_negative = False
    is_irrational = None
    is_number = True
    is_algebraic = False

    val='6.67384e-11'


    def _eval_evalf(self,prec):
        return N(self.val,prec)

    def __str__(self,*args):
        return 'G'

    def _sympystr(self,*args):
        return self.val

    def _latex(self,*args):
        return 'G'

G = Gravitation()


class Magnetic(NumberSymbol):

    is_real = True
    is_positive = True
    is_negative = False
    is_irrational = None
    is_number = True
    is_algebraic = False

    def _eval_evalf(self,prec):
        return N(S('4') * pi * 10**-7)

    def __str__(self,*args):
        return 'µ₀'

    #def _sympystr(self,*args):
    #    return self.val

    def _latex(self,*args):
        return 'µ_{0}'

magn = Magnetic()


class Electrical(NumberSymbol):

    is_real = True
    is_positive = True
    is_negative = False
    is_irrational = None
    is_number = True
    is_algebraic = False

    def _eval_evalf(self,prec):
        return N(S('1') / (magn * c ** 2), prec)

    def __str__(self,*args):
        return 'ε₀'

    #def _sympystr(self,*args):
    #    return self.val

    def _latex(self,*args):
        return 'ε_{0}'

e0 = Electrical()


class ElementaryCharge(NumberSymbol):

    is_real = True
    is_positive = True
    is_negative = False
    is_irrational = None
    is_number = True
    is_algebraic = False

    val='1.602176565e-19'


    def _eval_evalf(self,prec):
        return N(self.val,prec)

    def __str__(self,*args):
        return 'q'

    def _sympystr(self,*args):
        return self.val

    def _latex(self,*args):
        return 'q'

q = ElementaryCharge()

