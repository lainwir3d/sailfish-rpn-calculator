import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    Rectangle {
        id: screen
        color: Theme.secondaryHighlightColor
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        height: column.height + 10



        Column {
                id: column


                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 4
                    leftMargin: 4
                }
                width: parent.width - 10
                Row{
                    width: parent.width
                    Label {
                        id: stack_2_id
                        horizontalAlignment: Text.AlignLeft
                        color: Theme.primaryColor
                        text: "3:"
                    }
                    Label {
                        width: parent.width - stack_2_id.width - 4
                        horizontalAlignment: Text.AlignRight
                        text: calculator.main_stack[2]
                    }
                }
                Row{
                    width: parent.width
                    Label {
                        id: stack_1_id
                        horizontalAlignment: Text.AlignLeft
                        color: Theme.primaryColor
                        text: "2:"
                    }
                    Label {
                        width: parent.width - stack_1_id.width - 4
                        horizontalAlignment: Text.AlignRight
                        text: calculator.main_stack[1]
                    }
                }
                Row{
                    width: parent.width
                    Label {
                        id: stack_0_id
                        horizontalAlignment: Text.AlignLeft
                        color: Theme.primaryColor
                        text: "1:"
                    }
                    Label {
                        width: parent.width - stack_0_id.width - 4
                        horizontalAlignment: Text.AlignRight
                        text: calculator.main_stack[0]
                    }
                }
        }
    }

    Image {
        anchors{
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 10
        }
        source: "RPNCalc.png"
    }
}


