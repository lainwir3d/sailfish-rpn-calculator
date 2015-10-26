# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-rpncalc

CONFIG += sailfishapp

SOURCES += \
    src/harbour-rpncalc.cpp \
    settingsmanager.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    rpm/sailfish-rpn-calc.spec \
    qml/elements/CalcScreen.qml \
    qml/elements/KeyboardButton.qml \
    qml/elements/Memory.qml \
    qml/elements/StdKeyboard.qml \
    qml/elements/StackFlick.qml \
    TODO.txt \
    LICENSE.md \
    README.md \
    rpm/RPNCalc.yaml \
    qml/pages/MainPage.qml \
    harbour-rpncalc.desktop \
    qml/cover/harbour-rpncalc.png \
    qml/harbour-rpncalc.qml \
    python/rpncalc_engine.py \
    rpm/harbour-rpncalc.spec \
    qml/elements/Popup.qml \
    python/rpncalc_constants.py \
    qml/pages/Settings.qml \
    qml/elements/OperandEditor.qml \
    qml/pages/SymbolPage.qml \
    python/rpncalc_sympy_functions.py \
    qml/pages/WideLandscape.qml \
	icons/86x86/apps/harbour-rpncalc.png \
	icons/108x108/apps/harbour-rpncalc.png \
	icons/128x128/apps/harbour-rpncalc.png \
	icons/256x256/apps/harbour-rpncalc.png

python.path = /usr/share/$${TARGET}
python.files = python

#libs.path = /usr/share/$${TARGET}
#libs.files = libs/i686/lib
#libs.files = libs/armv7l/lib

appicons.path = /usr/share/icons/hicolor
appicons.files = icons/*

#INSTALLS += python libs
INSTALLS += appicons python

HEADERS += \
    settingsmanager.h
