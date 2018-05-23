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

        ConnectionStatus
        {
            id: connectionStatus
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }

        TextField
        {
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.right: connectionStatus.left
            anchors.margins: 10

            property string formerSearch: ""
            iconLeft: "z"
            displayClearButton: true
            placeholder: qsTr("Search panel by name, description or owner ...")
            onEditingFinished:
            {
                if (formerSearch != text && text != "")
                {
                    regovar.panelsManager.proxy.setFilterString(text);
                    formerSearch = text;
                }
            }
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
            onClicked: newPanel()
        }
        Button
        {
            text: qsTr("Edit panel")
            onClicked: editPanel()
            enabled: browser.currentIndex
        }
        Button
        {
            text: qsTr("Open panel")
            onClicked:openPanel()
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
        model: regovar.panelsManager.proxy

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


    // reset and open wizard
    function newPanel()
    {
        newPanelDialog.reset();
        newPanelDialog.open();
    }

    // Retrive model of the selected panel in the treeview and edit information.
    function editPanel()
    {
        var idx = regovar.panelsManager.proxy.mapToSource(browser.currentIndex);
        var panelId = regovar.panelsManager.panelsTree.data(idx, 257); // 257 = Qt::UserRole+1
        if (panelId !== undefined && panelId !== "")
        {
            newPanelVersionDialog.reset(regovar.panelsManager.getOrCreatePanel(panelId));
            newPanelVersionDialog.open();
        }
    }

    // Retrive model of the selected panel in the treeview and display information.
    function openPanel()
    {
        var idx = regovar.panelsManager.proxy.mapToSource(browser.currentIndex);
        var itemId = regovar.panelsManager.panelsTree.data(idx, 257); // 257 = Qt::UserRole+1
        if (itemId !== undefined && itemId !== "")
        {
            regovar.getPanelInfo(itemId);
        }
    }
}
