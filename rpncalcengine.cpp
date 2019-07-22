#include "rpncalcengine.h"

#include <QDebug>

RpnCalcEngine::RpnCalcEngine() : QObject()
{
    backend = new GiNacMathEngine();
    beautifier = new SimpleBeautifier();
    currentOperand = QString("");
}

bool RpnCalcEngine::validateExpression(QString expr)
{
    return false;
}

void RpnCalcEngine::processInput(QString input, QString type)
{
    qDebug() << "processInput " << input << "type" << type;

    if(type == "number"){
        currentOperand.append(input);
        updateCurrentOperand();
    }else if(type == "exp"){
        if(currentOperand.isEmpty()){
            currentOperand.append("1e");
        }else{
            currentOperand.append("e");
        }
        updateCurrentOperand();
    }else if(type == "stack"){
        stackInputProcessor(input);
    }else if(type == "operation"){
        operationInputProcessor(input);
    }else if(type == "symbol"){
        pushUndo();

        if(backend->features() && SymbolicMathEngine::SymbolicFeature){
            SymbolicExpr * expr = backend->addSymbol(input);
            stackPush(expr);
        }
    }else if(type == "constant"){
        constantInputProcessor(input);
    }else if(type == "real"){
        if(!currentOperand.contains(".")){
            currentOperand.append(input);
            updateCurrentOperand();
        }
    }else if(type == "function"){
        functionInputProcessor(input);
    }else if(type == "dice"){
        //pyotherside.send("symbolsPush", "Dices", [{"displayName": "d4", "name": "d4", "type": "function"},
        //    {"displayName": "d6", "name": "d6", "type": "function"},
        //    {"displayName": "d8", "name": "d8", "type": "function"},
        //    {"displayName": "d10", "name": "d10", "type": "function"},
        //    {"displayName": "d12", "name": "d12", "type": "function"},
        //    {"displayName": "d20", "name": "d20", "type": "function"},
        //    {"displayName": "d100", "name": "d100", "type": "function"}
        //    ])
    }else if(type == "constantList"){
        //pyotherside.send("symbolsPush", "Constants", self._backends[0].constantsArray)
    }else{
        qDebug() << __func__ << " type=" << type;
    }
}

void RpnCalcEngine::clearCurrentOperand()
{
    currentOperand.clear();
    updateCurrentOperand();
}

void RpnCalcEngine::delLastOperandCharacter()
{
    currentOperand.remove(-1,1);
    updateCurrentOperand();
}

void RpnCalcEngine::dropFirstStackOperand()
{
    stackDropFirst();
}

void RpnCalcEngine::dropAllStackOperand()
{
    stackDropAll();
}

void RpnCalcEngine::dropStackOperand(int idx)
{
    if(this->stack.length() > idx){
        stack.removeAt(idx);
        updateStack();
    }
}

void RpnCalcEngine::pickStackOperand(int idx)
{
    if(stack.length() > idx){
        SymbolicExpr * e = stack.at(idx);
        stack.removeAt(idx);
        stack.prepend(e);
        updateStack();
    }
}

void RpnCalcEngine::updateCurrentOperand()
{
    emit currentOperandChanged(this->currentOperand, this->backend->operandValid(this->currentOperand));
}

void RpnCalcEngine::pushUndo()
{
    undoStack = stack;
    undoCurrentOperand = currentOperand;
}

/*
void RpnCalcEngine::stackPush(QList<SymbolicExpr *> expr, bool notify)
{
    qDebug() << __func__ << ": Not Implemented";
}
*/

void RpnCalcEngine::stackPush(SymbolicExpr * expr, bool notify, int pop)
{
    /*
    for(int i=0; i < pop; i++){
        stack.removeFirst();
    }
    */
    stack.prepend(expr);

    clearCurrentOperand();

    if(notify){
        QString el = beautifier->beautifyElement(expr);
        emit stackPopPush(pop, el);
    }
}

void RpnCalcEngine::updateStack()
{
    QList<QString> dstack = beautifier->beautifyStack(stack);
    emit newStack(dstack);
}

void RpnCalcEngine::stackDropFirst()
{
    if(stack.length() > 0){
        stack.removeFirst();
        emit stackPop(1);
    }
}

void RpnCalcEngine::stackDropAll()
{
    if(stack.length() > 0){
        stack.clear();
        emit stackPop(-1);
    }
}

void RpnCalcEngine::stackInputProcessor(QString input)
{
    if(input == "enter"){
        pushUndo();

        SymbolicExpr * expr = NULL;
        if(!this->currentOperand.isEmpty()){
            if(!backend->operandValid(currentOperand)){
                emit expressionNotValidException();
                return;
            }

            if(backend->features() & SymbolicMathEngine::StringConversionFeature) {
                if(backend->features() & SymbolicMathEngine::RationalFeature) {
                    expr = backend->strToExpr(currentOperand);
                    stackPush(expr);
                }
            }else{
                emit featureNotSupportedException();
            }

        }else if(!stack.empty()){
            expr = stack.at(0);
            stackPush(expr);
        }

    }else if(input == "swap"){
        if(stack.length() > 1){
            pushUndo();

            SymbolicExpr * op0 = stack.at(0);
            SymbolicExpr * op1 = stack.at(1);

            stack.replace(0, op1);
            stack.replace(1, op0);

            updateStack();
        }
    }else if(input == "drop"){
        pushUndo();
        stackDropFirst();
    }else if(input == "clr"){
        pushUndo();
        stackDropAll();
    }else if(input == "undo"){

        SymbolicExpr * expr = NULL;
        if(!undoCurrentOperand.isEmpty()){
            if(!backend->operandValid(undoCurrentOperand)){
                emit undoException();
                return;
            }

            expr = NULL;
            if(backend->features() && SymbolicMathEngine::StringConversionFeature){
                if(backend->features() && SymbolicMathEngine::RationalFeature){
                    expr = backend->strToExpr(undoCurrentOperand);
                }else{
                    expr = backend->strToExpr(undoCurrentOperand);
                }
            }else{
                emit backendException();
            }
        }

        stack = undoStack;
        if(expr){
            stackPush(expr, false);
        }

        undoCurrentOperand = "";
        updateCurrentOperand();
        updateStack();
    }else if(input == "R-"){
        pushUndo();

        if(stack.length() > 1){
            stack.append(stack.at(0));
            stack.removeAt(0);
            updateStack();
        }
    }else if(input == "R+"){
        pushUndo();

        if(stack.length() > 1){
            stack.prepend(stack.last());
            stack.removeLast();
            updateStack();
        }
    }
}

