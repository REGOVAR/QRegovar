import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtWebView 1.0
//import QtWebKit 3.0
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

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
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Regovar user's guide")
        }
        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }
    }


    WebView
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 0

        url: "http://regovar.readthedocs.io/fr/latest/"
    }






}
