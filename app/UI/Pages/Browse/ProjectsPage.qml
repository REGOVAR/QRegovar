import QtQuick 2.9
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
            iconLeft: "z"
            placeholder: qsTr("Search projects by names, dates, comments...")
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
        text: qsTr("Use the tree below to browse all available projects. You can filter the tree using the search field.")
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
            id: newProject
            text: qsTr("New Project")
             onClicked: regovar.openNewProjectWizard()
        }
        Button
        {
            id: openProject
            text: qsTr("Open")
            onClicked:  openSelectedProject()
        }
    }


    TreeView
    {
        id: browser
        anchors.left: root.left
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10
        model: regovar.projectsManager.projectsTreeView

        // Default delegate for all column
        itemDelegate: Item
        {
            Text
            {
                anchors.leftMargin: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.normal
                text: styleData.value.text
                elide: Text.ElideRight
            }
        }

        TableViewColumn
        {
            role: "name"
            title: "Name"
            width: 400
        }
        TableViewColumn
        {
            role: "date"
            title: "Date"
        }
        TableViewColumn
        {
            role: "comment"
            title: "Comment"
            width: 400
        }
    }

    /// Retrive model of the selected project in the treeview and set the Regovar.currentProject with it.
    function openSelectedProject()
    {

        var item = regovar.projectsManager.projectsTreeView.data(browser.currentIndex, 257); // 257 = Qt::UserRole+1
        if (item !== undefined)
        {
            if (item.isAnalysis)
                regovar.analysesManager.openAnalysis(item.type, item.id);
            else
                regovar.projectsManager.openProject(item.id);
        }
    }
}
