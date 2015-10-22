import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: root
    height: columnA.height
    transformOrigin: Item.Bottom
    state: "current"

    property var stack;
    property int invertedIndex: memory.count - index
    property string text: value

    property alias highlighted : bg.highlighted

    signal pressAndHold()
    signal clicked()

    Column {
        id: columnA

        width: parent.width

        anchors{
            top: parent.top
            left: parent.left
        }

        spacing: 10

        BackgroundItem {
            id: bg

            width: parent.width
            height: Theme.fontSizeExtraLarge

            property int flickableSize: bg.width - 10 - idLabel.width - 10 - flickable.anchors.rightMargin - (dropBtn.visible ? dropBtn.width + 10 : 0)

            Label {
                id: idLabel

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                height: Theme.fontSizeExtraLarge + 10

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraLarge

                text: String(invertedIndex) + ":"
            }

            Flickable {
                id: flickable

                height: Theme.fontSizeExtraLarge

                width: bg.flickableSize

                anchors.right: dropBtn.visible ? dropBtn.left : parent.right
                anchors.rightMargin: dropBtn.visible ? 10 : 20
                anchors.verticalCenter: parent.verticalCenter

                contentHeight: height
                contentWidth: flicked.width

                clip: true

                HorizontalScrollDecorator{
                    height: Math.round(Theme.paddingSmall/4)

                    opacity: 0.5    // always visible
                }

                Item {
                    id: flicked

                    anchors.verticalCenter: parent.verticalCenter

                    width: Math.max(valueLabel.paintedWidth, bg.flickableSize)
                    height: Theme.fontSizeExtraLarge + 10

                    Label {
                        id: valueLabel

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        height: Theme.fontSizeExtraLarge + 10

                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeExtraLarge
                        truncationMode: TruncationMode.Fade

                        text: value
                    }

                    MouseArea {
                        id: mouseA
                        anchors.fill: parent

                        onPressed: {
                            bg.highlighted = true;
                        }

                        onReleased: {
                            bg.highlighted = false;
                        }

                        onCanceled: {
                            bg.highlighted = false;
                        }

                        onClicked: {
                            root.clicked();
                        }

                        onPressAndHold: {
                            bg.highlighted = false;
                            root.pressAndHold();
                        }
                    }
                }
            }

            IconButton{
                id: dropBtn

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10

                width: height
                height: Theme.fontSizeExtraLarge + 10

                visible: invertedIndex === 1

                icon.source: "image://Theme/icon-l-backspace"

                onClicked: {
                    stackDropFirst();
                    /*
                    if(settings.vibration()){
                        vibration.start();
                    }
                    */
                }
                onPressAndHold: {
                    stackDropAll();
                    /*
                    if(settings.vibration()){
                        longVibration.start();
                    }
                    */
                }
            }
        }

    }
}
