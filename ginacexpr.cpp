#include "ginacexpr.h"

using namespace std;

GiNacExpr::GiNacExpr(GiNaC::ex e)
{
    expr = e;
}

QString GiNacExpr::str()
{
    stringstream out;

    out << expr;
    QString tmp = QString::fromStdString(out.str());

    m_str = QString::fromStdString(out.str());

    return m_str;
}

QString GiNacExpr::eval()
{
    m_eval = QString();
    return m_eval;
}

GiNaC::ex GiNacExpr::getExpr()
{
    return expr;
}
