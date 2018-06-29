import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property Subject model
    property bool editionMode: false
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
        text: qsTr("This page gives you an overview of the subject.")
    }

    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins : 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10
        columns: 3
        columnSpacing: 10
        rowSpacing: 10

        Text
        {
            text: qsTr("Identifier*")
            font.bold: true
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: idField
            Layout.fillWidth: true
            enabled: editionMode
            placeholder: qsTr("Unique anonymous identifier")
            text: ""
        }

        Column
        {
            Layout.rowSpan: 7
            Layout.alignment: Qt.AlignTop
            spacing: 10

            Button
            {
                text: editionMode ? qsTr("Save") : qsTr("Edit")
                onClicked:
                {
                    editionMode = !editionMode;
                    if (!editionMode)
                    {
                        // when click on save : update model
                        updateModelFromView();
                    }
                }
            }

            Button
            {
                visible: editionMode
                text: qsTr("Cancel")
                onClicked: { updateViewFromModel(); editionMode = false; }
            }
        }

        Text
        {
            text: qsTr("Firstname")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: firstnameField
            Layout.fillWidth: true
            enabled: editionMode
            placeholder: qsTr("Firstname of the subject")
            text: ""
        }

        Text
        {
            text: qsTr("Lastname")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: lastnameField
            Layout.fillWidth: true
            enabled: editionMode
            placeholder: qsTr("Lastname of the subject")
            text: ""
        }

        Text
        {
            text: qsTr("Date of birth")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: dateOfBirthField
            Layout.fillWidth: true
            enabled: editionMode
            placeholder: qsTr("YYYY-MM-DD")
            text: ""
        }

        Text
        {
            text: qsTr("Sex")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        ComboBox
        {
            id: sexField
            Layout.fillWidth: true
            enabled: editionMode
            model: [qsTr("Unknow"), qsTr("Female"), qsTr("Male")]
        }

        Text
        {
            text: qsTr("Family number")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: familyNumberField
            Layout.fillWidth: true
            enabled: editionMode
            placeholder: qsTr("Family number of the subject")
            text: ""
        }

       // TODO: subject indicator
//        Text
//        {
//            text: qsTr("Indicator")
//            color: Regovar.theme.primaryColor.back.dark
//            font.pixelSize: Regovar.theme.font.size.normal
//            font.family: Regovar.theme.font.family
//            verticalAlignment: Text.AlignVCenter
//            height: 35
//        }
//        Rectangle
//        {
//            color: "transparent"
//            Layout.fillWidth: true
//            height: Regovar.theme.font.boxSize.normal
//            border.width: 1
//            border.color: Regovar.theme.boxColor.border
//            Text
//            {
//                anchors.centerIn: parent
//                text: qsTr("Not yet implemented")
//                font.pixelSize: Regovar.theme.font.size.normal
//                color: Regovar.theme.frontColor.disable
//                verticalAlignment: Text.AlignVCenter
//            }
//        }

        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Comment")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextArea
        {
            id: commentField
            Layout.fillWidth: true
            enabled: editionMode
            height: 3 * Regovar.theme.font.size.normal
            text: ""
        }



        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Events")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }

        TableView
        {
            id: events
            Layout.fillHeight: true
            Layout.fillWidth: true

            TableViewColumn
            {
                title: "Date"
                role: "date"
            }
            TableViewColumn
            {
                title: "Event"
                role: "message"
                width: 500
                delegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: styleData.textAlignment
                        font.pixelSize: Regovar.theme.font.size.normal
                        text: styleData.value.icon
                        font.family: Regovar.theme.icons.name
                    }
                    Text
                    {
                        anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                        anchors.rightMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: styleData.textAlignment
                        font.pixelSize: Regovar.theme.font.size.normal
                        text: styleData.value.message
                        elide: Text.ElideRight
                    }
                }
            }
        }

        Column
        {
            Layout.alignment: Qt.AlignTop
            spacing: 10

            Button
            {
                id: addFile
                text: qsTr("Add event")
                onClicked:
                {
                    eventDialog.reset(null);
                    eventDialog.open();
                }
            }

            Button
            {
                id: editFile
                text: qsTr("Edit event")
                onClicked:
                {

                }
            }
        }
    }

    NewEventDialog
    {
        id: eventDialog
    }

    function updateViewFromModel()
    {
        if (root.model)
        {
            nameLabel.text = root.model.identifier + " : " + root.model.lastname.toUpperCase() + " " + root.model.firstname;
            idField.text = root.model.identifier;
            firstnameField.text = root.model.firstname;
            lastnameField.text = root.model.lastname;
            dateOfBirthField.text = regovar.formatDate(root.model.dateOfBirth, false);
            familyNumberField.text = root.model.familyNumber;
            commentField.text = root.model.comment;
            sexField.currentIndex = root.model.sex;
            events.model = root.model.events;
            eventDialog.listModel = root.model.events;
        }
    }

    function updateModelFromView()
    {
        if (root.model)
        {
            root.model.edit(idField.text, firstnameField.text, lastnameField.text, commentField.text, familyNumberField.text, ["unknow", "female", "male"][sexField.currentIndex], regovar.dateFromString(dateOfBirthField.text));
            nameLabel.text = root.model.identifier + " : " + root.model.lastname.toUpperCase() + " " + root.model.firstname;
        }
    }
}
