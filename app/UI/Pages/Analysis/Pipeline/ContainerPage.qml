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
            busyIndicator.visible = true;
            root.model.dataChanged.connect(updateViewFromModel);
            root.model.statusChanged.connect(updateStatusFromModel);
            updateViewFromModel();
        }
    }
    Component.onDestruction:
    {
        root.model.dataChanged.disconnect(updateViewFromModel);
        root.model.statusChanged.disconnect(updateStatusFromModel);
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



    ColumnLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        spacing: 10

        // Help information on this page
        Box
        {
            id: helpInfoBox
            Layout.fillWidth: true

            visible: Regovar.helpInfoBoxDisplayed
            icon: "k"
            text: qsTr("As long as the pipeline is running, this screen will provide you hardware monitoring informations.")
        }


        // Status bar
        RowLayout
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            spacing: 10


            Rectangle
            {
                id: statusBar
                Layout.fillWidth: true
                height: Regovar.theme.font.boxSize.title
                property color mainColor: Regovar.theme.frontColor.disable
                border.width: 1
                color: Regovar.theme.lighter(statusBar.mainColor, 1.7)
                border.color: Regovar.theme.darker(statusBar.mainColor)
                radius: 2
                onWidthChanged: redrawStatusProgress()

                Rectangle
                {
                    anchors.top: parent.top
                    anchors.topMargin: 1
                    anchors.left: parent.left
                    anchors.leftMargin: 1
                    height: Regovar.theme.font.boxSize.title - 2
                    width: Regovar.theme.font.boxSize.title
                    color: Regovar.theme.lighter(statusBar.mainColor)
                    radius: 2
                }
                Rectangle
                {
                    id: statusBarProgress
                    anchors.top: parent.top
                    anchors.topMargin: 1
                    anchors.left: parent.left
                    anchors.leftMargin: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.title - 2
                    color: Regovar.theme.lighter(statusBar.mainColor)
                    radius: 2
                }


                RowLayout
                {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 10

                    Text
                    {
                        id: statusIcon
                        height: Regovar.theme.font.boxSize.title
                        width: Regovar.theme.font.boxSize.title
                        color: statusBar.mainColor
                        font.pixelSize: Regovar.theme.font.size.header
                        font.family: Regovar.theme.icons.name
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "n"
                        onTextChanged:
                        {
                            if (regovar.analysisStatusIconAnimated(root.model.status))
                            {
                                statusIconAnimation.start();
                            }
                            else
                            {
                                statusIconAnimation.stop();
                                rotation = 0;
                            }
                        }
                        NumberAnimation on rotation
                        {
                            id: statusIconAnimation
                            duration: 1500
                            loops: Animation.Infinite
                            from: 0
                            to: 360
                        }
                    }

                    Text
                    {
                        id: statusField
                        Layout.fillWidth: true
                        height: Regovar.theme.font.boxSize.title
                        color: Regovar.theme.darker(statusBar.mainColor)
                        font.pixelSize: Regovar.theme.font.size.header
                        font.family: Regovar.theme.font.family
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }


            ButtonIcon
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                iconTxt: isRunning ? "y" : "x"
                text: ""
                ToolTip.text: isRunning ? qsTr("Pause") : qsTr("Resume")
                ToolTip.visible: hovered
                enabled: root.isResumable
                onClicked:
                {
                    if (isRunning)
                    {
                        root.model.pause();
                    }
                    else
                    {
                        root.model.start();
                    }
                }
            }

            ButtonIcon
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                iconTxt: "h"
                text: ""
                ToolTip.text: qsTr("Cancel")
                ToolTip.visible: hovered
                colorMain: Regovar.theme.frontColor.danger
                colorHover: Regovar.theme.lighter(Regovar.theme.frontColor.danger)
                colorDown: Regovar.theme.darker(Regovar.theme.frontColor.danger)
                enabled: !root.isClosed
                onClicked: confirmCancelDialog.open()
            }
        }



        Text
        {
            visible: !root.isRunning && !root.isResumable
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("No container information available")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: Regovar.theme.frontColor.disable
        }

        // Container hardware info
        Rectangle
        {
            visible: root.isRunning || root.isResumable
            radius: 2
            color: Regovar.theme.boxColor.back
            border.color: Regovar.theme.boxColor.border
            border.width: 1
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header + 20

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    text: qsTr("CPU: -")
                    font.pixelSize: Regovar.theme.font.size.header
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    text: qsTr("RAM: -")
                    font.pixelSize: Regovar.theme.font.size.header
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    text: qsTr("DISK: -")
                    font.pixelSize: Regovar.theme.font.size.header
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    text: qsTr("NET: -")
                    font.pixelSize: Regovar.theme.font.size.header
                }
            }
        }

        // Container ps
        Text
        {
            visible: root.isRunning || root.isResumable
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: root.model.config.toString()
        }
    }

    Component
    {
        id:listModel
        ListModel {}
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



    function redrawStatusProgress()
    {
        statusBarProgress.width = (statusBar.width - Regovar.theme.font.boxSize.title) * root.model.progressValue - 1; // -1 to keep the border of background visible
    }

    function updateStatusFromModel()
    {
        if (root.model.status == "error" || root.model.status == "canceled" )
        {
            statusBar.mainColor = Regovar.theme.frontColor.danger;
        }
        else if (root.model.status == "running" || root.model.status == "done" )
        {
            statusBar.mainColor = Regovar.theme.frontColor.success;
        }
        else
        {
            statusBar.mainColor = Regovar.theme.frontColor.warning;
        }


        root.isRunning = root.model.status == "running";
        root.isClosed = root.model.status == "done" ||  root.model.status == "canceled"  ||  root.model.status == "error" ;
        root.isResumable = root.model.status == "running" || root.model.status == "pause";

        // update status
        statusIcon.text = regovar.analysisStatusIcon(root.model.status);
        statusField.text = regovar.analysisStatusLabel(root.model.status);
        if (root.model.progressValue > 0 && root.model.status != "done")
        {
            statusField.text += " (" + (root.model.progressValue*100).toFixed(1) + "%)";
            statusField.text += ": " + root.model.progressLabel;
        }
        if (regovar.analysisStatusIconAnimated(root.model.status))
        {
            statusIconAnimation.start();
        }
        else
        {
            statusIconAnimation.stop();
            statusIcon.rotation = 0;
        }
        redrawStatusProgress();
    }

    function updateViewFromModel()
    {
        if (root.model)
        {
            busyIndicator.visible = !root.model.loaded;

            if (root.model.pipeline && root.model.pipeline.icon)
            {
                pipelineLogo.source = root.model.pipeline.icon;
            }
            headerTitle.text = model.name;
            updateStatusFromModel();
        }
    }
}



