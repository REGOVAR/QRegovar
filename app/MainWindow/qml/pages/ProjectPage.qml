import QtQuick 2.7
import QtQuick.Controls 1.4
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
    Button
    {
        id: newFolder
        anchors.top: newProject.bottom
        anchors.right: root.right
        anchors.margins : 10

        text: qsTr("New Folder")
    }


    property Item listHeaderItem: null


    TreeView
    {
        id: content
        anchors.left: root.left
        anchors.top: header.bottom
        anchors.right: newProject.left
        anchors.bottom: root.bottom

        anchors.margins: 10
        model:1000

        TableViewColumn {
                title: "Name"
                role: "fileName"
                width: 300
            }
            TableViewColumn {
                title: "Permissions"
                role: "filePermissions"
                width: 100
            }
    }


//    ListView
//    {
//        id: content
//        anchors.left: root.left
//        anchors.top: header.bottom
//        anchors.right: newProject.left
//        anchors.bottom: root.bottom

//        anchors.margins: 10

//        model:1000
//        interactive: true
//    }







}
