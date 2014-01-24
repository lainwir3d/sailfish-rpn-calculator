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

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    /*
    Label {
        id: label
        anchors.centerIn: parent
        text: "My Cover"
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }
    }
    */

    Rectangle {
        id: screen
        color: Theme.secondaryHighlightColor
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        height: column.height + 10



        Column {
                id: column


                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 4
                    leftMargin: 4
                }
                width: parent.width - 10
                Row{
                    width: parent.width
                    Label {
                        id: stack_2_id
                        horizontalAlignment: Text.AlignLeft
                        color: Theme.primaryColor
                        text: "3:"
                    }
                    Label {
                        width: parent.width - stack_2_id.width - 4
                        horizontalAlignment: Text.AlignRight
                        text: calculator.main_stack[2]
                    }
                }
                Row{
                    width: parent.width
                    Label {
                        id: stack_1_id
                        horizontalAlignment: Text.AlignLeft
                        color: Theme.primaryColor
                        text: "2:"
                    }
                    Label {
                        width: parent.width - stack_1_id.width - 4
                        horizontalAlignment: Text.AlignRight
                        text: calculator.main_stack[1]
                    }
                }
                Row{
                    width: parent.width
                    Label {
                        id: stack_0_id
                        horizontalAlignment: Text.AlignLeft
                        color: Theme.primaryColor
                        text: "1:"
                    }
                    Label {
                        width: parent.width - stack_0_id.width - 4
                        horizontalAlignment: Text.AlignRight
                        text: calculator.main_stack[0]
                    }
                }
        }
    }

    Image {
        anchors{
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 10
        }
        source: "sailfish-rpn-calculator.png"
    }
}


