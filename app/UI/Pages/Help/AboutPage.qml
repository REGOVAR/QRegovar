import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtWebView 1.1
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

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            text: qsTr("About Regovar")
            font.pixelSize: 20
            font.weight: Font.Black
        }
    }


    SwipeView
    {
        id: swipeview
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10


        model: ListModel
        {
            ListElement
            {
                title: "Informations"
                source: "../Pages/Help/AboutInformations.qml"
            }
            ListElement
            {
                title: "License"
                source: "../Pages/Help/AboutLicense.qml"
            }
            ListElement
            {
                title: "Credits"
                source: "../Pages/Help/AboutCredits.qml"
            }
        }
    }
}
