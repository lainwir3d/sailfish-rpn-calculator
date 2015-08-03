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

        width: parent.width

        anchors{
            top: parent.top
            left: parent.left
        }

        spacing: 10

        BackgroundItem {
            id: bg

            width: parent.width
            height: Theme.fontSizeExtraLarge

            property int flickableSize: bg.width - 10 - idLabel.width - 10 - flickable.anchors.rightMargin - (dropBtn.visible ? dropBtn.width + 10 : 0)

            Label {
                id: idLabel

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                height: Theme.fontSizeExtraLarge + 10

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraLarge

                text: String(invertedIndex) + ":"
            }

            Flickable {
                id: flickable

                height: Theme.fontSizeExtraLarge

                width: bg.flickableSize

                anchors.right: dropBtn.visible ? dropBtn.left : parent.right
                anchors.rightMargin: dropBtn.visible ? 10 : 20
                anchors.verticalCenter: parent.verticalCenter

                contentHeight: height
                contentWidth: flicked.width

                clip: true

                onDragEnded: {
                    if(bg.highlighted) {
                        bg.highlighted = false;
                    }
                }

                HorizontalScrollDecorator{
                    height: Math.round(Theme.paddingSmall/4)

                    opacity: 0.5    // always visible
                }

                Item {
                    id: flicked

                    anchors.verticalCenter: parent.verticalCenter

                    width: Math.max(valueLabel.paintedWidth, bg.flickableSize)
                    height: Theme.fontSizeExtraLarge + 10

                    Label {
                        id: valueLabel

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        height: Theme.fontSizeExtraLarge + 10

                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeExtraLarge
                        truncationMode: TruncationMode.Fade

                        text: value
                    }

                    MouseArea {
                        id: mouseA
                        anchors.fill: parent

                        onPressed: {
                            bg.highlighted = true;
                        }

                        onReleased: {
                            bg.highlighted = false;
                        }

                        onClicked: {
                            console.log("clicked !");
                        }

                        onPressAndHold: {
                            console.log("long press !");
                        }
                    }
                }
            }

            IconButton{
                id: dropBtn

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10

                width: height
                height: Theme.fontSizeExtraLarge + 10

                visible: invertedIndex === 1

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
