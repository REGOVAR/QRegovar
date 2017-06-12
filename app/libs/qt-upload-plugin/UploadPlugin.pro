QT       += network
TEMPLATE = lib
TARGET = UploadPlugin
CONFIG += plugin
CONFIG -= app_bundle
version = 1.0.0

DESTDIR = ../Output
SOURCES += uploadplugin.cpp
HEADERS += uploadplugin.h \
    uploadinterface.h

OTHER_FILES +=
