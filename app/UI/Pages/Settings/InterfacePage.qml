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

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            text: qsTr("Regovar application settings")
            font.pixelSize: 20
            font.weight: Font.Black
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
        text: qsTr("Regovar application's settings. Note that your settings are saved on this local computer only.")
    }

    Rectangle
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 10 : 10


        color: "transparent"

        Text
        {
            anchors.centerIn: parent
            text: "Application settings (language, font size, theme, help boxes display ?)"
            font.pointSize: 24
        }
    }
}
