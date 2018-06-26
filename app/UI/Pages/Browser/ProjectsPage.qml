import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
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
            placeholder: qsTr("Search analyses by names, dates, comments...")
            onTextChanged: regovar.projectsManager.proxy.setFilterString(text)
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

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("Use the tree below to browse all available analyses. You can filter the tree using the search field.")
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
            text: qsTr("New folder")
             onClicked: regovar.openNewProjectWizard()
        }
        Button
        {
            id: openProject
            text: qsTr("Open")
            onClicked:  openSelectedProject()
        }
        Button
        {
            id: deleteProject
            text: qsTr("Delete")
            onClicked:  deleteSelectedProject()
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
        model: regovar.projectsManager.proxy //regovar.projectsManager.projectsTree

        onDoubleClicked:
        {
            var idx = regovar.projectsManager.proxy.mapToSource(browser.currentIndex);
            var id = regovar.projectsManager.projectsTree.data(idx, 257); // 257 = Qt::UserRole+1
            var type = regovar.projectsManager.projectsTree.data(idx, 258);

            if (id && type)
            {
                if (type !== "folder")
                {
                    regovar.analysesManager.openAnalysis(type, id);
                }
                else
                {
                    // if already expanded, open details
                    regovar.projectsManager.openProject(id);
                    expand(index);
                }
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
            role: "analysistype"
            title: "Type"
        }

        TableViewColumn
        {
            role: "status"
            title: "Status"
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



    QuestionDialog
    {
        id: deleteProjectConfirmDialog
        width: 400
        property var model
        onModelChanged:
        {
            if (model)
            {
                var txt = qsTr("Do you confirm the deletion of the folder '{}' ?\nAll it's analyses will be also deleted.");
                txt = txt.replace('{}', model.name);
                text = txt;
            }
        }
        title: qsTr("Delete folder")
        onYes:
        {
            regovar.projectsManager.deleteProject(model.id);
        }
    }
    QuestionDialog
    {
        id: deleteAnalysisConfirmDialog
        width: 400
        property var model
        onModelChanged:
        {
            if (model)
            {
                var txt = qsTr("Do you confirm the deletion of the analysis '{}' ?");
                txt = txt.replace('{}', model.name);
                text = txt;
            }
        }
        title: qsTr("Delete analysis")
        onYes:
        {
            regovar.analysesManager.deleteFilteringAnalysis(model.id);
        }
    }

    /// Retrive model of the selected project in the treeview and set the Regovar.currentProject with it.
    function openSelectedProject()
    {
        var idx = regovar.projectsManager.proxy.mapToSource(browser.currentIndex);
        var id = regovar.projectsManager.projectsTree.data(idx, 257); // 257 = Qt::UserRole+1
        var type = regovar.projectsManager.projectsTree.data(idx, 258);

        if (id && type)
        {
            if (type !== "folder")
            {
                regovar.analysesManager.openAnalysis(type, id);
            }
            else
            {
                regovar.projectsManager.openProject(id);
            }
        }
    }


    /// Retrive model of the selected project in the treeview and delete it.
    function deleteSelectedProject()
    {
        var idx = regovar.projectsManager.proxy.mapToSource(browser.currentIndex);
        var id = regovar.projectsManager.projectsTree.data(idx, 257); // 257 = Qt::UserRole+1
        var type = regovar.projectsManager.projectsTree.data(idx, 258);

        if (id && type)
        {
            if (type !== "folder")
            {
                deleteAnalysisConfirmDialog.model = regovar.analysesManager.getOrCreateFilteringAnalysis(id);
                deleteAnalysisConfirmDialog.visible = true;
            }
            else
            {
                deleteProjectConfirmDialog.model = regovar.projectsManager.getOrCreateProject(id);
                deleteProjectConfirmDialog.visible = true;
            }
        }
    }
}
