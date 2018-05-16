import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"
import "qrc:/qml/InformationPanel/Panel"

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
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
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
            text: qsTr("Edit panel")
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
            width: 100
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
    NewPanelVersionDialog { id: newPanelVersionDialog }



    /// Retrive model of the selected panel in the treeview and display information.
    function openSelectedPanel()
    {
        var itemId = regovar.panelsManager.panelsTree.data(browser.currentIndex, 257); // 257 = Qt::UserRole+1
        if (itemId !== undefined && itemId !== "")
        {
            regovar.getPanelInfo(itemId);
        }
    }

    /// Retrive model of the selected panel in the treeview and display wizard to create new version
    function updateSelectedPanel()
    {
        var itemId = regovar.panelsManager.panelsTree.data(browser.currentIndex, 257); // 257 = Qt::UserRole+1
        if (itemId !== undefined && itemId !== "")
        {
            newPanelVersionDialog.reset(regovar.panelsManager.getOrCreatePanel(itemId));
            newPanelVersionDialog.open();
        }

    }
}
