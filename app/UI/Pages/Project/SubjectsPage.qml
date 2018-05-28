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


    TextField
    {
        id: browserSearch
        anchors.left: root.left
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.margins: 10
        iconLeft: "z"
        displayClearButton: true
        placeholder: qsTr("Search subjects by names, comments...")
        onTextChanged: root.model.subjects.proxy.setFilterString(text)
    }

    TableView
    {
        id: browser
        anchors.left: root.left
        anchors.top: browserSearch.bottom
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        onDoubleClicked:
        {
            var idx = root.model.subjects.proxy.getModelIndex(browser.currentRow);
            var id = root.model.subjects.data(idx, 257); // 257 = Qt::UserRole+1
            regovar.subjectsManager.openSubject(id);
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
            browser.model = root.model.subjects.proxy;
        }
    }
}
