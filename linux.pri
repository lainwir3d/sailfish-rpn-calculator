python.path = /usr/share/$${TARGET}
python.files = ../common/python

#libs.path = /usr/share/$${TARGET}
#libs.files = libs/i686/lib
#libs.files = libs/armv7l/lib

appicons.path = /usr/share/icons/hicolor
appicons.files = ../common/icons/*

#INSTALLS += python libs
INSTALLS += appicons python

