import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: checkReadyreadyForNext();
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
        text: qsTr("Configure your filtering analysis.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.control
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
                    text: qsTr("Name")
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    onTextChanged: root.readyForNext = checkReadyreadyForNext();
                }
                TextField
                {
                    id: nameField
                    Layout.fillWidth: true
                    placeholderText: qsTr("The name of the analysis")
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
                    font.pixelSize: Regovar.theme.font.size.control
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
//            RowLayout
//            {
//                width: scrollArea.viewport.width
//                spacing: 10

//                Text
//                {
//                    height: Regovar.theme.font.size.header
//                    Layout.minimumWidth: root.labelColWidth
//                    text: qsTr("Type")
//                    color: Regovar.theme.frontColor.normal
//                    font.pixelSize: Regovar.theme.font.size.control
//                    font.family: Regovar.theme.font.familly
//                    verticalAlignment: Text.AlignVCenter
//                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
//                }

//                ComboBox
//                {
//                    Layout.fillWidth: true
//                    id: typeField
//                    model: ["Cutom", "Trio"]
//                    onCurrentIndexChanged: root.readyForNext = checkReadyreadyForNext();
//                }
//            }
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
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                }

                ComboBox
                {
                    Layout.fillWidth: true
                    id: projectField
                    model: ["Select a project", "DPNI", "Panel onchogénétique", "Hugodims"]
                    onCurrentIndexChanged: root.readyForNext = checkReadyreadyForNext();
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
                    text: qsTr("Comment")
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                }
                TextField
                {
                    id: commentField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Optional comment")
                }
            }
        }
    }
}
