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
    src/harbour-rpncalc.cpp

include(../rpn-calc.pri)

OTHER_FILES += \
    rpm/sailfish-rpn-calc.spec \
    rpm/harbour-rpncalc.spec \
    harbour-rpncalc.desktop \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/cover/harbour-rpncalc.png \
    qml/harbour-rpncalc.qml \
    qml/pages/Settings.qml \
    qml/pages/SymbolPage.qml \
    qml/pages/WideLandscape.qml

include("../linux.pri")
