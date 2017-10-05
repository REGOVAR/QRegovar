import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"

Item
{
    id: root

    Rectangle
    {
        anchors.centerIn: parent

        width: longText.width + 110
        height: info.height + 20
        border.width: 1
        border.color: Regovar.theme.boxColor.border
        color: Regovar.theme.boxColor.back

        Image
        {
            id: logo
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.margins: 10
            width: 80
            height: 80

            source: "qrc:/logo.png"
        }

        Column
        {
            id: info
            anchors.top: parent.top
            anchors.left: logo.right
            anchors.right: parent.right
            anchors.margins: 10
            spacing: 10

            Text
            {
                text: qsTr("Regovar")
                font.pixelSize: Regovar.theme.font.size.title
                font.bold: true
                color: Regovar.theme.frontColor.normal
            }
            Text
            {
                text: qsTr("Server version") + " : " + regovar.config.serverVersion
                font.pixelSize: Regovar.theme.font.size.control
                color: Regovar.theme.frontColor.normal
            }
            Text
            {
                text: qsTr("Client version") + " : " + regovar.config.clientVersion
                font.pixelSize: Regovar.theme.font.size.control
                color: Regovar.theme.frontColor.normal
            }
            Rectangle
            {
                width: 50
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }

            Text
            {
                text: qsTr("Website") + " : http://regovar.org"
                font.pixelSize: Regovar.theme.font.size.control
                color: Regovar.theme.frontColor.normal
                MouseArea
                {
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    onClicked: Qt.openUrlExternally("http://regovar.org")
                }
            }
            Text
            {
                id: longText
                text: qsTr("Github") + " : https://github.com/REGOVAR/Regovar"
                font.pixelSize: Regovar.theme.font.size.control
                color: Regovar.theme.frontColor.normal
                MouseArea
                {
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    onClicked: Qt.openUrlExternally("https://github.com/REGOVAR/Regovar")
                }
            }
            Row
            {
                Text
                {
                    text: qsTr("Contact email") + " : "
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                }
                TextEdit
                {
                    text: "dev@regovar.org"
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                    readOnly: true
                    selectByMouse: true
                    selectByKeyboard: true
                }
            }


            Rectangle
            {
                width: 50
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }

            Text
            {
                text: qsTr("Next planned release")
                font.pixelSize: Regovar.theme.font.size.control
                font.bold: true
                color: Regovar.theme.primaryColor.back.normal
            }
            Grid
            {
                columns: 2
                rows: 4
                rowSpacing: 5
                columnSpacing: 10

                Text
                {
                    text: qsTr("Name:")
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: regovar.config.release["title"]
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: qsTr("Due on:")
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: regovar.config.release["due_on"]
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: qsTr("Progress:")
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                }
                Rectangle
                {
                    width: 150
                    height: Regovar.theme.font.boxSize.control
                    color: Regovar.theme.backgroundColor.main
                    border.width: 1
                    border.color: Regovar.theme.boxColor.border
                    Rectangle
                    {
                        x: 1
                        y: 1
                        width: regovar.config.release["progress"] * 148
                        height: Regovar.theme.font.boxSize.control - 2
                        color: Regovar.theme.frontColor.normal
                    }
                }
                Text
                {
                    text: qsTr("Details:")
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: qsTr("See on Github")
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.frontColor.normal
                    MouseArea
                    {
                        anchors.fill: parent
                        cursorShape: "PointingHandCursor"
                        onClicked: Qt.openUrlExternally(regovar.config.release["html_url"])
                    }
                }
            }

        }
    }
}