void RpnCalcEngine::operationInputProcessor(QString input)
{
    if((input == "neg") && currentOperand.endsWith("e")){
        currentOperand.append("-");
        updateCurrentOperand();
        return;
    }

    SymbolicMathFunction * f = ((GiNacMathEngine *)  backend)->getFunction(input);
    if(!f){
        emit backendException();
        return;
    }

    if(f->undo()){
        pushUndo();
    }

    qint16 nbOperands = f->nbOperands();
    QList<SymbolicExpr *> ops = getOperands(f->nbOperands(), (OperandType) f->operandsType());

    if(ops.length() < nbOperands){
        qDebug("shit");
        return; // TODO: check for type of error here instead of getOperands?
    }

    int nbToPop = nbOperands;
    if(!currentOperand.isEmpty()){
        if(nbToPop > 0){
            nbToPop--;
        }
    }


    SymbolicExpr * expr = (*(f->func()))(ops);
    qDebug() << "result=" << expr->str();

    if(expr){
        stackPush(expr, true, nbToPop);
    }else{
        emit backendException();
    }
}

void RpnCalcEngine::constantInputProcessor(QString input)
{
    qDebug() << __func__ << ": Not Implemented";
    pushUndo();
    SymbolicExpr * expr = backend->constants(input);
    stackPush(expr);
}

void RpnCalcEngine::functionInputProcessor(QString input)
{


    if((input == "neg") && currentOperand.endsWith("e")){
        currentOperand.append("-");
        updateCurrentOperand();
        return;
    }

    SymbolicMathFunction * f = ((GiNacMathEngine *)  backend)->getFunction(input);
    if(!f){
        emit backendException();
        return;
    }

    if(f->undo()){
        pushUndo();
    }

    int nbOperands = f->nbOperands();
    QList<SymbolicExpr *> ops = getOperands(f->nbOperands(), (OperandType) f->operandsType());

    if(ops.length() < nbOperands){
        return; // TODO: check for type of error here instead of getOperands?
    }

    int nbToPop = nbOperands;
    if(!currentOperand.isEmpty()){
        if(nbToPop > 0){
            nbToPop--;
        }
    }


    SymbolicExpr * expr = (*(f->func()))(ops);

    if(expr){
        stackPush(expr, true, nbToPop);
    }else{
        emit backendException();
    }
}

QList<SymbolicExpr *> RpnCalcEngine::getOperands(qint16 nb, RpnCalcEngine::OperandType types)
{
    int nbAvailable = 0;
    int nbneeded = nb;

    QList<SymbolicExpr *> operands = QList<SymbolicExpr *>();

    if(!currentOperand.isEmpty()){
      nbAvailable++;
    }

    nbAvailable += stack.length();

    if(nbneeded == -1){
        nbneeded = stack.length();
        if(!currentOperand.isEmpty()){
            nbneeded++;
        }
    }

    if(nbneeded == 0){
        return operands;
    }else if(nbneeded <= nbAvailable){
        int nbToPop = 0;
        int rangeEnd = nbneeded;

        if(!currentOperand.isEmpty()){
            rangeEnd--;
        }

        for(int i=0; i<rangeEnd ; i++){
            operands.append(stack.at(i));
            nbToPop++;
        }

        if(operands.length() < nbneeded){
            if(!backend->operandValid(currentOperand)){
                emit expressionNotValidException();
            }

            if(backend->features() && (SymbolicMathEngine::StringConversionFeature && SymbolicMathEngine::RationalFeature)){
                operands.prepend(backend->strToExpr(currentOperand));
            }else{
                emit backendException();
            }
        }


        bool typesOk = true;
        int exposedExceptionNb = 0;

        //TODO
        /*
        typesOk = True
        exposedExceptionNb = 0
        try: # types is iterable, multiple types given. Checking against each operand.
            i = 0
            for t in types:
                if len(types) != len(ops):  # late checking for length, because we had to know that it was iterable before
                    raise CannotVerifyOperandsTypeException()
                typesOk = typesOk and self.__verifyType(ops[i], t)
                i += 1
        except TypeError: # types is not iterable
            for o in ops:
                typesOk = typesOk and self.__verifyType(o, types)
            exposedExceptionNb = nb  # expose number of required operand type to exception, since we do not have details.
        */

        if(typesOk){
            for(int i = 0; i<nbToPop; i++){
                stack.removeFirst();
            }
            return operands;
        }else{
            emit wrongOperandsException();
        }
    }else{
        emit notEnoughOperandsException(nb);
        return operands;
    }
}
