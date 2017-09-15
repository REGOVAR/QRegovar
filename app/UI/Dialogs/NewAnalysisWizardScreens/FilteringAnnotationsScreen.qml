import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true //checkReadyreadyForNext();
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
        text: qsTr("Select the annotations databases and their versions to annotate the variants.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.control
        color: Regovar.theme.primaryColor.back.normal
    }




    ColumnLayout
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10

        Text
        {
            text: qsTr("Selected annotations databases")
            font.pixelSize: Regovar.theme.font.size.control
            color: Regovar.theme.frontColor.normal
        }
        TableView
        {
            id: samplesList
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: ListModel
            {
                ListElement {
                    name: "VEP"
                    version: "76"
                    description: ""
                }
                ListElement {
                    name: "VEP"
                    version: "75"
                    description: ""
                }
                ListElement {
                    name: "VEP"
                    version: "59"
                    description: ""
                }
                ListElement {
                    name: "SnpEff"
                    version: "2.3"
                    description: ""
                }
                ListElement {
                    name: "SnpEff"
                    version: "2.1"
                    description: ""
                }
                ListElement {
                    name: "dbNFSP"
                    version: "3.3"
                    description: ""
                }
                ListElement {
                    name: "dbNFSP"
                    version: "3.2"
                    description: ""
                }
                ListElement {
                    name: "dbNFSP"
                    version: "3.1"
                    description: ""
                }
            }

            TableViewColumn
            {
                title: qsTr("Name")
                role: "name"
                delegate: CheckBox
                {
                    text: model.name
                    checked: false
                }
            }
            TableViewColumn
            {
                title: qsTr("Version")
                role: "version"
            }
            TableViewColumn
            {
                title: qsTr("Description")
                role: "description"
            }
        }

    }


}
