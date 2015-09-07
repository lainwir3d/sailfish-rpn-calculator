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

Item {
    width: parent.width
    height: keyboard.height + 5

    property int buttonWidth: 85
    property int buttonHeigth: 80

    property alias action: keyboard.action

    Column{
        id: keyboard
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 5

        property int action: 0

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            KeyboardButton {
                actions: [{text: '√x', visual:'', engine:'sqrt', type:'function', enabled: true},
                {text: 'ˣ√y', visual:'', engine:'nthroot', type:'function', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'eˣ', visual:'', engine:'e^x', type:'function', enabled: true},
                {text: 'ln', visual:'', engine:'ln', type:'function', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '10ˣ', visual:'', engine:'10^x', type:'operation', enabled: true},
                {text: 'log', visual:'', engine:'log', type:'function', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: "yˣ", visual:'', engine:'^', type:'operation', enabled: true},
                {text: 'x²', visual:'', engine:'x^2', type:'operation', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '1/x', visual:'', engine:'inv', type:'function', enabled: true},
                {text: 'x!', visual:'', engine:'factorial', type:'function', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                actions: [{text: 'Σ+', visual:'', engine:'addall', type:'operation', enabled: true},
                {text: 'Σ-', visual:'', engine:'suball', type:'operation', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'R↓', visual:'', engine:'R-', type:'stack', enabled: true},
                    {text: 'R↑', visual:'', engine:'R+', type:'stack', enabled: true},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'sin', visual:'', engine:'sin', type:'function', enabled: true},
                {text: 'asin', visual:'', engine:'asin', type:'function', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'cos', visual:'', engine:'cos', type:'function', enabled: true},
                {text: 'acos', visual:'', engine:'acos', type:'function', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'tan', visual:'', engine:'tan', type:'function', enabled: true},
                {text: 'atan', visual:'', engine:'atan', type:'function', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                width: buttonWidth*2 + 20
                actions: [{text: 'ENTER', visual:'', engine:'enter', type:'stack', enabled: true},
                {text: '=', visual:'', engine:'=', type:'operation', enabled: engineLoaded},
                {text: 'simplify', visual:'', engine:'simplify', type:'function', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'x↔y', visual:'', engine:'swap', type:'stack', enabled: true},
                    {text: '8bit', visual:'', engine:'u8bit', type:'operation', enabled: engineLoaded},
                    {text: '16bit', visual:'', engine:'u16bit', type:'operation', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }


            KeyboardButton {
                actions: [{text: '+/-', visual:'', engine:'neg', type:'operation', enabled: true},
                {text: 'SHL', visual:'', engine:'shl', type:'operation', enabled: engineLoaded},
                {text: 'SHR', visual:'', engine:'shr', type:'operation', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'DROP', visual:'', engine:'drop', type:'stack', enabled: true},
                {text: 'CLR', visual:'', engine:'clr', type:'stack', enabled: true},
                {text: 'UNDO', visual:'', engine:'undo', type:'stack', enabled: true}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }
        }


        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                actions: [{text: 'EEX', visual:'e', engine:'e', type:'exp', enabled: true},
                    {text: '%', visual:'', engine:'%', type:'function', enabled: true},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '7', visual:'7', engine:'7', type:'number', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false},
                {text: 'x', visual:'', engine:'x', type:'symbol', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '8', visual:'8', engine:'8', type:'number', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false},
                {text: 'y', visual:'', engine:'y', type:'symbol', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '9', visual:'9', engine:'9', type:'number', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false},
                {text: 'z', visual:'', engine:'z', type:'symbol', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '÷', visual:'', engine:'div', type:'operation', enabled: true},
                {text: 'AND', visual:'', engine:'_and', type:'operation', enabled: engineLoaded},
                {text: 'NAND', visual:'', engine:'_nand', type:'operation', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }


        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                rectColor: "orange"
                rectOpacity: keyboard.action == 1 ? 0.7 : 0.3

                mode: keyboard.action

                actions: [{text: '', visual:'', engine:'', type:'', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: true}]

                onClicked: {
                    if(keyboard.action == 0){
                        keyboard.action = 1;
                    }else if(keyboard.action == 1){
                        keyboard.action = 0;
                    }
                }
            }

            KeyboardButton {
                actions: [{text: '4', visual:'4', engine:'4', type:'number', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '5', visual:'5', engine:'5', type:'number', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '6', visual:'6', engine:'6', type:'number', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false},
                {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '×', visual:'', engine:'mul', type:'operation', enabled: true},
                {text: 'OR', visual:'', engine:'_or', type:'operation', enabled: engineLoaded},
                {text: 'NOR', visual:'', engine:'_nor', type:'operation', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }


        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                rectColor: "lightblue"
                rectOpacity: keyboard.action == 2 ? 0.7 : 0.3

                actions: [{text: '', visual:'', engine:'', type:'', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: true}]

                mode: keyboard.action

                onClicked: {
                    if(keyboard.action == 0){
                        keyboard.action = 2;
                    }else if(keyboard.action == 2){
                        keyboard.action = 0;
                    }
                }
            }

            KeyboardButton {
                actions: [{text: '1', visual:'1', engine:'1', type:'number', enabled: true},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '2', visual:'2', engine:'2', type:'number', enabled: true},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '3', visual:'3', engine:'3', type:'number', enabled: true},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '−', visual:'', engine:'-', type:'operation', enabled: true},
                {text: 'XOR', visual:'', engine:'_xor', type:'operation', enabled: engineLoaded},
                {text: 'XNOR', visual:'', engine:'_xnor', type:'operation', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                actions: [{text: 'C', visual:'', engine:'', type:'', enabled: true},
                {text: ' ', visual:'', engine:'', type:'', enabled: false},
                {text: 'dice', visual:'', engine:'dice', type:'dice', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    if(keyboard.action == 0){
                        formulaPop()
                    }else{
                        formulaPush(actions[keyboard.action].visual,
                                    actions[keyboard.action].engine,
                                    actions[keyboard.action].type);
                    }
                }
            }

            KeyboardButton {
                text: "0"
                actions: [{text: '0', visual:'0', engine:'0', type:'number', enabled: true},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '.', visual:'.', engine:'.', type:'real', enabled: true},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'π', visual:'π', engine:'pi', type:'constant', enabled: true},
                    {text: ' ', visual:'', engine:'', type:'', enabled: false},
                    {text: 'const', visual:'', engine:'constantList', type:'constantList', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '+', visual:'', engine:'+', type:'operation', enabled: true},
                {text: 'NOT', visual:'', engine:'_not', type:'operation', enabled: engineLoaded},
                {text: '2CMP', visual:'', engine:'_2cmp', type:'operation', enabled: engineLoaded}]

                mode: keyboard.action

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

        }
       }

}
