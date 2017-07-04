import QtQuick 2.7
import RegovarControls 1.0
import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

Rectangle
{
    id: root

    color: ColorTheme.backgroundColor



    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50


        color: ColorTheme.background2Color

        TextField
        {
            anchors.fill: header
            anchors.margins: 10
            //text: Screen.PixelDensity
            placeholderText: qsTr("Search project by name, date, comment, ...")
        }
    }

    Button
    {
        id: newProject
        anchors.top: header.bottom
        anchors.right: root.right
        anchors.margins : 10

        text: qsTr("New Project")
    }
//    Button
//    {
//        id: newFolder
//        anchors.top: newProject.bottom
//        anchors.right: root.right
//        anchors.margins : 10

//        text: qsTr("New Folder")
//    }


    property Item listHeaderItem: null

    RegovarModel {
        id: myModel
    }

    // Test with QtQuick.COntrols 1 TreeView
//    TreeView
//    {
//        id: content
//        anchors.left: root.left
//        anchors.top: header.bottom
//        anchors.right: newProject.left
//        anchors.bottom: root.bottom

//        anchors.margins: 10
//        model:1000

//        TableViewColumn {
//                title: "Name"
//                role: "fileName"
//                width: 300
//            }
//            TableViewColumn {
//                title: "Permissions"
//                role: "filePermissions"
//                width: 100
//            }
//    }


//    TreeView
//    {
//        id: content
//        anchors.left: root.left
//        anchors.top: header.bottom
//        anchors.right: newProject.left
//        anchors.bottom: root.bottom

//        anchors.margins: 10
//        model:myModel

//        TableViewColumn {
//                title: "Name"
//                role: "fileName"
//                width: 300
//            }
//            TableViewColumn {
//                title: "Permissions"
//                role: "filePermissions"
//                width: 100
//            }
//    }


    ListView
    {
        id: content
        anchors.left: root.left
        anchors.top: header.bottom
        anchors.right: newProject.left
        anchors.bottom: root.bottom

        anchors.margins: 10

        model:myModel
        interactive: true

        delegate: Rectangle{
            width: content.width
            height: 30
            Text {
                anchors.centerIn: parent
                text: title
            }
        }
    }


//    Component.onCompleted:
//    {
//        //create a request and tell it where the json that I want is
//        var req = new XMLHttpRequest();
//        var location = "http://dev.regovar.org/project";

//        //tell the request to go ahead and get the json
//        req.open("GET", "http://dev.regovar.org/project", true);

//        //wait until the readyState is 4, which means the json is ready
//        req.onreadystatechange = function()
//        {
//            if (req.readyState == 4)
//            {
//                //turn the text in a javascript object while setting the ListView's model to it
//                var data = JSON.parse(req.responseText);
//                projectList.model = data["data"];
//                console.log(data.length)
//            }
//        };


//        req.send(null);
//    }

//    ListView
//    {
//        id: projectList
//        anchors.left: root.left
//        anchors.top: header.bottom
//        anchors.right: newProject.left
//        anchors.bottom: root.bottom

//        anchors.margins: 10
//        vm: VisualDataModel
//        {
//            model: model
//            delegate: Text
//            {
//                width: 200
//                height: 30
//                text: projectList.model[parent.index].name
//            }
//        }

//    }
}
