import QtQuick 2.0
import QtQuick.Controls 1.4
import "../elements"

Item {
    id: symbolPage

    property color primaryColor: "white"
    property color secondaryHighlightColor: "white"
    property color secondaryColor: "lightblue"
    property int paddingSmall: 5
    property int paddingMedium: 8
    property int paddingLarge: 10
    property int marginSmall: 5
    property int fontSizeExtraSmall: 10
    property int fontSizeExtraLarge: 14
    property int fontSizeMedium: 12
    property int fontSizeSmall: 11
    property int fontSizeTiny: 8

    property var mainPage: parent
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

    ListView {
        id: view

        model: symbolModel

        anchors.fill: parent

        delegate: CustomBackgroundItem {
            width: ListView.view.width

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: paddingLarge

                text: displayName
                color: highlighted ? highlightColor : primaryColor
            }

            onClicked: {
                mainPage.formulaPush(displayName, name, type);
                mainPage.resetKeyboard();
                pageStack.pop()
            }
        }
    }
}
