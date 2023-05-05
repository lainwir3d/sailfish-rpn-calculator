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
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "pages"
import "elements"

ApplicationWindow
{
    id: root
      ListModel {
        id: memory

        property var stack
      }
    /*initialPage: MainPage{
        currentStack: root.currentStack
        currentOperand: root.currentOperand
        currentOperandValid: root.currentOperandValid
        engineLoaded: root.engineLoaded
    }*/
    //(Screen.sizeCategory > Screen.Medium) ? wideLandscapeView : portraitView
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

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

    Component {
        id: portraitView

        MainPage {
            currentStack: root.currentStack
            currentOperand: root.currentOperand
            currentOperandValid: root.currentOperandValid
            engineLoaded: root.engineLoaded
        }
    }

    Component {
        id: wideLandscapeView

        WideLandscape {
            currentStack: root.currentStack
            currentOperand: root.currentOperand
            currentOperandValid: root.currentOperandValid
            engineLoaded: root.engineLoaded
        }
    }

    onDeviceOrientationChanged: {

        if(deviceOrientation & Orientation.LandscapeMask){
            if((orientation & Orientation.PortraitMask) && (Screen.sizeCategory > Screen.Medium)){
                pageStack.replaceAbove(0, wideLandscapeView);
            }
        }else{
            if(orientation & Orientation.LandscapeMask){
                pageStack.replaceAbove(0, portraitView);
            }
        }
    }


    PythonGlue {
        id: python

        screenObj: pageStack.currentPage.screen
        notificationObj: pageStack.currentPage.notification
        stackObj: pageStack
        memoryObj: memory
        settingsObj: settings
    }
}


