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
    property var currentStack: []

    //property string formula_text: '';
    //property string formula_text_for_engine: '';
    property string angularUnit: settings.angleUnit();
    //property var main_stack: CALC.main_stack;
    //property var formula: [];

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

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../../python'));
            /*setHandler('progress', function(ratio) {
                dlprogress.value = ratio;
            });
            */
            setHandler('currentOperand', currentOperandHandler);
            setHandler('newStack', newStackHandler);
            setHandler('NotEnoughOperandsException', notEnoughOperandsExceptionHandler);
            setHandler('WrongOperandsException', wrongOperandsExceptionHandler);
            setHandler('ExpressionNotValidException', expressionNotValidExceptionHandler);

            importModule('rpncalc_engine', function () {});
        }

        /*
        function startDownload() {
            page.downloading = true;
            dlprogress.value = 0.0;
            //call('datadownloader.downloader.download', function() {});
        }
        */

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


        function currentOperandHandler(operand){
            page.currentOperand = operand
        }

        function newStackHandler(stack){
            memory.clear();
            var i=0;
            for(i=stack.length-1; i>4 ; i--){
                memory.append({isLastItem: i == stack.length ? true : false, index: String(stack[i]["index"]), value: stack[i]["expr"]})
                formulaView.positionViewAtEnd();
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
/*
        var prev = null;
        if(formula_text_for_engine.length > 0){
            prev = formula_text_for_engine[formula_text_for_engine.length-1];
        }


        var tmp = main_stack;
        var result = CALC.processInput(prev, visual, engine, type, formula_text, formula_text_for_engine, angularUnit)
        main_stack = tmp;

        var visual_text = result[0];
        var engine_text = result[1];
        var fixed_type = result[2];
        formula_text = result[3];
        formula_text_for_engine = result[4];

        if (visual_text !== null && engine_text !== null) {
            formula_text += visual_text;
            formula_text_for_engine += engine_text;
            formula.push({'visual': visual_text, 'engine': engine_text, 'type': fixed_type});

        }

        memory.clear();
        for(var i=CALC.stackLength()-1; i>4;i--){
            memory.append({isLastItem: i == CALC.stackLength() ? true : false, index: String(i), value: main_stack[i]})
            formulaView.positionViewAtEnd();
        }
        */

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

    ListModel {
        id: viewModel

    }

    SilicaListView {
        id: formulaView
        anchors.fill: parent
        snapMode: ListView.NoSnap
        property int screenHeight: 0

        function showError() {
            animateError.start()
        }

        PropertyAnimation {id: animateError; target: formulaView; properties: "color"; from: "#FFA0A0"; to: "#FFFFFF"; duration: 100}

        delegate: StackFlick {
            id: stackFlick
            width: formulaView.width
            stack: currentStack

            Component.onCompleted: {
                if (formulaView.screenHeight == 0)
                    formulaView.screenHeight = height

            }


        }

        footer : StdKeyboard {
            width: parent.width
            height: page.height
        }

        model: Memory {
            id: memory
            stack: currentStack
        }

        PushUpMenu {
            MenuItem {
                property variant _modes: ["RAD", "DEG", "GRAD"];
                text: "Change mode to %1".arg(_modes[(_modes.indexOf(angularUnit)+1)%3])
                onClicked: {
                    angularUnit = _modes[(_modes.indexOf(angularUnit)+1)%3];
                    console.log("angularUnit : " + angularUnit);
                    settings.setAngleUnit(angularUnit);
                }
            }
            /*
            MenuItem {
                onClicked: {
                    console.log("vibration " + settings.vibration())
                    if(settings.vibration() === 0){
                        settings.setVibration(1);
                        text = "Set vibration OFF";
                    }else{
                        settings.setVibration(0);
                        text = "Set vibration ON";
                    }
                }
                Component.onCompleted: {
                    if(settings.vibration() === 0){
                        text = "Set vibration ON";
                    }else{
                        text = "Set vibration OFF";
                    }
                }
            }
            */
        }
    }


}


