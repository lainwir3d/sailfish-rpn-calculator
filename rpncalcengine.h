#ifndef RPNCALCENGINE_H
#define RPNCALCENGINE_H

#include <QObject>
#include <QString>
#include "symbolicmathengine.h"
#include "ginacmathengine.h"
#include "symbolicexpr.h"
#include "beautifier.h"

class RpnCalcEngine : public QObject
{
    Q_OBJECT
    Q_ENUMS(OperandTypes)
public:
    explicit RpnCalcEngine();

    enum OperandType {
        All = 0,
        Integer = 1,
        Float = 2
    };
    Q_DECLARE_FLAGS(OperandTypes, OperandType)

    Q_INVOKABLE bool validateExpression(QString expr);
    Q_INVOKABLE void processInput(QString input, QString type);
    Q_INVOKABLE void clearCurrentOperand();
    Q_INVOKABLE void delLastOperandCharacter();
    Q_INVOKABLE void dropFirstStackOperand();
    Q_INVOKABLE void dropAllStackOperand();
    Q_INVOKABLE void dropStackOperand(int idx);
    Q_INVOKABLE void pickStackOperand(int idx);

signals:
    void newStack(QList<QString> stack);

    void featureNotSupportedException();
    void notEnoughOperandsException(int nbExpected);
    void wrongOperandsException();
    void expressionNotValidException();
    void backendException();
    void undoException();

    void stackPopPush(int pop, QString el);
    void stackPop(int nb);

    void currentOperandChanged(const QString &operand, const bool &valid);

public slots:

private:
    void updateCurrentOperand();

    SymbolicMathEngine * backend;
    SimpleBeautifier * beautifier;

    QString currentOperand;
    QString undoCurrentOperand;

    QList<SymbolicExpr *> stack;
    QList<SymbolicExpr *> undoStack;

    QList<QString> stack_str;
    QList<QString> undoStack_str;


    void pushUndo();
    void stackPush(SymbolicExpr * expr, bool notify = true, int pop = 0);
    void updateStack();
    void stackDropFirst();
    void stackDropAll();

    void stackInputProcessor(QString input);
    void operationInputProcessor(QString input);
    void constantInputProcessor(QString input);
    void functionInputProcessor(QString input);

    QList<SymbolicExpr *> getOperands(qint16 nb = 2, OperandType types = OperandType::All);
};

Q_DECLARE_OPERATORS_FOR_FLAGS(RpnCalcEngine::OperandTypes)

#endif // RPNCALCENGINE_H
