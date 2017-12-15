import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//import org.regovar 1.0

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"
import "../../InformationsPanel/Panel"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model



    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            text: qsTr("Panels settings")
            font.pixelSize: 20
            font.weight: Font.Black
        }
        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
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
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("Browse, create and edit genes panels.")
    }

    Column
    {
        id: actionsPanel
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            text: qsTr("New panel")
            onClicked:
            {
                // reset and open wizard
                newPanelDialog.reset();
                newPanelDialog.open();
            }
        }
        Button
        {
            text: qsTr("Update panel")
            onClicked: updateSelectedPanel()
            enabled: browser.currentIndex
        }
        Button
        {
            text: qsTr("Open panel")
             onClicked: openSelectedPanel()
             enabled: browser.currentIndex
        }
    }


    TreeView
    {
        id: browser
        anchors.left: root.left
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10
        model: regovar.panelsManager.panelsTree

        TableViewColumn
        {
            role: "name"
            title: "Name"
            width: 250
        }
        TableViewColumn
        {
            role: "shared"
            title: "Shared"
            width: 50
        }
        TableViewColumn
        {
            role: "date"
            title: "Date"
        }
        TableViewColumn
        {
            role: "comment"
            title: "Comment"
            width: 400
        }
    }

    NewPanelDialog { id: newPanelDialog }


    Connections
    {
        target: regovar
        onVariantInformationReady: onOpenVariantInfoDialogFinish(json)
    }
    Dialog
    {
        id: viewPanelDialog
        title: qsTr("Panel informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400

        property alias data: infoPanel.model

        contentItem: PanelInformations
        {
            id: infoPanel
        }
    }



    /// Retrive model of the selected panel in the treeview and display information.
    function openSelectedPanel()
    {

        var item = regovar.panelsManager.panelsTreeView.data(browser.currentIndex, 257); // 257 = Qt::UserRole+1
        if (item !== undefined)
        {
            if (item.isAnalysis)
                regovar.analysesManager.openAnalysis(item.type, item.id);
            else
                regovar.projectsManager.openProject(item.id);
        }
    }

    /// Retrive model of the selected panel in the treeview and display wizard to create new version
    function updateSelectedPanel()
    {
        var panelId = regovar.panelsManager.panelsTree.data(browser.currentIndex, 257); // 257 = Qt::UserRole+1
        newPanelDialog.model = regovar.panelsManager.getOrCreatePanel(panelId);
        newPanelDialog.open();
    }
}
