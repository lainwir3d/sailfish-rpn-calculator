/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import io.thp.pyotherside 1.3
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2
import "pages"
import "elements"

Item
{
    id: root

    //initialPage: (Screen.sizeCategory > Screen.Medium) ? wideLandscapeView : portraitView

    property string currentOperand: ''

    property bool currentOperandValid: true
    property var currentStack: []

    property bool engineLoaded: false
    property alias memoryModel: memory

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
        onRationalModeChanged: {
            python.enableRationalMode(settings.rationalMode);
        }
    }

    StackView {
        id: stackView
        anchors.fill:parent
        initialItem: portraitView

        delegate: StackViewDelegate {
            function getTransition(properties)
            {
                var transitionName = properties.enterItem.transitionName ? properties.enterItem.transitionName : properties.exitItem.transitionName ? properties.exitItem.transitionName : properties.name;
                return this[transitionName];
            }

            function transitionFinished(properties)
            {
                properties.exitItem.x = 0;
                properties.exitItem.y = 0;

                properties.exitItem.opacity = 1
            }

            pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: target.width
                    to: 0
                    duration: 300
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: -target.width
                    duration: 300
                }
            }

            popTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: -target.width
                    to: 0
                    duration: 300
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: target.width
                    duration: 300
                }
            }

            replaceTransition: fadeTransition

            property Component fadeTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: target.opacity
                    duration: 300
                }
                PropertyAnimation {
                    target: exitItem
                    property: "opacity"
                    from: target.opacity
                    to: 0
                    duration: 300
                }
            }
        }
    }

    Image {
            id: background
            anchors.fill: parent
            z:-1

            source: Qt.resolvedUrl("qrc:///bg.jpg")

            visible: false
        }

        FastBlur{
            anchors.fill: background
            source: background
            radius: 64

            z:-1

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.RightButton

                onClicked: {
                    if(stackView.depth > 1){
                        stackView.pop();
                    }
                }
            }
        }

    Component {
        id: portraitView

        MainPage {
            id: mainPage
            currentStack: root.currentStack
            currentOperand: root.currentOperand
            currentOperandValid: root.currentOperandValid
            engineLoaded: root.engineLoaded
        }
    }
/*
    Component {
        id: wideLandscapeView

        WideLandscape {
            currentStack: root.currentStack
            currentOperand: root.currentOperand
            currentOperandValid: root.currentOperandValid
            engineLoaded: root.engineLoaded
        }
    }
*/

    Memory {
        id: memory
        stack: currentStack
    }

    PythonGlue {
        id: python

        screenObj: stackView.currentItem.screen
        notificationObj: stackView.currentItem.notification
        stackObj: stackView
        memoryObj: memory
    }
}


