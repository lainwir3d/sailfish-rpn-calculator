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
import io.thp.pyotherside 1.3
import "../elements"
//import QtFeedback 5.0

Page {
    id: page

    // should be set from python engine in the parent
    property string currentOperand: ''
    property bool currentOperandValid: true
    property var currentStack: []
    property bool engineLoaded: false

    // View properties. Python engine might access this
    property alias screen: calcScreen
    property alias notification: popup

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

    Connections {
        target: settings
        onAngleUnitChanged: {
            python.changeTrigonometricUnit(settings.angleUnit);
        }
        onReprFloatPrecisionChanged: {
            python.changeReprFloatPrecision(settings.reprFloatPrecision);
        }
        onAutoSimplifyChanged: {
            python.enableAutoSimplify(settings.autoSimplify);
        }
        onSymbolicModeChanged: {
            python.enableSymbolicMode(settings.symbolicMode);
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

    function stackDropUIIndex(idx){
        var engineIdx = idx - 1;
        python.dropStackOperand(engineIdx);
    }

    function stackPickUIIndex(idx){
        var engineIdx = idx - 1;
        python.pickStackOperand(engineIdx);
    }

    function formulaPop() {
        python.delLastOperandCharacter(); // might need an UNDO type of thing if last typed key != 1 character
    }

    function formulaReset() {
        python.clearCurrentOperand();
    }

    function resetKeyboard() {
        kbd.action = 0;
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

    function copyToClipboard(value){
        Clipboard.text = value;
    }

    Item {
        id: heightMeasurement
        anchors.bottom: currentOperandEditor.top
        anchors.top: parent.top

        visible: false
    }

    Popup {
        id: popup
        z: 10

        timeout: 3000
    }

    CalcScreen {
        id: calcScreen

        anchors.bottom: currentOperandEditor.top
        anchors.left: parent.left
        anchors.right: parent.right

        // Don't why I need 10 here... without it GlassItem is displayed too low
        height: heightMeasurement.height + 10 > contentHeight ? contentHeight : heightMeasurement.height + 10

        clip: true

        model: memory
    }

    OperandEditor {
        id: currentOperandEditor

        anchors.bottom: infosRow.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.leftMargin: 10

        operand: page.currentOperand
        operandInvalid: page.currentOperandValid ? false : true  // <= lol

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

    Row {
        id: infosRow

        anchors.bottom: kbd.top
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottomMargin: 10

        spacing: 15

        Label {
            id: mode

            text: !page.engineLoaded ? "Degraded" : settings.symbolicMode ? "Symbolic" : "Numeric"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeExtraSmall
            //font.bold: !engineLoaded

            color: !page.engineLoaded ? "red" : Theme.secondaryColor
        }


        Label {
            id: unit

            text: settings.angleUnit
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeExtraSmall

            color: Theme.secondaryColor
        }

    }

    StdKeyboard {
        id: kbd

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.paddingMedium
        anchors.bottomMargin: Theme.paddingLarge

        columnSpacing: Theme.paddingSmall
        rowSpacing: Theme.paddingLarge

        buttonWidth: (width - (rowSpacing * 4)) / 5
        buttonHeigth: buttonWidth * 16/17
    }
}


