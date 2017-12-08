import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property bool editionMode: false
    property var model
    onModelChanged:  if (model) { updateFromModel(model); }


    function updateFromModel(data)
    {
        console.log("display info panel of FileInfos dialog")
    }



    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10


        // Editable informations
        GridLayout
        {
            Layout.fillWidth: true
            rows: 3
            columns: 3
            columnSpacing: 10
            rowSpacing: 10

            Text
            {
                text: qsTr("Name*")
                font.bold: true
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: nameField
                Layout.fillWidth: true
                enabled: editionMode
                placeholderText: qsTr("Name of the file")
            }

            Column
            {
                Layout.rowSpan: 3
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
                text: qsTr("Tag")
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
                placeholderText: qsTr("List of tags")
            }

            Text
            {
                Layout.alignment: Qt.AlignTop
                text: qsTr("Comment")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextArea
            {
                id: firstnameField
                Layout.fillWidth: true
                enabled: editionMode
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 10

            // remote file infos
            GridLayout
            {
                rows: 6
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Text
                    {
                        width: Regovar.theme.font.boxSize.header
                        height: Regovar.theme.font.boxSize.header
                        text: "è"

                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        text: qsTr("Remote file")
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.dark
                        elide: Text.ElideRight
                    }
                }

                Text
                {
                    text: qsTr("Creation")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "2017-12-25 17:45"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Size")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "2.65 Go"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Status")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "Checked"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Md5")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "415a54c5a24f4g35a51a55sd41fg4"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Source")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "Uploaded by a user"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Item
                {
                    Layout.fillHeight: true
                    width: 1

                }
            }

            Rectangle
            {
                Layout.fillHeight: true
                width: 1
                color: Regovar.theme.primaryColor.back.normal
            }

            // local file infos
            GridLayout
            {
                rows: 6
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Text
                    {
                        width: Regovar.theme.font.boxSize.header
                        height: Regovar.theme.font.boxSize.header
                        text: "ë"

                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        text: qsTr("Local file")
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.dark
                        elide: Text.ElideRight
                    }
                }

                Text
                {
                    text: qsTr("Creation")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "2017-12-25 17:45"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Size")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "2.65 Go"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Status")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "Checked"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Md5")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "415a54c5a24f4g35a51a55sd41fg4"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Path")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: regovar.settings.localCacheDir + "6/toto.xml"
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Item
                {
                    Layout.fillHeight: true
                    width: 1

                }
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
            dateOfBirthField.text = model.dateOfBirth;
            familyNumberField.text = model.familyNumber;
            commentField.text = model.comment;
        }
    }

    function updateModelFromView()
    {
        if (model)
        {
            var json={};
            json["identifier"] = idField.text;
            json["firstname"] = firstnameField.text;
            json["lastname"] = lastnameField.text;
            json["dateOfBirth"] = dateOfBirthField.text;
            json["familyNumber"] = familyNumberField.text;
            json["comment"] = commentField.text;

            model.deleteLater()
        }
    }

}
