import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: operandEditor

    property bool operandInvalid: false
    property alias operand: operandLabel.text

    property alias backButton: backBtn

    height: backBtn.height

    property int flickableSize: width - flickable.anchors.rightMargin - backBtn.width - 10

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

    Flickable {
        id: flickable

        height: Theme.fontSizeExtraLarge

        width: operandEditor.flickableSize

        anchors.right: backBtn.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        contentHeight: height
        contentWidth: flicked.width

        clip: true

        function flickToRightEdge(){
            if((operandLabel.paintedWidth > operandEditor.flickableSize) && !atXEnd){
                console.log("flick !!");
                contentX = operandLabel.paintedWidth - flickable.width;
            }
        }

        HorizontalScrollDecorator{
            height: Math.round(Theme.paddingSmall/4)

            opacity: 0.5    // always visible
        }

        Item {
            id: flicked

            anchors.verticalCenter: parent.verticalCenter

            width: Math.max(operandLabel.paintedWidth, operandEditor.flickableSize)
            height: Theme.fontSizeExtraLarge + 10

            Label {
                id: operandLabel

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                height: Theme.fontSizeExtraLarge + 10

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraLarge
                truncationMode: TruncationMode.Fade

                color: operandEditor.operandInvalid ? "red" : "white"

                text: ""

                onTextChanged: {
                    flickable.flickToRightEdge();
                }
            }
        }
    }

    IconButton{
        id: backBtn

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        width: height
        height: Theme.fontSizeExtraLarge + 10
        icon.source: "image://Theme/icon-l-backspace"
    }
}
