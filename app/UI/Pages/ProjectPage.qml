import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "../Framework"
import "../Style"
import "../GridView"
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

    Column
    {
        id: actionsPanel
        anchors.top: header.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10

        Button
        {
            id: newProject
            text: qsTr("New Project")
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




    Rectangle
    {
        id: browserRoot
        anchors.left: root.left
        anchors.top: header.bottom
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10

        color: Style.boxColor.back
        border.width: 1
        border.color: Style.boxColor.border

        Rectangle
        {
            id: browserHeader
            anchors.left: browserRoot.left
            anchors.right: browserRoot.right
            anchors.top: browserRoot.top
            height: 24

            border.width: 1
            border.color: Style.boxColor.border

            LinearGradient
            {
                anchors.fill: parent
                anchors.margins: 1
                start: Qt.point(0, 0)
                end: Qt.point(0, 24)
                gradient: Gradient
                {
                    GradientStop { position: 0.0; color: "#fcfcfd" }
                    GradientStop { position: 1.0; color: "#e7e7e7" }
                }
            }

            Row
            {
                anchors.fill: parent

                Text
                {
                    anchors.leftMargin: 15
                    text: "Name"
                    font.pixelSize: Style.font.size.control
                    font.family: Style.font.familly
                    font.bold: false
                    color: Style.frontColor.normal
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                Text
                {
                    anchors.leftMargin: 15
                    text: "Date"
                    font.pixelSize: Style.font.size.control
                    font.family: Style.font.familly
                    font.bold: false
                    color: Style.frontColor.normal
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                Text
                {
                    anchors.leftMargin: 15
                    text: "Comment"
                    font.pixelSize: Style.font.size.control
                    font.family: Style.font.familly
                    font.bold: false
                    color: Style.frontColor.normal
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }
        }

        ListView
        {
            id: browserList

            anchors.left: browserRoot.left
            anchors.top: browserHeader.bottom
            anchors.right: browserRoot.right
            anchors.bottom: browserRoot.bottom
            anchors.margins: 1

            interactive: true
            clip:true

            delegate: Rectangle
            {
                id: browserListItemRoot
                height: 22
                anchors.left: parent.left
                anchors.right: parent.right
                color: index % 2 == 0 ? Style.backgroundColor.main : Style.boxColor.back

                Text
                {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    text: "salut : " + index + " " + browserList.model[index]["name"]
                    font.pixelSize: Style.font.size.content
                    font.family: Style.font.familly
                    color: Style.frontColor.normal
                    anchors.margins: 4
                }
            }
            ScrollBar.vertical: ScrollBar { }
        }
    }









    Component.onCompleted:
    {
        //create a request and tell it where the json that I want is
        var req = new XMLHttpRequest();
        var location = "http://dev.regovar.org/project";

        //tell the request to go ahead and get the json
        req.open("GET", "http://dev.regovar.org/project", true);

        //wait until the readyState is 4, which means the json is ready
        req.onreadystatechange = function()
        {
            if (req.readyState == 4)
            {
                //turn the text in a javascript object while setting the ListView's model to it
                var data = JSON.parse(req.responseText);
                browserList.model = data["data"];
                console.log("model loader : " + data.length)
            }
        };


        req.send(null);
    }


}
