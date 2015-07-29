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
        }
    }
}
