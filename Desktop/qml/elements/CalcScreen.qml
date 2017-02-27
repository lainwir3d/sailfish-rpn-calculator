import QtQuick 2.0

Item{
    id: calcScreen

    property alias contentHeight: listView.contentHeight
    property alias model: listView.model

    property alias view: listView

    /*
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
    */

    ListView {
        id: listView

        anchors.fill: parent

        snapMode: ListView.NoSnap

        //VerticalScrollDecorator {}

        property Item contextMenu

        delegate: Item {
            id: myListItem
            property bool menuOpen: view.contextMenu != null && view.contextMenu.parent === myListItem

            width: view.width
            height: menuOpen ? view.contextMenu.height + stackFlick.height : stackFlick.height

            StackFlick {
                id: stackFlick

                stack: currentStack

                width: view.width

                fontSize: fontSizeExtraLarge
                //fontFamily: Theme.fontFamily

                dropIcon: "image://Theme/icon-l-backspace"

                elementScrollDecorator: Item{} /*HorizontalScrollDecorator{
                    height: Math.round(Theme.paddingSmall/4)

                    opacity: 0.5    // always visible
                }*/

                onPressAndHold: {
                    if (!view.contextMenu)
                        view.contextMenu = contextMenuComponent.createObject(view);

                    view.contextMenu.showOptionsForItem(myListItem, stackFlick);
                }
            }
        }


        Component {
            id: contextMenuComponent
            Item {}
/*
            ContextMenu {
                id: menu

                property Item currentItem
                property int toDrop: -1
                property int toPick: -1
                onClosed: {
                     if(toDrop != -1){
                         stackDropUIIndex(toDrop);
                         toDrop = -1;
                     }

                     if(toPick != -1){
                         stackPickUIIndex(toPick);
                         toPick = -1;
                     }
                }

                function showOptionsForItem(showItem, item){
                    menu.currentItem = item;
                    menu.show(showItem);
                }

                Row {
                    width: parent ? parent.width : Screen.width
                    height: Theme.itemSizeSmall
                    BackgroundItem {
                        width: parent.width / 3
                        Label{
                            text: "Pick"
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            if(menu.currentItem){
                                menu.toPick = menu.currentItem.invertedIndex; // do not drop immediately, wait after menu is closed.
                            }

                            menu.hide();
                        }
                    }
                    BackgroundItem {
                        width: parent.width / 3
                        Label{
                            text: "Drop"
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            if(menu.currentItem){
                                menu.toDrop = menu.currentItem.invertedIndex; // do not drop immediately, wait after menu is closed.
                            }

                            menu.hide();
                        }
                    }
                    BackgroundItem {
                        width: parent.width / 3
                        Label{
                            text: "Copy"
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            copyToClipboard(menu.currentItem.text);
                            menu.hide();
                            popup.notify("Copied to clipboard !");
                        }
                    }
                }
            }*/
        }
    }

    /*
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
    */
}
