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
    height: keyboard.height + 24

    property int buttonWidth: 85
    property int buttonHeigth: 80

    CalcScreen{
        id: calcScreen
        width: formulaView.width - 8
        stack: main_stack
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

    }


    Column{
        id: keyboard
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        spacing: 5

        property int action: 0

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            KeyboardButton {
                actions: [{text: '√x', visual:'', engine:'sqrt', type:'function'},
                {text: 'x²', visual:'', engine:'x^2', type:'operation'},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'eˣ', visual:'', engine:'e^x', type:'function'},
                {text: 'ln', visual:'', engine:'ln', type:'function'},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '10ˣ', visual:'', engine:'10^x', type:'operation'},
                {text: 'log', visual:'', engine:'log', type:'function'},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: "yˣ", visual:'', engine:'^', type:'operation'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '1/x', visual:'', engine:'inv', type:'function'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

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
                actions: [{text: 'Σ+', visual:'', engine:'Σ+', type:'operation'},
                {text: 'Σ-', visual:'', engine:'Σ-', type:'operation'},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
              actions: [{text: 'R↓', visual:'', engine:'R-', type:'stack'},
                    {text: 'R↑', visual:'', engine:'R+', type:'stack'},
                    {text: ' ', visual:'', engine:'', type:''}]

                    onClicked: {
                        formulaPush(actions[keyboard.action].visual,
                                    actions[keyboard.action].engine,
                                    actions[keyboard.action].type);
                        keyboard.action = 0;
                    }
            }

            KeyboardButton {
                actions: [{text: 'sin', visual:'', engine:'sin', type:'function'},
                {text: 'asin', visual:'', engine:'asin', type:'function'},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'cos', visual:'', engine:'cos', type:'function'},
                {text: 'acos', visual:'', engine:'acos', type:'function'},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'tan', visual:'', engine:'tan', type:'function'},
                {text: 'atan', visual:'', engine:'atan', type:'function'},
                {text: ' ', visual:'', engine:'', type:''}]

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
                actions: [{text: 'ENTER', visual:'', engine:'enter', type:'stack'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'x↔y', visual:'', engine:'swap', type:'stack'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }


            KeyboardButton {
                actions: [{text: '+/-', visual:'', engine:'neg', type:'operation'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: 'DROP', visual:'', engine:'drop', type:'stack'},
                {text: 'CLR', visual:'', engine:'clr', type:'stack'},
                {text: 'UNDO', visual:'', engine:'undo', type:'stack'}]

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

            }

            KeyboardButton {
                actions: [{text: '7', visual:'7', engine:'7', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '8', visual:'8', engine:'8', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '9', visual:'9', engine:'9', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '÷', visual:'', engine:'/', type:'operation'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

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

                onClicked: {
                    if(keyboard.action == 0){
                        keyboard.action = 1;
                    }else if(keyboard.action == 1){
                        keyboard.action = 0;
                    }
                }
            }

            KeyboardButton {
                actions: [{text: '4', visual:'4', engine:'4', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '5', visual:'5', engine:'5', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '6', visual:'6', engine:'6', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '×', visual:'', engine:'*', type:'operation'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

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


                onClicked: {
                    if(keyboard.action == 0){
                        keyboard.action = 2;
                    }else if(keyboard.action == 2){
                        keyboard.action = 0;
                    }
                }
            }

            KeyboardButton {
                actions: [{text: '1', visual:'1', engine:'1', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '2', visual:'2', engine:'2', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '3', visual:'3', engine:'3', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '−', visual:'', engine:'-', type:'operation'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

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
                actions: [{text: 'C', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: formulaPop()
            }

            KeyboardButton {
                text: "0"
                actions: [{text: '0', visual:'0', engine:'0', type:'number'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {
                actions: [{text: '.', visual:'.', engine:'.', type:'real'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

                onClicked: {
                    formulaPush(actions[keyboard.action].visual,
                                actions[keyboard.action].engine,
                                actions[keyboard.action].type);
                    keyboard.action = 0;
                }
            }

            KeyboardButton {

            }

            KeyboardButton {
                actions: [{text: '+', visual:'', engine:'+', type:'operation'},
                {text: ' ', visual:'', engine:'', type:''},
                {text: ' ', visual:'', engine:'', type:''}]

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
