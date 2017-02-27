import QtQuick 2.0

MouseArea {
    property bool highlighted: false
    property color color: "transparent"

    Rectangle {
        anchors.fill: parent

        color: parent.color
    }
}
