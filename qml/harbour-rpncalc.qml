/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "pages"
import "elements"

ApplicationWindow
{
    id: root

    initialPage: MainPage { id:calculator; currentStack: root.currentStack ;currentOperand: root.currentOperand; currentOperandValid: root.currentOperandValid; engineLoaded: root.engineLoaded}
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    property string currentOperand: ''
    property bool currentOperandValid: true
    property var currentStack: []

    property bool engineLoaded: false

    Memory {
        id: memory
        stack: currentStack
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'));

            setHandler('currentOperand', currentOperandHandler);
            setHandler('newStack', newStackHandler);
            setHandler('NotEnoughOperandsException', notEnoughOperandsExceptionHandler);
            setHandler('WrongOperandsException', wrongOperandsExceptionHandler);
            setHandler('ExpressionNotValidException', expressionNotValidExceptionHandler);
            setHandler('BackendException', backendExceptionHandler);
            setHandler('EngineLoaded', engineLoadedHandler);
            setHandler('symbolsPush', symbolsPushHandler);


            importModule('rpncalc_engine', function () {
                console.log("Module successfully imported. Loading engine.");
                changeTrigonometricUnit(settings.angleUnit);
                changeReprFloatPrecision(settings.reprFloatPrecision);
                newStackHandler([]);

                pageStack.pushAttached(Qt.resolvedUrl("pages/Settings.qml"));
            });
        }

        function engineLoadedHandler(){
            calculator.notification.notify("Symbolic engine loaded");
            engineLoaded = true;

            changeTrigonometricUnit(settings.angleUnit);
            changeReprFloatPrecision(settings.reprFloatPrecision);
            enableSymbolicMode(settings.symbolicMode);
            enableAutoSimplify(settings.autoSimplify);
        }

        function expressionNotValidExceptionHandler(){
            calculator.notification.notify("Expression not valid.");
        }

        function backendExceptionHandler(){
            calculator.notification.notify("Error.");
        }

        function notEnoughOperandsExceptionHandler(nbExpected, nbAvailabled){
            calculator.notification.notify("Not enough operands. Expecting " + nbExpected + ".");
        }

        function wrongOperandsExceptionHandler(expectedOperands, nb){
            if(nb > 0){
                calculator.notification.notify("Wrongs operands. Expected " + nb + " " + operandTypeToString(expectedOperands) + ".");
            }else{
                calculator.notification.notify("Wrongs operands. Expected " + operandTypeToString(expectedOperands) + ".");
            }
        }

        function enableSymbolicMode(enabled){
            call("rpncalc_engine.engine.setSymbolicMode", [enabled], function (){});
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
            currentOperand = operand;
            currentOperandValid = valid;
        }

        function newStackHandler(stack){
            memory.clear();
            var i=0;
            for(i=stack.length-1; i>=0 ; i--){
                memory.append({isLastItem: i == stack.length ? true : false, value: stack[i]["expr"]})
                calculator.screen.view.positionViewAtEnd();
            }

            //fill in first 10 of stack
            for(i=memory.count; i<1 ; i++){
                memory.insert(0, {isLastItem: i == stack.length ? true : false, value: ""});
                calculator.screen.view.positionViewAtEnd();
            }

            currentStack = stack;
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
            pageStack.push(Qt.resolvedUrl("SymbolPage.qml"), {"mainPage": page, "pageName": pageName, "symbols": symbols});
        }
    }
}


