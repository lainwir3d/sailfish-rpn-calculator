import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: calcScreen

    property alias contentHeight: listView.contentHeight
    property alias model: listView.model

    property alias view: listView

    GlassItem {
        id: divider

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        objectName: "menuitem"

        height: Theme.paddingLarge
        width: parent.width

        color: Theme.highlightColor
        opacity : (listView.height >= listView.contentHeight) || listView.atYBeginning ? 0.0 : 1.0

        Behavior on opacity { NumberAnimation {duration: 500} }

        cache: false
    }

    SilicaListView {
        id: listView

        anchors.fill: parent

        snapMode: ListView.NoSnap

        VerticalScrollDecorator {}

        delegate: StackFlick {
            id: stackFlick
            width: listView.width
            stack: currentStack
        }

    }

    GlassItem {
        id: divider2

        anchors.top: listView.bottom
        anchors.topMargin: (height/2)*-1
        anchors.horizontalCenter: parent.horizontalCenter

        objectName: "menuitem"

        height: Theme.paddingLarge
        width: parent.width

        color: Theme.highlightColor
        opacity: listView.atYEnd ? 0.0 : 1.0

        Behavior on opacity { NumberAnimation {duration: 500} }

        cache: false
    }
}
