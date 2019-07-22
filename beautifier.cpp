#include "beautifier.h"

SimpleBeautifier::SimpleBeautifier()
{
    precision = 4;
    symbolicMode = true;
    rationalMode = true;
}

void SimpleBeautifier::setSymbolicMode(bool enabled)
{
    if(enabled != symbolicMode){
        symbolicMode = enabled;
    }
}

void SimpleBeautifier::setRationalMode(bool enabled)
{
    if(enabled != rationalMode){
        rationalMode = enabled;
    }
}

void SimpleBeautifier::setPrecision(quint8 p)
{
    if(p != precision){
        precision = p;
    }
}

QString SimpleBeautifier::beautifyElement(SymbolicExpr * e)
{
    QString expr_str;

    if(symbolicMode){
        expr_str = e->str();
    }else{
        expr_str = e->eval();
    }

    return expr_str;
}

QList<QString> SimpleBeautifier::beautifyStack(QList<SymbolicExpr *> stack)
{
    quint8 index = 1;

    QList<QString> model;

    for(int i = 0; i < stack.length() ; i++){
        model.append(beautifyElement(stack.at(i)));
    }

    return model;
}

void SimpleBeautifier::addEngine(SymbolicMathEngine *e)
{
    engines.append(e);
}


        //self._backends = None


    //def setBackends(self, e):
    //    self._backends = e
