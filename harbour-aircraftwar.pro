TARGET = aircraftwar

QT += network  quick
VERSION = 2.1.0

DEFINES += Q_OS_SAILFISH

HEADERS += \
    src/bullet.h \
    src/enemy.h \
    src/myplanes.h \
    src/mythread.h \
    src/prop.h \
    src/settings.h \
    src/windowplanes.h \
    src/utility.h \
    src/mynetworkaccessmanagerfactory.h \
    src/myimage.h \
    src/myhttprequest.h
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    src/bullet.cpp \
    src/enemy.cpp \
    src/myplanes.cpp \
    src/mythread.cpp \
    src/prop.cpp \
    src/settings.cpp \
    src/windowplanes.cpp \
    src/utility.cpp \
    src/mynetworkaccessmanagerfactory.cpp \
    src/myimage.cpp \
    src/myhttprequest.cpp

CONFIG += sailfishapp
RESOURCES += qml_sailfish.qrc planes.qrc font.qrc music.qrc
#OTHER_FILES += \
#        rpm/harbour-aircraftwar.changes.in \
#        rpm/harbour-aircraftwar.spec \
#        rpm/harbour-aircraftwar.yaml \
#        translations/*.ts \
#        harbour-aircraftwar.desktop \
#        i18n/comment.css \

#data.files += fzmw.ttf
#data.files += ./sound/*.wav
#data.path = $${TARGET}/data

INSTALLS += data

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

UBUNTU_TOUCH {
    message("building for Ubuntu Touch")

    target.path = /
    click_files.path = /
    click_files.files = $$PWD/qtc_packaging/ubuntu_touch/*
    INSTALLS+=click_files
}

include (src/cryptolib/cryptolib.pri)

