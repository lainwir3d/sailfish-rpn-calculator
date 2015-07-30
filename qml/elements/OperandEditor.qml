import QtQuick 2.0
import Sailfish.Silica 1.0

Row{
    id: operandEditor

    property bool operandInvalid: false
    property alias operand: operandLabel.text

    property alias backButton: backBtn

    spacing: 4
/*
    IconButton{
        id: kbdBtn
        width: height
        height: Theme.fontSizeExtraLarge + 10
        icon.source: "image://Theme/icon-l-dialpad"
        onClicked: {
            expressionInput.focus = expressionInput.focus ? false : true;
            //if(settings.vibration()){
            //    vibration.start();
            //}
        }
    }

    TextField {
        id: expressionInput
        visible: true
        anchors.top: parent.top

        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText

        background: Rectangle{
            color: "transparent"
        }

        EnterKey.enabled: page.engineLoaded
        EnterKey.text: "ENTER"

        EnterKey.onClicked: {
            if(currentOperandValid){
                page.formulaPush('', 'enter', 'stack');
                expressionInput.focus = false;
            }else{
                //long vibration
            }
        }
       }
    }
*/
    Label {
        id: operandLabel

        width: parent.width- backBtn.width -4
        height: Theme.fontSizeExtraLarge + 10

        horizontalAlignment: Text.AlignRight
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeExtraLarge
        color: operandEditor.operandInvalid ? "red" : "white"

        text: ""
    }

    IconButton{
        id: backBtn
        width: height
        height: Theme.fontSizeExtraLarge + 10
        icon.source: "image://Theme/icon-l-backspace"
    }
}
