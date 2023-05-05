import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea {
    property bool highlighted: false
    property color color: "black"
    property real highlightedOpacity: 0.3

    Rectangle {
        anchors.fill: parent

        color: parent.color

        opacity: highlighted ? highlightedOpacity : 0.0
    }

    onPressed: {
        highlighted = true;
    }

    onReleased: {
        highlighted = false;
    }

}
