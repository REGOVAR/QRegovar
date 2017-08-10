import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"

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

        TextField
        {
            anchors.fill: header
            anchors.margins: 10
            //text: Screen.PixelDensity
            placeholderText: qsTr("Search subject or sample  by name, comments, ...")
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
        text: qsTr("Browse all available subjects and sample in regovar thanks to the tree below. You can filter the subject's tree thanks to the search field above.")
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
            text: "Browse subjects/samples"
            font.pointSize: 24
        }
    }






}
