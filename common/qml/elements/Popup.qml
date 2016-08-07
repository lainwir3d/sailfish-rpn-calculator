import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea {
    id: popup
    anchors.top: parent.top

    property int padding: 5
    property int labelMargin: 5

    width: parent.width
    height: message.paintedHeight + padding

    property alias title: message.text
    property alias timeout: hideTimer.interval
    property alias background: bg.color

    property color defaultColor: "cyan"

    visible: opacity > 0
    opacity: 0.0

    Behavior on opacity {
        FadeAnimation {}
    }

    Rectangle {
        id: bg
        anchors.fill: parent
    }

    Timer {
        id: hideTimer
        triggeredOnStart: false
        repeat: false
        interval: 5000
        onTriggered: popup.hide()
    }

    function hide() {
        if (hideTimer.running)
            hideTimer.stop()
        popup.opacity = 0.0
    }

    function show() {
        popup.opacity = 1.0
        hideTimer.restart()
    }

    function notify(text, color) {
        popup.title = text
        if (color && (typeof(color) != "undefined"))
            bg.color = color
        else
            bg.color = Theme.rgba(defaultColor, 0.9)
        show()
    }

    Label {
        id: message
        anchors.verticalCenter: popup.verticalCenter
        font.pixelSize: 32
        anchors.left: parent.left
        anchors.leftMargin: labelMargin
        anchors.right: parent.right
        anchors.rightMargin: labelMargin
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        wrapMode: Text.Wrap
    }

    onClicked: hide()
}
