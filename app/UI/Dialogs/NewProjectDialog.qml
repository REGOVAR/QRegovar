import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: root
    modality: Qt.WindowModal

    title: qsTr("Create new project")

    width: 800
    height: 600


    Connections
    {
        target: regovar
        onProjectCreationDone:
        {
            loadingIndicator.visible = false;
            if (success) root.close();
        }
    }


    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.alt



        Text
        {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            text: qsTr("Creating a new project will allow you to organize your analyses and find them more easily afterwards.\nTo create a project, the name is mandatory.")
            wrapMode: Text.WordWrap
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
        }


        GridLayout
        {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10

            rows: 2
            columns: 2
            columnSpacing: 30
            rowSpacing: 10


            Text
            {
                text: qsTr("Name*")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
                font.bold: true
            }
            TextField
            {
                id: nameField
                Layout.fillWidth: true
                placeholderText: qsTr("Name of the project")
            }

            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                text: qsTr("Comment")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextArea
            {
                id: commentField
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        Row
        {
            id: footer
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10

            height: Regovar.theme.font.boxSize.normal
            spacing: 10

            Button
            {
                text: qsTr("Cancel")
                onClicked: root.close()
            }

            Button
            {
                text: qsTr("Create")
                onClicked:
                {
                    if (nameField.text.trim() != "")
                    {
                        loadingIndicator.visible = true;
                        regovar.newProject(nameField.text, commentField.text);
                    }
                }
            }
        }

        Rectangle
        {
            id: loadingIndicator
            anchors.fill : parent
            color: Regovar.theme.backgroundColor.alt
            visible: false

            BusyIndicator
            {
                anchors.centerIn: parent
            }
        }
    }

    function reset()
    {
        nameField.text = "";
        commentField.text = "";
    }
}
