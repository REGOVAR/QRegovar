import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
//import org.regovar 1.0

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"

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
            placeholder: qsTr("Search subjects or samples by names, comments...")
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
        model: regovar.subjectsManager.subjectsList

        onDoubleClicked: openSelectedSubject()


        TableViewColumn
        {
            role: "identifier"
            title: "Identifier"
        }
        TableViewColumn
        {
            role: "lastname"
            title: "Lastname"
        }
        TableViewColumn
        {
            role: "firstname"
            title: "Firstname"
        }
        TableViewColumn
        {
            role: "sex"
            title: "Sex"
            delegate: RowLayout
            {
                anchors.fill: parent
                anchors.margins: 5
                Text
                {
                    Layout.fillHeight: true
                    width: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: Regovar.theme.icons.name
                    text: ["b", "<", "9"][modelData.sex]

                }
                Text
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    text: [qsTr("Unknow"), qsTr("Female"), qsTr("Male")][modelData.sex]
                    elide: Text.ElideRight
                }
            }
        }
        TableViewColumn
        {
            role: "dateOfBirth"
            title: "Date of birth"
            delegate: Text
            {
                anchors.fill: parent
                anchors.margins: 5
                verticalAlignment: Text.AlignVCenter
                text: Regovar.formatShortDate(modelData.dateOfBirth)
                elide: Text.ElideRight
            }
        }
        TableViewColumn
        {
            role: "comment"
            title: "Comment"
        }
    }

    /// Retrive model of the selected Subject in the tableview and ask model to open it
    function openSelectedSubject()
    {
        regovar.subjectsManager.openSubject(browser.model[browser.currentRow].id);
    }
}
