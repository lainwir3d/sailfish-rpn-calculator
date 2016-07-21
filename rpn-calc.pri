# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed

SOURCES += \
    ../common/src/settingsmanager.cpp

HEADERS += \
    ../common/src/settingsmanager.h

OTHER_FILES += \
    common/icons/86x86/apps/harbour-rpncalc.png \
    common/icons/108x108/apps/harbour-rpncalc.png \
    common/icons/128x128/apps/harbour-rpncalc.png \
    common/icons/256x256/apps/harbour-rpncalc.png \
    common/python/rpncalc_sympy_functions.py \
    common/python/rpncalc_constants.py \
    common/python/rpncalc_engine.py \
    TODO.txt \
    LICENSE.md \
    README.md
