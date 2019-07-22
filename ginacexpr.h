#ifndef GINACEXPR_H
#define GINACEXPR_H

#include "symbolicexpr.h"

#include <ginac/ginac.h>
#include <QDebug>
#include <QString>

using namespace std;

class GiNacExpr : public SymbolicExpr
{
public:
    GiNacExpr(GiNaC::ex e);

    QString str();
    QString eval();
    GiNaC::ex getExpr();

    bool isEmpty() { return false; } //TODO

private:
    GiNaC::ex expr;
};

#endif // GINACEXPR_H
