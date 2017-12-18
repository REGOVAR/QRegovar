import QtQuick 2.9
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

    width: 500
    height: 300

    property alias filterName: nameField.text
    property alias filterDescription: descriptionField.text
    property int filterId: -1
    property bool saveAdvancedFilter: true



    contentItem: Rectangle
    {
        id: root
        color: Regovar.theme.backgroundColor.main


        DialogHeader
        {
            id: header
            anchors.top : root.top
            anchors.left: root.left
            anchors.right: root.right
            iconText: "5"
            title: qsTr("Save your filter")
            text: qsTr("Give a name and an optional description to your current filter will allow you to retrieve it and reload it quickly thanks to the left panel \"saved filters\".")
        }


        GridLayout
        {
            anchors.top: header.bottom
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: okButton.top
            anchors.margins: 10

            columns: 2
            rows:2
            columnSpacing: 30
            rowSpacing: 10

            Text
            {
                text: qsTr("Name*")
                font.weight: Font.Black
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height:  Regovar.theme.font.boxSize.normal
            }
            TextField
            {
                id: nameField
                Layout.fillWidth: true
                placeholder: qsTr("Name of your filter (mandatory)")
            }
            Text
            {
                Layout.alignment: Qt.AlignTop
                text: qsTr("Description")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: Regovar.theme.font.boxSize.normal
            }
            TextArea
            {
                id: descriptionField
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }


        Button
        {
            id: okButton
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10

            text: qsTr("Save")
            onClicked:
            {
                model.editFilter(filterId, filterSavingFormPopup.filterName, filterSavingFormPopup.filterDescription, saveAdvancedFilter);
                filterSavingFormPopup.close();
            }
        }
        Button
        {
            id: cancelButton
            anchors.right: okButton.left
            anchors.bottom: parent.bottom
            anchors.margins: 10

            text: qsTr("Cancel")
            onClicked:
            {
                filterSavingFormPopup.close();
            }
        }
    }
}
