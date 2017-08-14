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
            text: regovar.searchRequest
            placeholderText: qsTr("Search project, subject, sample, analysies, panel, ...")
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
        text: qsTr("Use the field above to search everything in Regovar. Then double click on the result below to open it and see details.")
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
            text: "Search results"
            font.pointSize: 24
        }
    }

    Row
    {
        anchors.top : header.bottom
        anchors.horizontalCenter: header.horizontalCenter
        anchors.topMargin: 100

        spacing: 30

        Button
        {
            text: "Open Singleton"
            onClicked: regovar.openAnalysis(19);
        }
        Button
        {
            text: "Open Trio"
            onClicked: regovar.openAnalysis(1);
        }
    }





}
