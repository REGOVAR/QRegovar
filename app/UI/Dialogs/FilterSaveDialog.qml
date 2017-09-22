import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: filterSavingFormPopup
    modality: Qt.WindowModal

    title: qsTr("Save your filter")

    width: 300
    height: 200

    property alias filterName: nameField.text
    property alias filterDescription: descriptionField.text




    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.main

        Rectangle
        {
            id: header
            color: Regovar.theme.primaryColor.back.dark
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 50

            Row
            {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                Text
                {
                    text: "5"
                    color: Regovar.theme.primaryColor.front.dark
                    font.family: Regovar.theme.icons.name
                    font.weight: Font.Black
                    font.pixelSize: Regovar.theme.font.size.header
                    width: 50
                    height: 50
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment:  Text.AlignHCenter
                }

                Text
                {
                    text: qsTr("Save your filter")
                    color: Regovar.theme.primaryColor.front.dark
                    font.family: "Sans"
                    font.weight: Font.Black
                    font.pixelSize: Regovar.theme.font.size.header
                    height: 50
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        ColumnLayout
        {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 10


            Grid
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                columns: 2
                rows:2
                columnSpacing: 30
                rowSpacing: 10

                Text
                {
                    text: qsTr("Name*")
                    font.weight: Font.Black
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.header
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                TextField
                {
                    id: nameField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Name of your filter (mandatory)")
                }
                Text
                {
                    text: qsTr("Description")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.header
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                TextArea
                {
                    id: descriptionField
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            Row
            {
                spacing: 10
                anchors.right: parent.right
                height: cancelButton.height
                width: cancelButton.width + 10 + okButton.width


                Button
                {
                    id: cancelButton
                    text: qsTr("Cancel")

                    onClicked:
                    {
                        filterSavingFormPopup.close();
                    }
                }

                Button
                {
                    id: okButton
                    text: qsTr("Save")

                    onClicked:
                    {
                        model.saveCurrentFilter(filterSavingFormPopup.filterName, filterSavingFormPopup.filterDescription);
                        filterSavingFormPopup.close();
                    }
                }
            }
        }
    }
}
