import QtQuick 2.0
import QtQuick.Controls 1.4

Item{
    id: operandEditor

    property bool operandInvalid: false
    property alias operand: operandLabel.text

    property alias backButton: backBtn

    height: backBtn.height

    property int flickableSize: width - flickable.anchors.rightMargin - backBtn.width - 10

    property string backIcon: ""

    property int fontSize: 10
    property string fontFamily: "helvetica"

    property Component elementScrollDecorator: Item{}
    property int horizontalScrollPadding: 10

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

        height: fontSize

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

        Loader{
            sourceComponent: elementScrollDecorator
        }

        Item {
            id: flicked

            anchors.verticalCenter: parent.verticalCenter

            width: Math.max(operandLabel.paintedWidth, operandEditor.flickableSize)
            height: fontSize + 10

            Label {
                id: operandLabel

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                height: fontSize + 10

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.family: fontFamily
                font.pixelSize: fontSize
                //truncationMode: TruncationMode.Fade

                color: operandEditor.operandInvalid ? "red" : "white"

                text: ""

                onTextChanged: {
                    flickable.flickToRightEdge();
                }
            }
        }
    }

    MouseArea{
        id: backBtn

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        width: height
        height: fontSize + 10

        Image {
            anchors.fill: parent

            source: backIcon
        }
    }
}
