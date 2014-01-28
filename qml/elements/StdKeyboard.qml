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

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            KeyboardButton {
                text: "√x"
                onClicked: formulaPush('', 'sqrt', 'function')
            }

            KeyboardButton {
                text: " "

            }

            KeyboardButton {
                text: "ln"
                onClicked: formulaPush('', 'ln', 'function')
            }

            KeyboardButton {
                text: "^"
                onClicked: formulaPush('', '^', 'operation')
            }

            KeyboardButton {
                text: "1/x"
                onClicked: formulaPush('', 'inv', 'function')
            }

            /*
            KeyboardButton {
                text: "Σ"
                onClicked: formulaPush('Σ', 'Σ', 'operation')
            }
            */
        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                text: " "
            }

            KeyboardButton {
                text: " "
            }

            KeyboardButton {
                text: "sin"
                onClicked: formulaPush('', 'sin', 'function')
            }

            KeyboardButton {
                text: "cos"
                onClicked: formulaPush('', 'cos', 'function')
            }

            KeyboardButton {
                text: "tan"
                onClicked: formulaPush('', 'tan', 'function')
            }

        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                text: "ENTER"
                width: buttonWidth*2 + 20
                onClicked: formulaPush('', 'enter', 'stack')
            }

            KeyboardButton {
                text: "x↔y"
                onClicked: formulaPush('', 'swap', 'stack')
            }


            KeyboardButton {
                text: "+/-"
                onClicked: formulaPush('', 'neg', 'operation')
            }

            KeyboardButton {
                text: " "
            }

            /*
            KeyboardButton {
                text: " "
            }
            */
        }


        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                text: " "
            }

            KeyboardButton {
                text: "7"
                onClicked: formulaPush('7', '7', 'number')
            }

            KeyboardButton {
                text: "8"
                onClicked: formulaPush('8', '8', 'number')
            }

            KeyboardButton {
                text: "9"
                onClicked: formulaPush('9', '9', 'number')
            }

            KeyboardButton {
                text: "÷"
                onClicked: formulaPush('', '/', 'operation')
            }


        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                text: " "
                rectColor: "orange"
                rectOpacity: 0.4
            }

            KeyboardButton {
                text: "4"
                onClicked: formulaPush('4', '4', 'number')
            }

            KeyboardButton {
                text: "5"
                onClicked: formulaPush('5', '5', 'number')
            }

            KeyboardButton {
                text: "6"
                onClicked: formulaPush('6', '6', 'number')
            }

            KeyboardButton {
                text: "×"
                onClicked: formulaPush('', '*', 'operation')
            }


        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                text: " "
                rectColor: "lightblue"
                rectOpacity: 0.4
            }

            KeyboardButton {
                text: "1"
                onClicked: formulaPush('1', '1', 'number')
            }

            KeyboardButton {
                text: "2"
                onClicked: formulaPush('2', '2', 'number')
            }

            KeyboardButton {
                text: "3"
                onClicked: formulaPush('3', '3', 'number')
            }

            KeyboardButton {
                text: "−"
                onClicked: formulaPush('', '-', 'operation')
            }

        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            KeyboardButton {
                text: "C"
                onClicked: {
                    formulaView.addCurrentToMemory();
                    formulaReset();
                }
            }

            KeyboardButton {
                text: "0"
                onClicked: formulaPush('0', '0', 'number')
            }

            KeyboardButton {
                text: "."
                onClicked: formulaPush('.', '.', 'real')
            }

            KeyboardButton {
                text: " "
            }

            KeyboardButton {
                text: "+"
                onClicked: formulaPush('', '+', 'operation')
            }

        }
       }

}
