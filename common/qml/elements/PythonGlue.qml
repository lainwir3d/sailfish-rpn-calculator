import QtQuick 2.2
import io.thp.pyotherside 1.3
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2

Python {
    id: python

    property var screenObj
    property var notificationObj
    property var stackObj
    property var memoryObj
    property var settingsObj

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../../python'));

        setHandler('currentOperand', currentOperandHandler);
        setHandler('newStack', newStackHandler);
        setHandler('stackPopPush', stackPopPushHandler);
        setHandler('stackPop', stackPopHandler);
        setHandler('NotEnoughOperandsException', notEnoughOperandsExceptionHandler);
        setHandler('WrongOperandsException', wrongOperandsExceptionHandler);
        setHandler('ExpressionNotValidException', expressionNotValidExceptionHandler);
        setHandler('BackendException', backendExceptionHandler);
        setHandler('EngineLoaded', engineLoadedHandler);
        setHandler('symbolsPush', symbolsPushHandler);


        importModule('rpncalc_engine', function () {
            console.log("Module successfully imported. Loading engine.");
            changeTrigonometricUnit(settingsObj.angleUnit);
            changeReprFloatPrecision(settingsObj.reprFloatPrecision);
            newStackHandler([]);

           // this was sailfish only
           //stackObj.pushAttached(Qt.resolvedUrl("../pages/Settings.qml"));
        });
    }

    function engineLoadedHandler(){
        notificationObj.notify("Symbolic engine loaded");
        root.engineLoaded = true;

        changeTrigonometricUnit(settingsObj.angleUnit);
        changeReprFloatPrecision(settingsObj.reprFloatPrecision);
        enableSymbolicMode(settingsObj.symbolicMode);
        enableAutoSimplify(settingsObj.autoSimplify);
    }

    function expressionNotValidExceptionHandler(){
        notificationObj.notify("Expression not valid.");
    }

    function backendExceptionHandler(){
        notificationObj.notify("Error.");
    }

    function notEnoughOperandsExceptionHandler(nbExpected, nbAvailabled){
        notificationObj.notify("Not enough operands. Expecting " + nbExpected + ".");
    }

    function wrongOperandsExceptionHandler(expectedOperands, nb){
        if(nb > 0){
            notificationObj.notify("Wrongs operands. Expected " + nb + " " + operandTypeToString(expectedOperands) + ".");
        }else{
            notificationObj.notify("Wrongs operands. Expected " + operandTypeToString(expectedOperands) + ".");
        }
    }

    function enableSymbolicMode(enabled){
        call("rpncalc_engine.engine.setSymbolicMode", [enabled], function (){});
    }

    function enableRationalMode(enabled){
        call("rpncalc_engine.engine.setRationalMode", [enabled], function (){});
    }

    function enableAutoSimplify(enabled){
        call("rpncalc_engine.engine.setAutoSimplify", [enabled], function (){});
    }

    function changeTrigonometricUnit(unit){
        call("rpncalc_engine.engine.changeTrigonometricUnit", [unit], function (){});
    }

    function changeReprFloatPrecision(prec){
        call("rpncalc_engine.engine.setBeautifierPrecision", [prec], function (){});
    }

    function operandTypeToString(operands){
        var i = 0;
        var rstr = "";
        for(i=0; i< operands.length; i++){
            switch(Number(operands[i])){
                case 1:
                    rstr += "Integer,";
                    break;
                case 2:
                    rstr += "Float,";
                    break;
            }
        }
        rstr = rstr.substring(0, rstr.length-1);

        if(operands.length > 1){
            rstr = "(" + rstr + ")";
        }
        return rstr;
    }


    function currentOperandHandler(operand, valid){
        root.currentOperand = operand;
        root.currentOperandValid = valid;
    }

    function newStackHandler(stack){
        memoryObj.clear();
        var i=0;
        for(i=stack.length-1; i>=0 ; i--){
            memoryObj.append({isLastItem: i == stack.length ? true : false, value: stack[i]["expr"]})
        }

        updateFakeFirstElements();

        screenObj.view.positionViewAtEnd();

        currentStack = stack;
    }

    function stackPopPushHandler(pop, el){
        if(pop > 0){
            memoryObj.remove(memoryObj.count - pop, pop);
        }else if(pop < 0){
            memoryObj.clear();
        }

        memoryObj.append({isLastItem: true, value: el["expr"]});
        updateFakeFirstElements();
        screenObj.view.positionViewAtEnd();
    }

    function stackPopHandler(nb){
        if(nb > 0){
            memoryObj.remove(memoryObj.count - nb, nb);
        }else if(nb < 0){
            memoryObj.clear();
        }

        updateFakeFirstElements();
    }

    function updateFakeFirstElements(){
        if(memoryObj.count == 0){
            memoryObj.insert(0, {isLastItem: true, value: ""});
        }else{
            if(memoryObj.get(0).value == ""){
                memoryObj.remove(0);
            }
        }
    }

    function processInput(input, type){
        call("rpncalc_engine.engine.processInput", [input, type], function (){});
    }

    function clearCurrentOperand(){
        call("rpncalc_engine.engine.clearCurrentOperand", function(){});
    }

    function delLastOperandCharacter(){
        call("rpncalc_engine.engine.delLastOperandCharacter", function(){});
    }

    function dropFirstStackOperand(){
        call("rpncalc_engine.engine.stackDropFirst", function(){});
    }

    function dropAllStackOperand(){
        call("rpncalc_engine.engine.stackDropAll", function(){});
    }

    function dropStackOperand(idx){
        call("rpncalc_engine.engine.stackDrop", [idx], function(){});
    }

    function pickStackOperand(idx){
        call("rpncalc_engine.engine.stackPick", [idx], function(){});
    }

    function symbolsPushHandler(pageName, symbols){
        stackObj.push(Qt.resolvedUrl("../pages/SymbolPage.qml"), {"mainPage": stackObj.currentPage, "pageName": pageName, "symbols": symbols});
    }
}
