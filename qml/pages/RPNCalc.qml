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

Page {
    id: page

    property string formula_text: '';
    property string brackets_added: '';
    property string formula_text_for_engine: '';
    property string answer: '';
    property string angularUnit: "RAD";
    property var main_stack: CALC.main_stack;

    property var formula: [];



    function formulaPush(visual, engine, type) {
        var prev = null;
        if (formula.length > 0)
            prev = formula[formula.length-1];


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

        if(l > maxsize){
            var tmp = str.split('.');
            var int_length = tmp[0].length;
            var real_length = tmp[1].length;

            var precision = Math.pow(10, real_length - (l - maxsize));

            var round_n = Math.round(n * precision) / precision;
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
                }
            }
        }
    }


}


