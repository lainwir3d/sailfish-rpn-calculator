# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = sailfish-rpn-calculator

CONFIG += sailfishapp

SOURCES += \
    src/sailfish-rpn-calculator.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    rpm/sailfish-rpn-calc.spec \
    qml/pages/RPNCalc.qml \
    qml/elements/CalcScreen.qml \
    qml/elements/KeyboardButton.qml \
    qml/elements/Memory.qml \
    qml/elements/StdKeyboard.qml \
    qml/engine.js \
    sailfish-rpn-calculator.png \
    rpm/sailfish-rpn-calculator.yaml \
    rpm/sailfish-rpn-calculator.spec \
    sailfish-rpn-calculator.desktop \
    qml/sailfish-rpn-calculator.qml \
    qml/elements/StackFlick.qml

