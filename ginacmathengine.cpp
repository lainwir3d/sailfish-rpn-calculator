#include "ginacmathengine.h"


#include <stdexcept>
#include <QDebug>
#include <QList>

using namespace std;
using namespace GiNaC;

SymbolicMathFunction::SymbolicMathFunction(bool undo, qint16 operands, int operandsType, MathFunction func)
{
    m_undo = undo;
    m_operands = operands;
    m_operandsType = operandsType;

    m_func = func;
}


GiNacMathEngine::GiNacMathEngine()
{

    funcMap.insert("+", new SymbolicMathFunction(true, 2, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(getOp_ex(ops,1) + getOp_ex(ops,0)); } ));
    funcMap.insert("-", new SymbolicMathFunction(true, 2, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(getOp_ex(ops,1) - getOp_ex(ops,0)); } ));
    funcMap.insert("mul", new SymbolicMathFunction(true, 2, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(getOp_ex(ops,1) * getOp_ex(ops,0)); } ));
    funcMap.insert("div", new SymbolicMathFunction(true, 2, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(getOp_ex(ops,1) / getOp_ex(ops,0)); } ));
    funcMap.insert("^", new SymbolicMathFunction(true, 2, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(GiNaC::pow(getOp_ex(ops,1),getOp_ex(ops,0))); } ));
    funcMap.insert("10^x", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(GiNaC::pow(10,getOp_ex(ops,0))); } ));
    funcMap.insert("x^2", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(GiNaC::pow(getOp_ex(ops,0),2)); } ));
    funcMap.insert("neg", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(getOp_ex(ops,0) * -1); } ));
    funcMap.insert("%", new SymbolicMathFunction(true, 2, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(getOp_ex(ops,0) * getOp_ex(ops,1) / 100); } ));
    funcMap.insert("inv", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(1 / getOp_ex(ops,0)); } ));
    funcMap.insert("sqrt", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(1 / getOp_ex(ops,0)); } ));
   //funcMap.insert("log", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(GiNaC::log(getOp_ex(ops,0)) / GiNaC::EulerEvalf()); } ));
    funcMap.insert("ln", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(GiNaC::log(getOp_ex(ops,0))); } ));
    funcMap.insert("e^x", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(GiNaC::exp(getOp_ex(ops,0))); } ));
    funcMap.insert("factorial", new SymbolicMathFunction(true, 1, 0, [](QList<SymbolicExpr *> ops) { return (SymbolicExpr *) new GiNacExpr(GiNaC::factorial(getOp_ex(ops,0))); } ));


    // non lambda function
    funcMap.insert("addall", new SymbolicMathFunction(true, -1, 0, addall));
    funcMap.insert("suball", new SymbolicMathFunction(true, -1, 0, suball));

    /*
    Backend.engineFunction("=", lambda op: sympy.N(op), operands=1)

    Backend.engineFunction("simplify", lambda op: sympy.simplify(op), operands=1)
    Backend.engineFunction("nthroot", lambda op: sympy.root(op[0], op[1]))
    Backend.engineFunction("ln", lambda op: sympy.log(op), operands=1)
  */
}

SymbolicExpr * GiNacMathEngine::strToExpr(QString s, bool rationalMode)
{
    //TODO: rational mode

    parser reader;

    SymbolicExpr * expr;

    try{
        ex e = reader(s.toStdString().c_str());

        expr = new GiNacExpr(e);
        return expr;

    }catch(exception &p){
        qDebug() << p.what();

        expr = new SymbolicExpr();
        return expr;
    }
}



bool GiNacMathEngine::operandValid(QString o)
{
    if(!o.isEmpty()){
        parser reader;
        try{
            ex e = reader(o.toStdString().c_str());
        }catch(exception &p){
            qDebug() << p.what();
            return false;
        }

        return true;
    }else{
        return true;
    }
}

SymbolicExpr * GiNacMathEngine::addSymbol(QString e)
{
    GiNaC::symbol s(e.toStdString().c_str());
    GiNaC::ex expr_ex = s;

    GiNacExpr * expr = new GiNacExpr(expr_ex);
    return expr;
}

SymbolicExpr *GiNacMathEngine::constants(QString e)
{
    //TODO
}

GiNacExpr *GiNacMathEngine::getOp(QList<SymbolicExpr *> ops, uint16 idx)
{
    GiNacExpr * expr = (GiNacExpr *) ops.at(idx);
    return expr;
}

GiNaC::ex GiNacMathEngine::getOp_ex(QList<SymbolicExpr *> ops, uint16 idx)
{
    GiNacExpr * expr = (GiNacExpr *) ops.at(idx);
    GiNaC::ex expr_ex = expr->getExpr();
    return expr_ex;
}

SymbolicMathFunction * GiNacMathEngine::getFunction(QString key)
{
    if(funcMap.contains(key)){
        return funcMap[key];
    }else{
        return NULL;
    }

}

SymbolicMathEngine::Features GiNacMathEngine::features()
{
    Features f = NoFeatures;

    f |= StringConversionFeature;
    f |= RationalFeature;
    f |= SymbolicFeature;

    return f;
}

SymbolicExpr *GiNacMathEngine::addall(QList<SymbolicExpr *> ops)
{
    GiNaC::ex e = getOp_ex(ops, ops.length() - 1);

    for(int i=ops.length()-2; i >= 0; i--){
        e = e + getOp_ex(ops, i);
    }

    return new GiNacExpr(e);
}

SymbolicExpr *GiNacMathEngine::suball(QList<SymbolicExpr *> ops)
{
    GiNaC::ex e = getOp_ex(ops, ops.length() - 1);

    for(int i=ops.length()-2; i >= 0; i--){
        e = e - getOp_ex(ops, i);
    }

    return new GiNacExpr(e);

}


/*
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
  */


/*
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
*/

