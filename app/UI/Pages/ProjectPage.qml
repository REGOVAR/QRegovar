import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//import org.regovar 1.0

import "../Regovar"
import "../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    Dialog
    {
        id: popup
        modality:  Qt.WindowModal // Qt.NonModal
        title:  "Hello"

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

    Column
    {
        id: actionsPanel
        anchors.top: header.bottom
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
            onClicked:popup.open()
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
        anchors.top: header.bottom
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


    BusyIndicator
    {
        anchors.fill: browser
    }




    /// Retrive model of the selected project in the treeview and set the Regovar.currentProject with it.
    function openSelectedProject()
    {
        var id = regovar.projectsTreeView.data(browser.currentIndex, 0).id
        console.log("current index: " + browser.currentIndex + " => id: " + id)

        regovar.loadProject(id);



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
