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

Item{
    id: root
    height: columnA.height
    transformOrigin: Item.Bottom
    state: "current"

    property var stack;
    property int invertedIndex: memory.count - index

    Column {
        id: columnA

        width: parent.width - 8

        anchors{
            top: parent.top
            left: parent.left
            leftMargin: 4
        }

        spacing: 10

        Row{
            width: parent.width
            height: Theme.fontSizeExtraLarge

            spacing: 4

            Label {
                id: stack_2_id

                height: Theme.fontSizeExtraLarge + 10

                horizontalAlignment: Text.AlignLeft
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraLarge

                text: String(invertedIndex) + ":"
            }
            Label {
                id: stack_2

                width: invertedIndex == 1 ? parent.width - stack_2_id.width - dropBtn.width - 4 : parent.width - stack_2_id.width - 4 - 4
                height: Theme.fontSizeExtraLarge + 10

                horizontalAlignment: Text.AlignRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraLarge

                text: value
            }

            IconButton{
                id: dropBtn

                width: height
                height: Theme.fontSizeExtraLarge + 10

                visible: invertedIndex == 1 ? true : false

                icon.source: "image://Theme/icon-l-backspace"

                onClicked: {
                    stackDropFirst();
                    /*
                    if(settings.vibration()){
                        vibration.start();
                    }
                    */
                }
                onPressAndHold: {
                    stackDropAll();
                    /*
                    if(settings.vibration()){
                        longVibration.start();
                    }
                    */
                }
            }
        }

    }
}
