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

/*
IconButton {
    id: buttonRect
    width: buttonWidth
    height: buttonHeigth
    property string text
    Label{
        text: parent.text
    }
}
*/

/*
Rectangle{
    id: buttonRect
    property string text;
    width: buttonWidth
    height: buttonHeigth

    MouseArea {
        anchors.fill: parent
        onClicked: console.log("button clicked")
    }
    Label{
        text:parent.text
    }
}
*/

MouseArea {
    id: buttonRect
    property string text;
    width: buttonWidth
    height: buttonHeigth
    property string rectColor: "transparent"
    property real rectOpacity: 1

    Label{
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width / 2
        height: Theme.fontSizeTiny.height
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: Theme.fontSizeTiny - 3
        color: "orange"
        text:"item1"
    }

    Label{
        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.width / 2
        height: Theme.fontSizeTiny.height
        horizontalAlignment: Text.AlignRight
        font.pixelSize: Theme.fontSizeTiny - 3
        color: "lightblue"
        text:"item2"
    }

    Rectangle {
        //anchors.fill: parent
        id: rect
        width: parent.width
        height: parent.height - 20
        anchors.bottom: parent.bottom
        color: parent.rectColor
        border.width: 1
        border.color: Theme.secondaryColor
        radius: 10
        opacity: parent.rectOpacity
    }
    Label{
        //anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: rect.verticalCenter
        text:parent.text
    }
}
