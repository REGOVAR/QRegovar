import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true // checkReadyreadyForNext();
    property real labelColWidth: 100

    function checkReadyreadyForNext()
    {
        return nameField.text.trim() != "" && projectField.currentIndex > 0;
    }

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Select the project where you want to do the analysis. Project is like a folder, it' allow you to organize your analyzes and find them more easily afterwards.\nYou can create a new project if you need.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }




    ScrollView
    {
        id: scrollArea
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.topMargin: 30

        Column
        {
            spacing: 5

            RowLayout
            {
                width: scrollArea.viewport.width
                spacing: 10

                Text
                {
                    height: Regovar.theme.font.size.header
                    Layout.minimumWidth: root.labelColWidth
                    text: qsTr("Project")
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    onTextChanged: root.readyForNext = checkReadyreadyForNext();
                }
                ComboBox
                {
                    id: projectField
                    Layout.fillWidth: true
                    model: ["DPNI", "Panel", "Hugodims"]
                }
            }
            RowLayout
            {
                width: scrollArea.viewport.width
                spacing: 10

                Text
                {
                    height: Regovar.theme.font.size.header
                    Layout.minimumWidth: root.labelColWidth
                    text: qsTr("Referencial")
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    onTextChanged: root.readyForNext = checkReadyreadyForNext();
                }

                ComboBox
                {
                    Layout.fillWidth: true
                    id: refField
                    model: ["Hg38", "Hg19", "Hg18"]
                    currentIndex: 1
                    onCurrentIndexChanged: root.readyForNext = checkReadyreadyForNext();
                }
            }
        }
    }
}
