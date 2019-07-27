import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "../elements"
//import QtFeedback 5.0

Page {
    id: page

    // should be set from python engine in the parent
    property string currentOperand: ''
    property bool currentOperandValid: true
    property var currentStack: []
    property bool engineLoaded: false

    // View properties. Python engine might access this
    property alias screen: calcScreen
    property alias notification: popup

    property string fontFamily: Theme.fontFamily
    property int fontSizeTiny: Theme.fontSizeTiny
    property int fontSizeExtraSmall: Theme.fontSizeExtraSmall
    property int fontSizeSmall: Theme.fontSizeSmall
    property int fontSizeMedium: Theme.fontSizeMedium
    property int fontSizeLarge: Theme.fontSizeLarge
    property int fontSizeExtraLarge: Theme.fontSizeExtraLarge
    property int fontSizeHuge: Theme.fontSizeHuge

    property int paddingSmall: Theme.paddingSmall
    property int paddingMedium: Theme.paddingMedium
    property int paddingLarge: Theme.paddingLarge

    property color primaryColor: Theme.primaryColor
    property color highlightColor: Theme.highlightColor
    property color secondaryColor: Theme.secondaryColor
    property color secondaryHighlightColor: Theme.secondaryHighlightColor

    /*
    HapticsEffect {
        id: vibration
        intensity: 0.8
        duration: 50
    }

    HapticsEffect {
        id: longVibration
        intensity: 0.8
        duration: 200
    }
    */

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

        padding: page.paddingSmall

        defaultColor: page.secondaryHighlightColor
        labelMargin: page.paddingSmall
    }

    CalcScreen {
        id: calcScreen

        anchors.bottom: currentOperandEditor.top
        anchors.left: parent.left
        anchors.right: parent.right

        fontColor: primaryColor
        glassItemColor: page.highlightColor
        fontSize: page.fontSizeExtraLarge
        fontFamily: page.fontFamily

        dropIconPath: "image://Theme/icon-l-backspace"
        dropIconColor: page.primaryColor

        height: heightMeasurement.height > contentHeight ? contentHeight : heightMeasurement.height

        clip: true

        model: memory

        scrollIndicatorHeight: page.paddingSmall

        horizontalScrollPadding: page.paddingSmall
        horizontalScrollDecorator: HorizontalScrollDecorator{
            height: Math.round(page.paddingSmall/4)

            opacity: 0.5    // always visible
        }

        verticalScrollPadding: page.paddingSmall
        verticalScrollDecorator: VerticalScrollDecorator{
            width: Math.round(page.paddingSmall/2)

            opacity: 0.5    // always visible
        }
    }

    OperandEditor {
        id: currentOperandEditor

        anchors.bottom: infosRow.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.leftMargin: 10

        operand: page.currentOperand
        operandInvalid: page.currentOperandValid ? false : true  // <= lol

        backIcon: "image://Theme/icon-l-backspace"
        backIconColor: page.primaryColor

        fontSize: page.fontSizeExtraLarge
        fontFamily: page.fontFamily
        horizontalScrollPadding: page.paddingSmall
        fontColor: page.primaryColor
        invalidFontColor: "red"

        horizontalScrollDecorator: HorizontalScrollDecorator{
            height: Math.round(page.paddingSmall/4)

            opacity: 0.5    // always visible
        }

        backButton.onClicked: {
            formulaPop();
            /*
            if(settings.vibration()){
                vibration.start();
            }
            */
        }

        backButton.onPressAndHold: {
            formulaReset();
            /*
            if(settings.vibration()){
                vibration.start();
            }
            */
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
            font.family: page.fontFamily
            font.pixelSize: page.fontSizeExtraSmall
            //font.bold: !engineLoaded

            color: !page.engineLoaded ? "red" : page.secondaryColor
        }

        Label {
            id: mode

            text: !page.engineLoaded ? "Degraded" : settings.symbolicMode ? "Symbolic" : "Numeric"
            font.family: page.fontFamily
            font.pixelSize: page.fontSizeExtraSmall
            //font.bold: !engineLoaded

            color: !page.engineLoaded ? "red" : page.secondaryColor
        }


        Label {
            id: unit

            text: settings.angleUnit
            font.family: page.fontFamily
            font.pixelSize: page.fontSizeExtraSmall

            color: page.secondaryColor
        }

    }

    StdKeyboard {
        id: kbd

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: page.paddingMedium
        anchors.bottomMargin: page.paddingLarge

        columnSpacing: page.paddingSmall
        rowSpacing: page.paddingLarge

        buttonWidth: (width - (rowSpacing * 4)) / 5
        buttonHeigth: buttonWidth * 16/17

        keyboardButtonFontColor: page.primaryColor
        keyboardButtonBorderColor: page.secondaryColor
        keyboardButtonLeftFontColor: "orange"
        keyboardButtonRightFontColor: page.secondaryHighlightColor

        keyboardButtonFontSize: page.fontSizeMedium
        keyboardButtonSecondaryFontSize: page.fontSizeTiny
    }
}


