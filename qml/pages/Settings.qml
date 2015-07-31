import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Page {
    id :settingsPage

    PageHeader {
        id: header
        title: "Settings"
    }

    SilicaFlickable {
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height

        //contentWidth: column.width; contentHeight: column.height

        Column {
            id: column
            spacing: 10


            width:parent.width
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            //anchors.fill: parent

            ComboBox{
                label: "Trigonometric unit"
                currentIndex: settings.angleUnit == "Degree" ? 1 : settings.angleUnit == "Gradient" ? 2 : 0

                menu: ContextMenu {
                    MenuItem { text: "Radian" }
                    MenuItem { text: "Degree" }
                    MenuItem { text: "Gradient" }
                }

                onCurrentItemChanged: {
                    settings.angleUnit = currentItem.text;
                }
            }

            ComboBox{
                label: "Stack view precision"
                currentIndex: settings.reprFloatPrecision - 1

                menu: ContextMenu {
                    MenuItem { text: "1"; }
                    MenuItem { text: "2"; }
                    MenuItem { text: "3"; }
                    MenuItem { text: "4"; }
                    MenuItem { text: "5"; }
                    MenuItem { text: "6"; }
                    MenuItem { text: "7"; }
                    MenuItem { text: "8"; }
                    MenuItem { text: "9"; }
                    MenuItem { text: "10"; }
                    MenuItem { text: "11"; }
                    MenuItem { text: "12"; }
                    MenuItem { text: "13"; }
                    MenuItem { text: "14"; }
                    MenuItem { text: "15"; }
                    MenuItem { text: "16"; }
                    MenuItem { text: "17"; }
                    MenuItem { text: "18"; }
                    MenuItem { text: "19"; }
                    MenuItem { text: "20"; }
                    MenuItem { text: "21"; }
                    MenuItem { text: "22"; }
                    MenuItem { text: "23"; }
                    MenuItem { text: "24"; }
                    MenuItem { text: "25"; }
                    MenuItem { text: "26"; }
                    MenuItem { text: "27"; }
                    MenuItem { text: "28"; }
                    MenuItem { text: "29"; }
                    MenuItem { text: "30"; }

                }

                onCurrentItemChanged: {
                    settings.reprFloatPrecision = Number(currentItem.text);
                }
            }

            TextSwitch {
                text: "Symbolic mode"
                checked: settings.symbolicMode

                onCheckedChanged: {
                    settings.symbolicMode = checked;
                }
            }

            /* Not functionnal
            TextSwitch {
                text: "Auto simplify expression"
                checked: settings.autoSimplify

                onCheckedChanged: {
                    settings.autoSimplify = checked;
                }
            }
            */
        }
    }
}
