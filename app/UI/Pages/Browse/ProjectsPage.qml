import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//import org.regovar 1.0

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    Dialog
    {
        id: newProjectDialog
        modality:  Qt.WindowModal // Qt.NonModal
        title:  qsTr("Create new project")

        standardButtons: StandardButton.Save | StandardButton.Cancel

        Label
        {
            text: "Hello world!"
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

        TextField
        {
            anchors.fill: header
            anchors.margins: 10
            //text: Screen.PixelDensity
            placeholderText: qsTr("Search project by name, date, comment, ...")
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
        icon: "f"
        text: qsTr("Browse all available project in regovar thanks to the tree below. You can filter the project's tree thanks to the search field above.")
    }

    Column
    {
        id: actionsPanel
        anchors.top: helpInfoBox.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            id: openProject
            text: qsTr("Open")
            onClicked:  openSelectedProject()
        }

        Item
        {
            height:20
        }

        Button
        {
            id: newProject
            text: qsTr("New Project")
            onClicked: newProjectDialog.open()
        }

        Button
        {
            id: newFolder
            enabled: false
            text: qsTr("New Folder")
        }

        Button
        {
            id: deleteProject
            text: qsTr("Delete Project")
        }
    }


    TreeView
    {
        id: browser
        anchors.left: root.left
        anchors.top: helpInfoBox.bottom
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10
        model: regovar.projectsTreeView

        // Default delegate for all column
        itemDelegate: Item
        {
            Text
            {
                anchors.leftMargin: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                text: styleData.value.text
                elide: Text.ElideRight
            }
        }

        TableViewColumn
        {
            role: "name"
            title: "Name"

            // Deletegate for this column only
//            delegate: Item
//            {
//                Text
//                {
//                    anchors.fill: parent
//                    color: "red"
//                    text: styleData.row + ": " + styleData.column + " = " + styleData.value
//                }
//            }
        }

        TableViewColumn {
            role: "date"
            title: "Date"
        }

        TableViewColumn {
            role: "comment"
            title: "Comment"
        }
    }


    property var component
    property var name: value

    /// Retrive model of the selected project in the treeview and set the Regovar.currentProject with it.
    function openSelectedProject()
    {
//        var item = regovar.projectsTreeView.data(browser.currentIndex, 0);
//        if (item !== undefined)
//        {
//            var id = regovar.projectsTreeView.data(browser.currentIndex, 0).id
//            console.log("current index: " + browser.currentIndex + " => id: " + id)
//            regovar.loadProject(id);
//        }
        regovar.openAnalysis(5);


//        var req = new XMLHttpRequest();
//        var url = regovar.serverUrl + "/project/" + id;

//        // Do the job when the answer is ready
//        req.onreadystatechange = function()
//        {
//            if (req.readyState == 4)
//            {
//                // turn the text in a javascript object while setting the ListView's model to it
//                var data = JSON.parse(req.responseText);
//                regovar.currentProject = data["data"];
//                Regovar.mainMenu.selectedSubIndex = 0;
//            }
//        };
//        console.log(url)
//        req.open("GET", url, true);
//        req.send(null);
    }
}
