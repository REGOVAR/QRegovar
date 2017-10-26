import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
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
            //text: Screen.PixelDensity
            placeholderText: qsTr("Search subjects or samples by names, comments...")
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
            id: openSubject
            text: qsTr("Open")
            onClicked:  openSelectedSubject()
        }
        Button
        {
            id: newSubject
            text: qsTr("New Subject")
             onClicked: newSubjectDialog.open()
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
        model: regovar.subjects

        // Default delegate for all column
//        itemDelegate: Item
//        {
//            Text
//            {
//                anchors.leftMargin: 5
//                anchors.fill: parent
//                verticalAlignment: Text.AlignVCenter
//                font.pixelSize: Regovar.theme.font.size.normal
//                text: styleData.value
//                elide: Text.ElideRight
//            }
//        }

        TableViewColumn
        {
            role: "identifier"
            title: "Identifier"
            width: 400
        }
        TableViewColumn
        {
            role: "lastname"
            title: "Lastname"
            width: 400
        }
        TableViewColumn
        {
            role: "firstname"
            title: "Firstname"
            width: 400
        }
        TableViewColumn
        {
            role: "dateofbirth"
            title: "Date of birth"
        }
        TableViewColumn
        {
            role: "comment"
            title: "Comment"
            width: 400
        }
    }

    NewSubjectDialog { id: newSubjectDialog }

    property var component
    property var name

    /// Retrive model of the selected Subject in the treeview and set the Regovar.currentSubject with it.
    function openSelectedSubject()
    {
        var item = regovar.subjects[browser.currentRow];
        if (item !== undefined)
        {
            regovar.openSubject(item.id);
        }
    }
}
