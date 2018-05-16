import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property Subject model
    onModelChanged:
    {
        if (model)
        {
            filesBrowser.model = model.files;
        }
    }


    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            text: model ? model.identifier + " : " + model.lastname.toUpperCase() + " " + model.firstname : ""
        }
    }

    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("This page list all files (except samples files) that have been attached to the subject.")
    }

    FilesBrowser
    {
        id: filesBrowser
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.margins: 10
    }


    SelectFilesDialog
    {
        id: fileDialog
        visible: false
        title: qsTr("Please choose a file")

        onAccepted:
        {
            var list = fileSystemModel.getFilesPath(localSelection)
            regovar.filesManager.enqueueUploadFile(list)
        }
    }


}
