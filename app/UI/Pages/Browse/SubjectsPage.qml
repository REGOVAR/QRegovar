import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
//import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model



    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt


        ConnectionStatus
        {
            id: connectionStatus
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }

        TextField
        {
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.right: connectionStatus.left
            anchors.margins: 10
            iconLeft: "z"
            displayClearButton: true
            placeholder: qsTr("Search subjects or samples by names, comments...")
            onTextEdited: regovar.subjectsManager.proxy.setFilterString(text)
            onTextChanged: regovar.subjectsManager.proxy.setFilterString(text)
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
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("The list below shows all subjects and samples available. You can filter the list using the search field.")
    }

    Column
    {
        id: actionsPanel
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            id: newSubject
            text: qsTr("New Subject")
            onClicked: regovar.openNewSubjectWizard()
        }
        Button
        {
            id: openSubject
            text: qsTr("Open")
            onClicked:  openSelectedSubject()
        }
    }


    TableView
    {
        id: browser
        anchors.left: root.left
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10
        model: regovar.subjectsManager.proxy

        onDoubleClicked: openSelectedSubject()

        TableViewColumn
        {
            role: "identifier"
            title: qsTr("Identifier")
        }
        TableViewColumn
        {
            role: "lastname"
            title: qsTr("Lastname")
        }
        TableViewColumn
        {
            role: "firstname"
            title: qsTr("Firstname")
        }
        TableViewColumn
        {
            role: "sex"
            title: qsTr("Sex")
        }
        TableViewColumn
        {
            role: "dateOfBirth"
            title: qsTr("Date of birth")
        }
        TableViewColumn
        {
            role: "comment"
            title: qsTr("Comment")
        }
    }

    /// Retrive model of the selected Subject in the tableview and ask model to open it
    function openSelectedSubject()
    {
        var idx = regovar.subjectsManager.proxy.getModelIndex(browser.currentRow);
        var id = regovar.subjectsManager.data(idx, 257);// 257 = Qt::UserRole+1
        regovar.subjectsManager.openSubject(id);
    }
}
