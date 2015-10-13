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

MouseArea {
    id: buttonRect

    width: buttonWidth
    height: buttonHeigth

    property string rectColor: "transparent"
    property variant rectBorderColor: Theme.secondaryColor
    property int rectBorderWidth: 1
    property real rectOpacity: 1

    property string text;
    property variant actions: [{text: ' ', visual:'', engine:'', type:'', enabled: false},
        {text: ' ', visual:'', engine:'', type:'', enabled: false},
        {text: ' ', visual:'', engine:'', type:'', enabled: false}];

    property int mode: 0
    property real disabledOpacity: 0.1
    enabled: actions[mode].enabled
    opacity: enabled ? 1: disabledOpacity

    Behavior on opacity { NumberAnimation { duration: 500 } }

    Label{
        id: orangeLabel

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width / 2
        height: Theme.fontSizeTiny.height

        horizontalAlignment: Text.AlignLeft
        font.pixelSize: Theme.fontSizeTiny - 2

        color: "orange"
        text: actions[1].text
    }

    Label{
        id: blueLabel

        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.width / 2
        height: Theme.fontSizeTiny.height

        horizontalAlignment: Text.AlignRight
        font.pixelSize: Theme.fontSizeTiny - 2

        color: "lightblue"
        text: actions[2].text
    }

    Rectangle {
        //anchors.fill: parent
        id: rect
        width: parent.width
        height: parent.height - blueLabel.paintedHeight
        anchors.bottom: parent.bottom
        color: parent.rectColor
        border.width: rectBorderWidth
        border.color: rectBorderColor
        radius: 10
        opacity: parent.rectOpacity
    }

    Label{
        //anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: rect.verticalCenter
        text: actions[0].text
    }

    /*
    onClicked: {
        if(settings.vibration()){
            vibration.start();
        }
    }
    */
}
