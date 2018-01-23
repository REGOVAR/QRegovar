import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model
    onModelChanged:
    {
        if(model)
        {
            model.dataChanged.connect(function() {updateViewFromModel()});
        }

        updateViewFromModel();
    }

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        RowLayout
        {
            anchors.fill: parent
            anchors.margins: 10

            Text
            {
                id: nameLabel
                Layout.fillWidth: true

                font.pixelSize: 22
                font.family: Regovar.theme.font.family
                color: Regovar.theme.frontColor.normal
                verticalAlignment: Text.AlignVCenter
                text: "-"
                elide: Text.ElideRight
            }

            ConnectionStatus { }
        }
    }



    TableView
    {
        id: subjectsList
        anchors.left: root.left
        anchors.top: header.bottom
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        onDoubleClicked:
        {
            regovar.subjectsManager.openSubject(subjectsList.model[subjectsList.currentRow].id);
        }

        TableViewColumn
        {
            role: "identifier"
            title: qsTr("Identifier")
        }

        TableViewColumn
        {
            role: "lastname"
            title: qsTr("Lastname")
        }

        TableViewColumn
        {
            role: "firstname"
            title: qsTr("Firstname")
        }

        TableViewColumn
        {
            role: "dateOfBirth"
            title: qsTr("Date of birth")
            delegate: Text
            {
                anchors.fill: parent
                anchors.margins: 5
                verticalAlignment: Text.AlignVCenter
                text: Regovar.formatShortDate(modelData.dateOfBirth)
                elide: Text.ElideRight
            }
        }

        TableViewColumn
        {
            role: "comment"
            title: qsTr("Comment")
        }
    }

    function updateViewFromModel()
    {
        if (root.model)
        {
            nameLabel.text = root.model.name;
            subjectsList.model = root.model.subjects;
        }
    }
}
