import QtQuick 2.0
import QtQuick.Controls 1.4

MouseArea {
    id: buttonRect

    width: buttonWidth
    height: buttonHeigth

    property string rectColor: "transparent"
    property color rectBorderColor: "white"
    property int rectBorderWidth: 1
    property real rectOpacity: 1

    property int fontSize: mainLabel.font.pixelSize
    property int secondaryFontSize: fontSize / 2
    property color fontColor: "black"
    property color fontColorLeftOption: "orange"
    property color fontColorRightOption: "lightblue"

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
        height: secondaryFontSize.height

        horizontalAlignment: Text.AlignLeft
        font.pixelSize: secondaryFontSize - 2

        color: buttonRect.fontColorLeftOption
        text: actions[1].text
    }

    Label{
        id: blueLabel

        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.width / 2
        height: secondaryFontSize.height

        horizontalAlignment: Text.AlignRight
        font.pixelSize: secondaryFontSize - 2

        color: buttonRect.fontColorRightOption
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
        id: mainLabel
        //anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: rect.verticalCenter
        text: actions[0].text

        font.pixelSize: fontSize
        color: buttonRect.fontColor
    }

    /*
    onClicked: {
        if(settings.vibration()){
            vibration.start();
        }
    }
    */
}
