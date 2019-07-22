#ifndef SYMBOLICEXPR_H
#define SYMBOLICEXPR_H

#include <QObject>
#include <QString>
#include <QList>

class SymbolicExpr
{
public:
    SymbolicExpr();


    virtual QString str() { return QString(); }
    virtual QString eval() { return QString(); }
    virtual bool isEmpty() { return true; }
    virtual QList<QString> symbols() { return QList<QString>(); }

protected:
    QString m_str;
    QString m_eval;

};

#endif // SYMBOLICEXPR_H
