import QtQuick 2.9
import QtQuick.Layouts 1.3

import "../Framework"
import "../Regovar"

Rectangle
{
    id: root
    property QtObject model

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
            id: userIcon
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.icons.name
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter

            text: "b"
        }
        Text
        {
            id: userLabel
            anchors.top: header.top
            anchors.left: userIcon.right
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.font.family
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter

            text: "User not identified"
        }

        Text
        {
            id: serverIcon
            anchors.top: header.top
            anchors.right: serverLabel.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.icons.name
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter

            text: "F"
        }
        Text
        {
            id: serverLabel
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.font.family
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter

            text: "https://regovar.chu-nancy.fr"
        }
    }


    Image
    {
        id: logo
        source: "qrc:/regovar.png"
        sourceSize.height: 125
        anchors.top: header.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: header.horizontalCenter
    }



    Rectangle
    {
        id: panel
        color: "transparent"

        anchors.top: searchBar.bottom
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 100
        anchors.topMargin: 10
        anchors.bottomMargin: 10


        property real columnWidth
        onWidthChanged: columnWidth = (width - 290) / 4
        Component.onCompleted: columnWidth = (width - 290) / 4

        GridLayout
        {
            id: newButtonsRow
            anchors.centerIn: panel
            columns: 2
            rows: 3

            Text
            {
                text: qsTr("Login")
            }
            Text
            {
                text: qsTr("Password")
            }
        }

    }
}
