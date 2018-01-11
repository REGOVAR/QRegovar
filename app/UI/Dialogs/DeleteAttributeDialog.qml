import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: attributePopup
    modality: Qt.WindowModal

    title: qsTr("Create a new attribute")

    width: 500
    height: 300
    property real labelColumnWidth: 0

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
            iconText: "h"
            title: qsTr("Delete samples attribute")
            text: qsTr("Check attributes you wants to delete. This action is irreversible.\nWarning, no confirmation question will be ask when you will click on the bottom right \Delete\" button.")
        }


        ScrollView
        {
            id: scrollView
            anchors.top: header.bottom
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: okButton.top
            anchors.margins: 10

            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                id: attributesList
                spacing: 5

                Text
                {
                    Layout.columnSpan: 2
                    text: qsTr("Attributes to delete : ")
                    font.weight: Font.Black
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }

                Repeater
                {
                    model: regovar.analysesManager.newFiltering.attributes

                    CheckBox
                    {
                        width: scrollView.width
                        text: modelData.name
                        checked: false
                    }
                }
            }
        }

        Button
        {
            id: okButton
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10

            text: qsTr("Delete")
            onClicked:
            {
                for (var i=0; i<attributesList.children.length; i++)
                {
                    var comp = attributesList.children[i];
                    if (comp.checked)
                    {
                        regovar.analysesManager.newFiltering.deleteAttribute(comp.text);
                    }
                }
                attributePopup.close();
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
                attributePopup.close();
            }
        }
    }

    function checkSave()
    {
        for (var i=0; i<attributesList.children.length; i++)
        {
            var comp = attributesList.children[i];
            if (comp.checked)
            {
                okButton.enabled = true;
                break;
            }
        }
    }

    onVisibleChanged: { checkSave(); }
}
