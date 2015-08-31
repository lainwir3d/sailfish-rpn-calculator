import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: symbolPage

    property string pageName: "Symbols"
    property var symbols: []

    Component.onCompleted: {
        for (var i=0; i<symbols.length; i++) {
            symbolModel.append(symbols[i]);
        }
    }

    ListModel {
        id: symbolModel
    }

    SilicaListView {
        id: view

        header: PageHeader {
            id: header
            title: pageName
        }

        model: symbolModel

        anchors.fill: parent

        delegate: BackgroundItem {
            width: ListView.view.width

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: Theme.paddingLarge

                text: displayName
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
            }
        }
    }
}
