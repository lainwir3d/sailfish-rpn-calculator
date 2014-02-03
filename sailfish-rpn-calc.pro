# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = RPNCalc

CONFIG += sailfishapp

SOURCES += \
    src/RPNCalc.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    rpm/sailfish-rpn-calc.spec \
    qml/elements/CalcScreen.qml \
    qml/elements/KeyboardButton.qml \
    qml/elements/Memory.qml \
    qml/elements/StdKeyboard.qml \
    qml/engine.js \
    qml/elements/StackFlick.qml \
    TODO.txt \
    LICENSE.md \
    README.md \
    rpm/RPNCalc.yaml \
    rpm/RPNCalc.spec \
    RPNCalc.desktop \
    RPNCalc.png \
    qml/RPNCalc.qml \
    qml/pages/MainPage.qml \
    qml/cover/RPNCalc.png

