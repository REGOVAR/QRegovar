import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: closeDialog
    title: qsTr("Error")

    width: 600
    height: 400


    modality: Qt.WindowModal

    property string errorCode
    property string errorMessage
    property string errorTechnicalData


    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main

        Rectangle
        {
            id: header
            color: Regovar.theme.primaryColor.back.dark
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 50

            Row
            {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                Text
                {
                    text: "~"
                    color: Regovar.theme.primaryColor.front.dark
                    font.family: Regovar.theme.icons.name
                    font.weight: Font.Black
                    font.pixelSize: Regovar.theme.font.size.header
                    width: 50
                    height: 50
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment:  Text.AlignHCenter
                }

                Text
                {
                    text: qsTr("Error occured")
                    color: Regovar.theme.primaryColor.front.dark
                    font.family: "Sans"
                    font.weight: Font.Black
                    font.pixelSize: Regovar.theme.font.size.header
                    height: 50
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        GridLayout
        {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 10
            anchors.bottomMargin: 50

            columns: 2
            rows:2
            columnSpacing: 30
            rowSpacing: 10

            Text
            {
                text: qsTr("Code")
                font.weight: Font.Black
            }
            Text
            {
                id: codeHelpLink
                Layout.fillWidth: true
                text: (errorPopup.errorCode) ? errorPopup.errorCode : "No code provided"
                MouseArea
                {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: codeHelpLink.color = Regovar.theme.secondaryColor.back.normal
                    onExited: codeHelpLink.color = Regovar.theme.frontColor.normal
                    onClicked: Qt.openUrlExternally(regovar.serverUrl.toString() + "/error/" + (codeHelpLink.errorCode ? codeHelpLink.errorCode : "index") + ".html");
                }
            }
            Text
            {
                Layout.alignment: Qt.AlignTop
                text: qsTr("Message")
                font.weight: Font.Black
            }
            Rectangle
            {
                id: messagePanel
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumHeight: 4 * Regovar.theme.font.size.normal
                color: "transparent"

                Column
                {
                    id: summaryPanel
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    TextArea
                    {
                        width: messagePanel.width
                        text: errorPopup.errorMessage
                        font.family: fixedFont
                        readOnly: true
                        frameVisible: false
                        backgroundVisible: false
                    }
                    Text
                    {
                        text: qsTr("Get technical details ...")
                        color: Regovar.theme.primaryColor.back.normal
                        MouseArea
                        {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = Regovar.theme.secondaryColor.back.normal
                            onExited: parent.color = Regovar.theme.primaryColor.back.normal
                            onClicked:
                            {
                                summaryPanel.visible = false;
                                detailsPanel.visible = true;
                            }
                        }
                    }
                }

                TextArea
                {
                    id: detailsPanel
                    anchors.fill: parent
                    visible: false
                    text: errorPopup.errorMessage + "\n-----\n" + errorPopup.errorTechnicalData
                    font.family: fixedFont
                    readOnly: true
                    frameVisible: false
                    backgroundVisible: false
                }
            }
        }

        Button
        {
            text: qsTr("Close")
            anchors.bottom: root.bottom
            anchors.horizontalCenter: root.horizontalCenter
            anchors.bottomMargin: 10
            onClicked: closeDialog.close()
        }

    }
}
