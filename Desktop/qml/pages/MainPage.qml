import QtQuick 2.2
import io.thp.pyotherside 1.3
import QtQuick.Controls 1.4
import Qt.labs.controls 1.0
import "../elements"
//import QtFeedback 5.0

Item {
    id: page

    // should be set from python engine in the parent
    property string currentOperand: ''
    property bool currentOperandValid: true
    property var currentStack: []
    property bool engineLoaded: false

    // View properties. Python engine might access this
    property alias screen: calcScreen
    property alias notification: popup

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

    function formulaPush(visual, engine, type) {
        python.processInput(engine, type);
    }

    function stackDropFirst(){
        python.dropFirstStackOperand();
    }

    function stackDropAll(){
        python.dropAllStackOperand();
    }

    function stackDropUIIndex(idx){
        var engineIdx = idx - 1;
        python.dropStackOperand(engineIdx);
    }

    function stackPickUIIndex(idx){
        var engineIdx = idx - 1;
        python.pickStackOperand(engineIdx);
    }

    function formulaPop() {
        python.delLastOperandCharacter(); // might need an UNDO type of thing if last typed key != 1 character
    }

    function formulaReset() {
        python.clearCurrentOperand();
    }

    function resetKeyboard() {
        kbd.action = 0;
    }

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

    function copyToClipboard(value){
        Clipboard.text = value;
    }

    Item {
        id: heightMeasurement
        anchors.bottom: currentOperandEditor.top
        anchors.top: parent.top

        visible: false
    }

    Popup {
        id: popup
        z: 10

        timeout: 3000

        padding: paddingSmall

        defaultColor: "black"
        rectOpacity: 0.4
        labelMargin: marginSmall

        pixelSize: 12
    }

    CalcScreen {
        id: calcScreen

        anchors.bottom: currentOperandEditor.top
        anchors.left: parent.left
        anchors.right: parent.right

        // Don't why I need 10 here... without it GlassItem is displayed too low
        height: heightMeasurement.height + 10 > contentHeight ? contentHeight : heightMeasurement.height

        clip: true

        model: memory

        fontColor: primaryColor
        fontSize: fontSizeExtraLarge
        fontFamily: "helvetica"
        dropIconPath: Qt.resolvedUrl("qrc:///images/backspace.png")

        glassItemColor: "lightblue"
    }

    OperandEditor {
        id: currentOperandEditor

        focus: true

        Component.onCompleted: {
            forceActiveFocus();
        }

        anchors.bottom: infosRow.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.leftMargin: 10

        operand: page.currentOperand
        operandInvalid: page.currentOperandValid ? false : true  // <= lol

        backIcon: Qt.resolvedUrl("qrc:///images/backspace.png")

        fontSize: fontSizeExtraLarge
        fontFamily: fontFamily
        horizontalScrollPadding: paddingSmall
        fontColor: primaryColor
        invalidFontColor: "red"

        elementScrollDecorator: ScrollIndicator {
            orientation: Qt.Horizontal
          } /*HorizontalScrollDecorator{
            height: Math.round(Theme.paddingSmall/4)

            opacity: 0.5    // always visible
        }*/

        backButton.onClicked: {
            formulaPop();
        }

        backButton.onPressAndHold: {
            formulaReset();
        }

        Keys.onEnterPressed: python.processInput("enter", "stack")
        Keys.onReturnPressed: python.processInput("enter", "stack")

        Keys.onDigit0Pressed: python.processInput("0", "number")
        Keys.onDigit1Pressed: python.processInput("1", "number")
        Keys.onDigit2Pressed: python.processInput("2", "number")
        Keys.onDigit3Pressed: python.processInput("3", "number")
        Keys.onDigit4Pressed: python.processInput("4", "number")
        Keys.onDigit5Pressed: python.processInput("5", "number")
        Keys.onDigit6Pressed: python.processInput("6", "number")
        Keys.onDigit7Pressed: python.processInput("7", "number")
        Keys.onDigit8Pressed: python.processInput("8", "number")
        Keys.onDigit9Pressed: python.processInput("9", "number")

        Keys.onPressed: {
            if(event.key == Qt.Key_E){
                python.processInput("e", "exp")
            }else if(event.key == Qt.Key_Backspace){
                formulaPop();
            }else if(event.key == Qt.Key_BraceLeft){

            }else if(event.key == Qt.Key_BraceRight){

            }else if(event.key == Qt.Key_Comma){
                python.processInput(".", "real")
            }else if(event.key == Qt.Key_Copy){

            }else if(event.key == Qt.Key_Delete){
                python.dropFirstStackOperand();
            }else if(event.key == Qt.Key_Minus){
                python.processInput("-", "operation")
            }else if(event.key == Qt.Key_Percent){

            }else if(event.key == Qt.Key_Period){
                python.processInput(".", "real")
            }else if(event.key == Qt.Key_Plus){
                python.processInput("+", "operation")
            }else if(event.key == Qt.Key_division){
                python.processInput("div", "operation")
            }else if(event.key == Qt.Key_Slash){
                python.processInput("div", "operation")
            }else if(event.key == Qt.Key_multiply){
                python.processInput("mul", "operation")
            }else if(event.key == Qt.Key_Asterisk){
                python.processInput("mul", "operation")
            }


        }


    }

    Row {
        id: infosRow

        anchors.bottom: kbd.top
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottomMargin: 10

        spacing: 15

        Label {
            text: !page.engineLoaded ? "IEEE754" : settings.rationalMode ? "Rational" : "IEEE754"
            //font.family: Theme.fontFamily
            font.pixelSize: fontSizeExtraSmall
            //font.bold: !engineLoaded

            color: !page.engineLoaded ? "red" : secondaryColor
        }

        Text {
            id: mode

            text: !page.engineLoaded ? "Degraded" : settings.symbolicMode ? "Symbolic" : "Numeric"
            //font.family: Theme.fontFamily
            font.pixelSize: fontSizeExtraSmall
            //font.bold: !engineLoaded

            color: !page.engineLoaded ? "red" : secondaryColor
        }


        Text {
            id: unit

            text: settings.angleUnit
            //font.family: Theme.fontFamily
            font.pixelSize: fontSizeExtraSmall

            color: secondaryColor
        }

    }

    StdKeyboard {
        id: kbd

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: paddingMedium
        anchors.bottomMargin: paddingLarge

        columnSpacing: paddingSmall
        rowSpacing: paddingLarge

        buttonWidth: (width - (rowSpacing * 4)) / 5
        buttonHeigth: buttonWidth * 16/17

        keyboardButtonBorderColor: secondaryColor
        keyboardButtonFontSize: fontSizeMedium
        keyboardButtonSecondaryFontSize: fontSizeExtraSmall

        keyboardButtonFontColor: primaryColor
        keyboardButtonLeftFontColor: "orange"
        keyboardButtonRightFontColor: "lightblue"

    }
}


