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


        Rectangle
        {
            id: header
            anchors.top : root.top
            anchors.left: root.left
            anchors.right: root.right
            height: 100

            color: Regovar.theme.primaryColor.back.normal


            Text
            {
                id: headerIcon
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.margins: 10
                width: 80
                height: 80

                text: "5"
                color: Regovar.theme.primaryColor.front.dark
                font.family: Regovar.theme.icons.name
                font.weight: Font.Black
                font.pixelSize: 80
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:  Text.AlignHCenter
            }


            Text
            {
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 10
                anchors.leftMargin: 100


                text: qsTr("Save your filter")
                font.pixelSize: Regovar.theme.font.size.title
                font.bold: true
                color: Regovar.theme.primaryColor.front.normal
                elide: Text.ElideRight
            }
            Text
            {
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                anchors.topMargin: 15 + Regovar.theme.font.size.title
                anchors.leftMargin: 100
                wrapMode: "WordWrap"
                elide: Text.ElideRight

                text: qsTr("Give a name and an optional description to your current filter will allow you to retrieve it and reload it quickly thanks to the left panel \"saved filters\".")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.front.normal
            }
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
                placeholderText: qsTr("Name of your filter (mandatory)")
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
