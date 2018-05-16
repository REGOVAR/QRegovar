import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model
    onModelChanged:
    {
        if(model)
        {
            model.dataChanged.connect(updateViewFromModel);
        }
        updateViewFromModel();
    }
    Component.onDestruction:
    {
        model.dataChanged.disconnect(updateViewFromModel);
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
                font.pixelSize: Regovar.theme.font.size.title
                font.weight: Font.Black
                color: Regovar.theme.primaryColor.back.dark
                verticalAlignment: Text.AlignVCenter
                text: "-"
                elide: Text.ElideRight
            }

            ConnectionStatus { }
        }
    }

    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("This page list all subjects that have been analyzed in the current folder.")
    }



    TableView
    {
        id: subjectsList
        anchors.left: root.left
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
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
                text: regovar.formatDate(modelData.dateOfBirth, false)
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
