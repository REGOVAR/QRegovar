import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0
import QtQuick.Dialogs 1.2

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property PipelineAnalysis model
    property bool editionMode: false
    property bool isRunning: false
    property bool isResumable: false
    property bool isClosed: false

    onModelChanged:
    {
        if (model)
        {
            model.dataChanged.connect(updateViewFromModel);
            model.statusChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }
    Component.onDestruction:
    {
        root.model.dataChanged.disconnect(updateViewFromModel);
        root.model.statusChanged.disconnect(updateViewFromModel);
    }



    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Rectangle
        {
            id: headerLogo
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.leftMargin: 10
            width: 40
            height: 40

            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border

            Image
            {
                id: pipelineLogo
                anchors.fill: parent
                anchors.margins: 3
            }
        }

        Text
        {
            id: headerTitle
            anchors.fill: header
            anchors.margins: 10
            anchors.leftMargin: headerLogo.visible ? 60 : 10
            font.pixelSize: 20
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

        visible: Regovar.helpInfoBoxDisplayed
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("This page allow you to browse \"results\" documents created by the pipeline.")
    }



    Item
    {
        anchors.left: root.left
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        Row
        {
            id: errorMessage
            anchors.centerIn: parent
            Text
            {
                height: Regovar.theme.font.boxSize.header
                width: Regovar.theme.font.boxSize.header
                font.pixelSize: Regovar.theme.font.size.header
                font.family: Regovar.theme.icons.name
                color: Regovar.theme.primaryColor.back.normal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "j"
            }

            Text
            {
                height: Regovar.theme.font.boxSize.header
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.normal
                verticalAlignment: Text.AlignVCenter
                text: qsTr("No result available")
            }
        }

        FilesBrowser
        {
            id: filesBrowser
            anchors.fill: parent
        }
    }










    Rectangle
    {
        id: busyIndicator
        anchors.fill: parent

        color: Regovar.theme.backgroundColor.overlay

        MouseArea
        {
            anchors.fill: parent
        }
        BusyIndicator
        {
            anchors.centerIn: parent
        }
    }

    QuestionDialog
    {
        id: confirmCancelDialog
        icon: "m"
        text: qsTr("Canceling an analysis is irreversible.\nThe task will be interrupted and the generated data will remain in the current state and available only on the server (not via this tool).\n\nDo you confirm the interruption of this analysis ?")

        onYes: root.model.cancel()
        onNo: close()
    }


    function updateViewFromModel()
    {
        if (root.model)
        {
            busyIndicator.visible = !root.model.loaded;
            headerTitle.text = model.name;
            if (root.model.pipeline && root.model.pipeline.icon)
            {
                pipelineLogo.source = root.model.pipeline.icon;
            }

            if (root.model.status == "done" && filesBrowser.model != model.outputsFiles)
            {
                filesBrowser.visible = true;
                errorMessage.visible = false;
                filesBrowser.model = model.outputsFiles;
            }
        }
    }

    property var existingLogs: []

    function updateLogsView()
    {
        // Update tabs

        if (root.model.loaded)
        {
            var needRefresh = false;
            var documents = ("documents" in data) ? data["documents"] : {};
            var ttt = logsView.tabsModel; //listModel.createObject(root);

            for (var idx in root.model.logs)
            {
                var logModel = root.model.logs[idx];
                var name =  logModel.url.substring(logModel.url.lastIndexOf("/") + 1);
                if (existingLogs.indexOf(logModel.url) == -1)
                {
                    ttt.append(
                    {   "title": name,
                        "icon": "Y",
                        "source": "qrc:/qml/Pages/Analysis/Pipeline/LogPage.qml",
                        "tabModel" : logModel
                    });
                    existingLogs.push(logModel.url);
                    needRefresh = true;
                }
            }

            if (needRefresh)
                logsView.forceRefreshTabs();

            //logsView.tabsModel = ttt;
        }
    }
}



