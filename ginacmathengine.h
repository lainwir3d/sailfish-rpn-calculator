#ifndef GINACMATHENGINE_H
#define GINACMATHENGINE_H

#include "symbolicmathengine.h"
#include "ginacexpr.h"
#include <ginac/ginac.h>
#include <QHash>

typedef SymbolicExpr * (*MathFunction)(QList<SymbolicExpr *>);

class SymbolicMathFunction
{
public:
    SymbolicMathFunction(bool undo, qint16 operands, int operandsType, MathFunction func);
    bool undo() { return m_undo;}
    quint16 nbOperands() { return m_operands; }
    int operandsType() { return m_operandsType; }
    MathFunction func() { return m_func; }

private:
    bool m_undo;
    quint16 m_operands;
    int m_operandsType;

    MathFunction m_func;
};

class GiNacMathEngine : public SymbolicMathEngine
{
public:
    GiNacMathEngine();


    SymbolicExpr * strToExpr(QString e, bool rationalMode = false);
    bool operandValid(QString o);
    SymbolicExpr * addSymbol(QString e);
    SymbolicExpr * constants(QString e);

    static GiNacExpr * getOp(QList<SymbolicExpr *> ops, uint16 idx);
    static GiNaC::ex getOp_ex(QList<SymbolicExpr *> ops, uint16 idx);

    SymbolicMathFunction *getFunction(QString key);
    Features features();

    // math functions
    static SymbolicExpr * addall(QList<SymbolicExpr *> ops);
    static SymbolicExpr * suball(QList<SymbolicExpr *> ops);


private:
    QHash<QString, SymbolicMathFunction *> funcMap;
};

#endif // GINACMATHENGINE_H
