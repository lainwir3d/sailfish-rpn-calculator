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
import "../elements"
import "../engine.js" as CALC
import QtFeedback 5.0

Page {
    id: page

    property string formula_text: '';
    property string brackets_added: '';
    property string formula_text_for_engine: '';
    property string answer: '';
    property string angularUnit: settings.angleUnit();
    property var main_stack: CALC.main_stack;

    property var formula: [];

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

    function formulaPush(visual, engine, type) {

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

    }

    function stackDropFirst(){
        var tmp = main_stack;
        CALC.stackPop(1);
        main_stack = tmp;

        memory.clear();
        for(var i=CALC.stackLength()-1; i>4;i--){
            memory.append({isLastItem: i == CALC.stackLength() ? true : false, index: String(i), value: main_stack[i]})
            formulaView.positionViewAtEnd();
        }
    }

    function stackDropAll(){
        var tmp = main_stack;
        CALC.stackPop(20);
        main_stack = tmp;

        memory.clear();
        for(var i=CALC.stackLength()-1; i>4;i--){
            memory.append({isLastItem: i == CALC.stackLength() ? true : false, index: String(i), value: main_stack[i]})
            formulaView.positionViewAtEnd();
        }
    }

    function formulaPop() {
        if (formula.length > 0) {
            var prev = formula[formula.length-1];
            formula_text = formula_text.substring(0, formula_text.length - prev.visual.length);
            formula_text_for_engine = formula_text_for_engine.substring(0, formula_text_for_engine.length - prev.engine.length);
            if (prev.type === 'function' || (prev.type === 'group' && prev.engine === '(' || prev.engine === '*('))
                brackets_added = brackets_added.substring(0, brackets_added.length-2)
            else if (prev.type === 'group' && prev.engine === ')')
                brackets_added += " )"
            formula.pop();

        }
    }

    function formulaReset() {
        formula_text = '';
        formula_text_for_engine = '';
        formula = [];
        answer = "";
        brackets_added = '';
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

    SilicaListView {
        id: formulaView
        anchors.fill: parent
        snapMode: ListView.NoSnap
        property string currentFormula: '%1<font color="lightgray">%2</font>'.arg(formula_text).arg(brackets_added)
        property string currentAnswer: answer
        property int screenHeight: 0

        function showError() {
            animateError.start()
        }

        PropertyAnimation {id: animateError; target: formulaView; properties: "color"; from: "#FFA0A0"; to: "#FFFFFF"; duration: 100}

        delegate: StackFlick {
            id: stackFlick
            width: formulaView.width
            stack: main_stack

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
            stack: main_stack
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
            MenuItem {
                //text: "Vibration " + (settings.vibration() === 0 ?  "OFF": "ON")
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
        }
    }


}


