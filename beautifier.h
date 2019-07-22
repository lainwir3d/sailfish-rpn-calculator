#ifndef BEAUTIFIER_H
#define BEAUTIFIER_H

#include <QtGlobal>
#include "symbolicexpr.h"
#include "symbolicmathengine.h"

class SimpleBeautifier
{
public:
    SimpleBeautifier();

    void setSymbolicMode(bool enabled);
    void setRationalMode(bool enabled);
    void setPrecision(quint8 p);
    QString beautifyElement(SymbolicExpr * e);
    QList<QString> beautifyStack(QList<SymbolicExpr *> stack);

    void addEngine(SymbolicMathEngine * e);

private:
    quint8 precision;
    bool symbolicMode;
    bool rationalMode;

    QList<SymbolicMathEngine *> engines;

};

#endif // BEAUTIFIER_H
