TEMPLATE = app
TARGET = afce
VERSION = 0.9.7

  system(echo $$VERSION > version.txt)

INCLUDEPATH += .
QT += gui
QT += xml
QT += printsupport
QT += svg
QT += widgets
CONFIG += exceptions \
    rtti \
    stl
OBJECTS_DIR = build
UI_DIR = build
MOC_DIR = build
RCC_DIR = build


win32 {


    RC_FILE = afce.rc

    # Enable console in Debug mode on Windows, with useful logging messages
    Debug:CONFIG += console

    Release:DEFINES += NO_CONSOLE

    gcc48:QMAKE_CXXFLAGS += -Wno-unused-local-typedefs

}

unix:!mac {
  # This is to keep symbols for backtraces
  QMAKE_CXXFLAGS += -rdynamic
  QMAKE_LFLAGS += -rdynamic

  ## uncomment to force debug mode
  # QMAKE_CXXFLAGS += -g


    # Install prefix: first try to use qmake's PREFIX variable,
    # then $PREFIX from system environment, and if both fails,
    # use the hardcoded /usr.
    PREFIX = $${PREFIX}
    isEmpty( PREFIX ):PREFIX = $$(PREFIX)
    isEmpty( PREFIX ):PREFIX = /usr
    message(Install Prefix is: $$PREFIX)

    DEFINES += PROGRAM_DATA_DIR=\\\"$$PREFIX/share/afce/\\\"
    target.path = $$PREFIX/bin/
    locale.path = $$PREFIX/share/afce/ts/
    locale.files = ts/*.qm
    INSTALLS += target \
        locale
    pixmaps.path = $$PREFIX/share/pixmaps
    pixmaps.files = afce.png
    INSTALLS += pixmaps
    icons.path = $$PREFIX/share/icons
    icons.files = afc.ico
    INSTALLS += icons
    desktops.path = $$PREFIX/share/applications
    desktops.files = afce.desktop
    INSTALLS += desktops
    helps.path = $$PREFIX/share/afce/help/
    helps.files = help/*
    INSTALLS += helps
    generators.path = $$PREFIX/share/afce/generators
    generators.files = generators/*
    INSTALLS += generators
    mime.path = $$PREFIX/share/mime/packages
    mime.files = afce.xml
    INSTALLS += mime
}
DEFINES += PROGRAM_VERSION=\\\"$$VERSION\\\"

SOURCES += main.cpp \
    mainwindow.cpp \
    thelpwindow.cpp \
    zvflowchart.cpp \
    qflowchartstyle.cpp \
    sourcecodegenerator.cpp \
    qjson4/QJsonArray.cpp \
    qjson4/QJsonDocument.cpp \
    qjson4/QJsonObject.cpp \
    qjson4/QJsonParseError.cpp \
    qjson4/QJsonParser.cpp \
    qjson4/QJsonValue.cpp \
    qjson4/QJsonValueRef.cpp

HEADERS += mainwindow.h \
    thelpwindow.h \
    zvflowchart.h \
    qflowchartstyle.h \
    sourcecodegenerator.h \
    qjson4/QJsonArray.h \
    qjson4/QJsonDocument.h \
    qjson4/QJsonObject.h \
    qjson4/QJsonParseError.h \
    qjson4/QJsonParser.h \
    qjson4/QJsonRoot.h \
    qjson4/QJsonValue.h \
    qjson4/QJsonValueRef.h
RESOURCES += afce.qrc
CONFIG += release
TRANSLATIONS += ts/afce_en_US.ts \
    ts/afce_ru_RU.ts


# This makes qmake generate translations

win32:# Windows doesn't seem to have *-qt4 symlinks
isEmpty(QMAKE_LRELEASE):QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
isEmpty(QMAKE_LRELEASE):QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease-qt4

# The *.qm files might not exist when qmake is run for the first time,
# causing the standard install rule to be ignored, and no translations
# will be installed. With this, we create the qm files during qmake run.
!win32 {
  system($${QMAKE_LRELEASE} -silent $${_PRO_FILE_} 2> /dev/null)
}

updateqm.input = TRANSLATIONS
updateqm.output = ts/${QMAKE_FILE_BASE}.qm
updateqm.commands = $$QMAKE_LRELEASE \
    ${QMAKE_FILE_IN} \
    -qm \
    ${QMAKE_FILE_OUT}
updateqm.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += updateqm
TS_OUT = $$TRANSLATIONS
TS_OUT ~= s/.ts/.qm/g
PRE_TARGETDEPS += $$TS_OUT

