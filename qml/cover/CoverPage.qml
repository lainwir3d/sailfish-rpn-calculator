import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    function formatNumber(n, maxsize){
        var str = String(n);
        var l = str.length;
        var round_n;

        if(l > maxsize){

            if(str.split('e').length > 1){
                round_n = Number(n).toPrecision(maxsize-5);
            }else{
                round_n = Number(n).toPrecision(maxsize);
                if(String(round_n).length > maxsize){
                    round_n = Number(n).toExponential(maxsize-4);
                }
            }

            str = String(round_n);
        }

        return str;
    }

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
                        text: calculator.currentStack.length > 2 ? calculator.currentStack[2]['expr'] : ""
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
                        text: calculator.currentStack.length > 1 ? calculator.currentStack[1]['expr'] : ""
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
                        text: calculator.currentStack.length > 0 ? calculator.currentStack[0]['expr'] : ""
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
        source: "harbour-rpncalc.png"
    }
}




