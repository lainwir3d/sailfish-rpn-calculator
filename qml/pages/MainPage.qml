/****************************************************************************************
**
** Copyright (C) 2013 Riccardo Ferrazzo <f.riccardo87@gmail.com>.
** All rights reserved.
**
** This program is based on ubuntu-calculator-app created by:
** Dalius Dobravolskas <dalius@sandbox.lt>
** Riccardo Ferrazzo <f.riccardo87@gmail.com>
**
** This file is part of ScientificCalc Calculator.
** ScientificCalc Calculator is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** ScientificCalc Calculator is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
****************************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import "../elements"
import "../engine.js" as CALC
//import QtFeedback 5.0

Page {
    id: page

    property string currentOperand: ''
    property bool currentOperandValid: true
    property var currentStack: []

    property bool engineLoaded: false

    /*
    HapticsEffect {
        id: vibration
        intensity: 0.8
        duration: 50
    }

    HapticsEffect {
        id: longVibration
        intensity: 0.8
        duration: 200
    }
    */

    Popup {
        id: popup
        z: 10

        timeout: 3000
    }

    Connections {
        target: settings
        onAngleUnitChanged: {
            python.changeTrigonometricUnit(settings.angleUnit);
        }
        onReprFloatPrecisionChanged: {
            python.changeReprFloatPrecision(settings.reprFloatPrecision);
        }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../../python'));

            setHandler('currentOperand', currentOperandHandler);
            setHandler('newStack', newStackHandler);
            setHandler('NotEnoughOperandsException', notEnoughOperandsExceptionHandler);
            setHandler('WrongOperandsException', wrongOperandsExceptionHandler);
            setHandler('ExpressionNotValidException', expressionNotValidExceptionHandler);
            setHandler('EngineLoaded', engineLoadedHandler);


            importModule('rpncalc_engine', function () {
                console.log("Module successfully imported. Loading engine.");
                popup.notify("Loading engine...");
            });
        }

        function engineLoadedHandler(){
            popup.notify("Engine loaded.");
            page.engineLoaded = true;
            changeTrigonometricUnit(settings.angleUnit);
            changeReprFloatPrecision(settings.reprFloatPrecision);
            pageStack.pushAttached(Qt.resolvedUrl("Settings.qml"));
        }

        function expressionNotValidExceptionHandler(){
            popup.notify("Expression not valid.");
        }

        function notEnoughOperandsExceptionHandler(nbExpected, nbAvailabled){
            popup.notify("Not enough operands. Expecting " + nbExpected + ".");
        }

        function wrongOperandsExceptionHandler(expectedOperands, nb){
            if(nb > 0){
                popup.notify("Wrongs operands. Expected " + nb + " " + operandTypeToString(expectedOperands) + ".");
            }else{
                popup.notify("Wrongs operands. Expected " + operandTypeToString(expectedOperands) + ".");
            }
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
            page.currentOperand = operand;
            page.currentOperandValid = valid;
        }

        function newStackHandler(stack){
            memory.clear();
            var i=0;
            for(i=stack.length-1; i>=0 ; i--){
                memory.append({isLastItem: i == stack.length ? true : false, value: stack[i]["expr"]})
                calcScreen.view.positionViewAtEnd();
            }

            //fill in first 10 of stack
            for(i=memory.count; i<1 ; i++){
                memory.insert(0, {isLastItem: i == stack.length ? true : false, value: ""});
                calcScreen.view.positionViewAtEnd();
            }

            page.currentStack = stack;
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
    }

    function formulaPush(visual, engine, type) {
        python.processInput(engine, type);
    }

    function stackDropFirst(){
        python.dropFirstStackOperand();
    }

    function stackDropAll(){
        python.dropAllStackOperand();
    }

    function formulaPop() {
        python.delLastOperandCharacter(); // might need an UNDO type of thing if last typed key != 1 character
    }

    function formulaReset() {
        python.clearCurrentOperand();
    }

    function formatNumber(n, maxsize){
        var str = String(n);
        var l = str.length;
        var round_n;

        if(l > maxsize){

            if(str.split('e').length > 1){
                round_n = Number(n).toPrecision(maxsize-5);
            }else{
                round_n = Number(n).toPrecision(maxsize);
                if(String(round_n).length > maxsize){
                    round_n = Number(n).toExponential(maxsize-4);
                }
            }

            str = String(round_n);
        }

        return str;
    }

    Item {
        id: heightMeasurement
        anchors.bottom: currentOperandEditor.top
        anchors.top: parent.top

        visible: false
    }

    CalcScreen {
        id: calcScreen

        anchors.bottom: currentOperandEditor.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: heightMeasurement.height > contentHeight ? contentHeight : heightMeasurement.height

        anchors.margins: 10
        clip: true

        model: Memory {
            id: memory
            stack: currentStack
        }
    }

    OperandEditor {
        id: currentOperandEditor

        anchors.bottom: kbd.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.leftMargin: 10

        operand: currentOperand
        operandInvalid: currentOperandValid ? false : true  // <= lol

        backButton.onClicked: {
            formulaPop();
            /*
            if(settings.vibration()){
                vibration.start();
            }
            */
        }

        backButton.onPressAndHold: {
            formulaReset();
            /*
            if(settings.vibration()){
                vibration.start();
            }
            */
        }
    }

    StdKeyboard {
        id: kbd
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20

        width: parent.width
    }
}


