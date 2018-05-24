import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Dialog
{
    id: root

    title: qsTr("Add panel entry")

    // modality: Qt.NonModal

    width: 600
    height: 400

    property int currentStep: 1

    property var newEntryModel: ({ "label": "", "type": "", "chr": "", "start": "", "end": "", "type": "region"})


    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.alt



        DialogHeader
        {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            iconText: "à"
            title: qsTr("New panel entry")
            text: qsTr("")
        }



        TabView
        {
            id: tabView
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10

            smallHeader: true
            tabSharedModel: root.newEntryModel

            tabsModel: ListModel
            {
                ListElement
                {
                    enabled: true
                    title: qsTr("Gene & Phenotype")
                    source: "../InformationPanel/Panel/PanelFormNewGene.qml"
                }
                ListElement
                {
                    enabled: true
                    title: qsTr("Custom")
                    source: "../InformationPanel/Panel/PanelFormNewCustom.qml"
                }
            }
        }

        Row
        {
            id: footer
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10

            height: Regovar.theme.font.boxSize.normal
            spacing: 10
            visible: tabView.currentIndex == 1


            Button
            {
                text: qsTr("Add new entry")
                onClicked: regovar.panelsManager.newPanel.addEntry(root.newEntryModel);
            }
        }

        Rectangle
        {
            id: loadingIndicator
            anchors.fill : parent
            color: Regovar.theme.backgroundColor.alt
            visible: false

            BusyIndicator
            {
                anchors.centerIn: parent
            }
        }
    }
}
