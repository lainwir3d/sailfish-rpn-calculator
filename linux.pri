python.path = /usr/share/$${TARGET}
python.files = ../common/python

commonqml.path = /usr/share/$${TARGET}/qml/
commonqml.files = ../common/qml/*

#libs.path = /usr/share/$${TARGET}
#libs.files = libs/i686/lib
#libs.files = libs/armv7l/lib

appicons.path = /usr/share/icons/hicolor
appicons.files = ../common/icons/*

#INSTALLS += python libs
INSTALLS += appicons python commonqml

