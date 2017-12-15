import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property bool editionMode: false
    property QtObject model
    onModelChanged: updateViewFromModel(model)




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
                font.family: Regovar.theme.font.familly
                color: Regovar.theme.frontColor.normal
                verticalAlignment: Text.AlignVCenter
                text: "-"
                elide: Text.ElideRight
            }

            ConnectionStatus { }
        }
    }

    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        rows: 8
        columns: 3
        columnSpacing: 10
        rowSpacing: 10


        Text
        {
            text: qsTr("Identifier*")
            font.bold: true
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: idField
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Unique anonymous identifier")
            text: "MD-65-45"
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
                onClicked: { updateViewFromModel(model); editionMode = false; }
            }
        }




        Text
        {
            text: qsTr("Firstname")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: firstnameField
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Firstname of the subject")
            text: ""
        }

        Text
        {
            text: qsTr("Lastname")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: lastnameField
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Lastname of the subject")
            text: ""
        }

        Text
        {
            text: qsTr("Date of birth")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: dateOfBirthField
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("YYYY-MM-DD")
            text: ""
        }

        Text
        {
            text: qsTr("Family number")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: familyNumberField
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Family number of the subject")
            text: ""
        }

        Text
        {
            text: qsTr("Indicator")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Rectangle
        {
            color: "transparent"
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.normal
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            Text
            {
                anchors.fill: parent
                text: qsTr("Not yet implemented")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.disable
                verticalAlignment: Text.AlignVCenter
            }
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
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }



        TreeView
        {
            id: events
            Layout.fillWidth: true
            Layout.fillHeight: true


            TableViewColumn
            {
                title: "Date"
                role: "filenameUI"
            }
            TableViewColumn
            {
                title: "Event"
                role: "filenameUI"
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
                enabled: false
            }

            Button
            {
                id: editFile
                text: qsTr("Edit event")
                enabled: false
            }
        }
    }

    function updateViewFromModel(model)
    {
        if (model)
        {
            nameLabel.text = model.identifier + " : " + model.lastname.toUpperCase() + " " + model.firstname;
            idField.text = model.identifier;
            firstnameField.text = model.firstname;
            lastnameField.text = model.lastname;
            dateOfBirthField.text = Regovar.formatShortDate(model.dateOfBirth);
            familyNumberField.text = model.familyNumber;
            commentField.text = model.comment;
        }
    }

    function updateModelFromView()
    {
        if (model)
        {
            model.identifier = idField.text;
            model.firstname = firstnameField.text;
            model.lastname = lastnameField.text;
            model.familyNumber = familyNumberField.text;
            model.comment = commentField.text;
            model.dateOfBirth = Regovar.dateFromShortString(dateOfBirthField.text);

            model.save();
            nameLabel.text = model.identifier + " : " + model.lastname.toUpperCase() + " " + model.firstname;
        }
    }
}
