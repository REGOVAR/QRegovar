import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

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
            placeholderText: qsTr("Search file by name or comments ...")
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
        text: qsTr("Browse all available files in regovar thanks to the tree below. You can filter the file's tree thanks to the search field above.")
    }

    Rectangle
    {
        anchors.top : helpInfoBox.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        color: "transparent"

        Text
        {
            anchors.centerIn: parent
            text: "Browse regovar's files"
            font.pointSize: 24
        }
    }






}
