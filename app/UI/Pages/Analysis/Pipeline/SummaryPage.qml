import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0
import QtQuick.Dialogs 1.2

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"
import "../../Browse"

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
        }
        updateViewFromModel();
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


    Rectangle
    {
        id: rowHeadBackground
        anchors.left: root.left
        anchors.top: header.bottom
        anchors.bottom: root.bottom
        height: 50
        color: Regovar.theme.backgroundColor.alt
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
            text: qsTr("This page give you an overview of the analysis.")
        }

        GridLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 3
            columnSpacing: 10
            rowSpacing: 10

            Box
            {
                id: statusBox
                Layout.fillWidth: true
                Layout.columnSpan: 2
                mainColor: Regovar.theme.frontColor.warning
                icon: ""
                text: ""
            }
            RowLayout
            {
                ButtonIcon
                {
                    width: Regovar.theme.font.boxSize.header
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
                    width: Regovar.theme.font.boxSize.header
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

            /*
            Text
            {
                text: qsTr("Status")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            RowLayout
            {
                Layout.fillWidth: true
                spacing: 10
                Text
                {
                    id: statusIcon
                    height: Regovar.theme.font.size.header
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.icons.name
                    verticalAlignment: Text.AlignVCenter
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
                    height: Regovar.theme.font.size.header
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                }
            }



            Column
            {
                Layout.rowSpan: 5
                Layout.alignment: Qt.AlignTop
                spacing: 10


                ButtonIcon
                {
                    iconTxt: isRunning ? "y" : "x"
                    text: isRunning ? qsTr("Pause") : qsTr("Resume")
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
                    iconTxt: "h"
                    text: qsTr("Cancel")
                    colorMain: Regovar.theme.frontColor.danger
                    colorHover: Regovar.theme.lighter(Regovar.theme.frontColor.danger)
                    colorDown: Regovar.theme.darker(Regovar.theme.frontColor.danger)
                    enabled: !root.isClosed
                    onClicked: confirmCancelDialog.open()
                }
            }
            */




            // INFO ========================================================
            Row
            {
                onWidthChanged: rowHeadBackground.width = Math.max(width + 10, rowHeadBackground.width)
                height: Regovar.theme.font.boxSize.header
                spacing: 10
                Text
                {
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header
                    text: "k"

                    font.family: Regovar.theme.icons.name
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header

                    elide: Text.ElideRight
                    text: qsTr("Information")
                    font.bold: true
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
            }
            Item
            {
                Layout.columnSpan: 2
                width: 10; height: 10
            }

            RowLayout
            {
                Item
                {
                    Layout.minimumWidth: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.normal
                }

                Text
                {
                    text: qsTr("Name*")
                    font.bold: true
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }
            }
            TextField
            {
                id: nameField
                Layout.fillWidth: true
                enabled: editionMode
                placeholder: qsTr("Name of the analysis")
                onTextChanged: if (model) model.name = text
            }

            Column
            {
                Layout.rowSpan: 7
                Layout.alignment: Qt.AlignTop
                spacing: 10


                Button
                {
                    text: editionMode ? qsTr("Save") : qsTr("Edit")
                    onClicked:
                    {
                        editionMode = !editionMode;
                        if (!editionMode)
                        {
                            // when click on save : update model
                            updateModelFromView();
                        }
                    }
                    ToolTip.text: editionMode ? qsTr("Save analysis information") : qsTr("Edit analysis information")
                    ToolTip.visible: hovered
                }

                Button
                {
                    visible: editionMode
                    text: qsTr("Cancel")
                    onClicked: { updateView1FromModel(model); editionMode = false; }
                }
            }

            RowLayout
            {
                Item
                {
                    Layout.minimumWidth: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.normal
                }

                Text
                {
                    text: qsTr("Indicator")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }
            }
            Rectangle
            {
                Layout.fillWidth: true
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
                border.width: editionMode ? 1 : 0
                border.color: Regovar.theme.boxColor.border
                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    text: qsTr("Not yet implemented")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.disable
                    verticalAlignment: Text.AlignVCenter
                }
            }

            RowLayout
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Item
                {
                    Layout.minimumWidth: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.normal
                }

                Text
                {
                    text: qsTr("Comment")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }
            }
            TextArea
            {
                id: commentField
                Layout.fillWidth: true
                enabled: editionMode
                height: 3 * Regovar.theme.font.size.normal
                onTextChanged: if (model) model.comment = text
                colorTextDisable: Regovar.theme.frontColor.normal
            }

/*

            // CONFIG ========================================================
            Row
            {
                height: Regovar.theme.font.boxSize.header

                Text
                {
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header
                    text: "d"

                    font.family: Regovar.theme.icons.name
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header

                    elide: Text.ElideRight
                    text: qsTr("Configuration")
                    font.bold: true
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
            }
            Item
            {
                width: 10; height: 10
            }

            RowLayout
            {
                Item
                {
                    Layout.minimumWidth: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.normal
                }

                Text
                {
                    text: qsTr("Pipeline")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }
            }
            Row
            {
                spacing: 10

                Text
                {
                    id: pipelineField
                    height: Regovar.theme.font.size.header
                    text: "Unknow pipeline"
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                }

                ButtonInline
                {
                    id: pipelineDetailsButton
                    iconTxt: "z"
                    text: ""
                    onClicked: regovar.getPipelineInfo(root.model.pipeline.id)
                    ToolTip.text: qsTr("Pipeline details")
                    ToolTip.visible: hovered
                }
            }

            RowLayout
            {
                Layout.alignment: Qt.AlignTop
                Item
                {
                    Layout.minimumWidth: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.normal
                }

                Text
                {
                    text: qsTr("Parameters")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }
            }
            TableView
            {
                id: configTable
                Layout.fillWidth: true

                TableViewColumn
                {
                    role: "key"
                    title: qsTr("Parameter")
                }
                TableViewColumn
                {
                    role: "value"
                    title: qsTr("Value")
                }
            }

            RowLayout
            {
                Layout.alignment: Qt.AlignTop
                Item
                {
                    Layout.minimumWidth: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.normal
                }

                Text
                {
                    text: qsTr("Files")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }
            }
            RowLayout
            {
                Layout.fillWidth: true
                height: 10 + 5 * Regovar.theme.font.boxSize.normal
                spacing: 10

                ColumnLayout
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text
                    {
                        Layout.fillWidth: true
                        text: qsTr("Inputs")
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.family
                        verticalAlignment: Text.AlignVCenter
                        height: Regovar.theme.font.boxSize.normal
                    }
                    Rectangle
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Regovar.theme.boxColor.back
                        border.width: 1
                        border.color: Regovar.theme.boxColor.border
                        radius: 2
                        ListView
                        {
                            id: inputsTable
                            anchors.fill: parent
                            anchors.margins: 5
                            clip: true
                            flickableDirection: Flickable.VerticalFlick
                            boundsBehavior: Flickable.StopAtBounds
                            ScrollBar.vertical: ScrollBar {}
                            model: regovar.eventsManager.lastEvents
                            delegate: SearchResultFile
                            {
                                width: parent.width - 10
                                indent: 0
                                fileId: model.id
                                date: model.date
                                icon: model.icon
                                filename: model.filename
                            }
                        }
                    }
                }
                ColumnLayout
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text
                    {
                        Layout.fillWidth: true
                        text: qsTr("Outputs")
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.family
                        verticalAlignment: Text.AlignVCenter
                        height: Regovar.theme.font.boxSize.normal
                    }
                    Rectangle
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Regovar.theme.boxColor.back
                        border.width: 1
                        border.color: Regovar.theme.boxColor.border
                        radius: 2
                        ListView
                        {
                            id: outputsTable
                            anchors.fill: parent
                            anchors.margins: 5
                            clip: true
                            flickableDirection: Flickable.VerticalFlick
                            boundsBehavior: Flickable.StopAtBounds
                            ScrollBar.vertical: ScrollBar {}
                            model: regovar.eventsManager.lastEvents
                            delegate: SearchResultFile
                            {
                                width: parent.width - 10
                                indent: 0
                                fileId: model.id
                                date: model.date
                                icon: model.icon
                                filename: model.filename
                            }
                        }
                    }
                }
            }


            // EVENTS ========================================================
            Row
            {
                height: Regovar.theme.font.boxSize.header

                Text
                {
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header
                    text: "H"

                    font.family: Regovar.theme.icons.name
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header

                    elide: Text.ElideRight
                    text: qsTr("Events")
                    font.bold: true
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
            }
            Item
            {
                Layout.columnSpan: 2
                width: 10; height: 10
            }


            Item
            {
                width: 10
                height: Regovar.theme.font.boxSize.normal
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Regovar.theme.boxColor.back
                border.width: 1
                border.color: Regovar.theme.boxColor.border
                radius: 2
                ListView
                {
                    id: eventsTable
                    anchors.fill: parent
                    anchors.margins: 5
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}
                    model: regovar.eventsManager.lastEvents
                    delegate: SearchResultEvent
                    {
                        width: parent.width - 10
                        indent: 0
                        eventId: model.id
                        date: model.date
                        //icon: model.icon
                        message: model.message
                    }
                }
            }
            Column
            {
                Layout.alignment: Qt.AlignTop
                spacing: 10


                Button
                {
                    id: addFile
                    text: qsTr("Add event")
                    enabled: false
                }

                Button
                {
                    id: editFile
                    text: qsTr("Edit event")
                    enabled: false
                }
            }

            */
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


    function updateView1FromModel(model)
    {
        headerTitle.text = model.name;
        nameField.text = model.name;
        commentField.text = model.comment;

    }

    function updateStatusFromModel()
    {
        closeAnalysisInformation.visible = root.model.status == "error" || root.model.status == "canceled";
        if (root.model.status == "error" )
        {
            closeAnalysisInformation.text = qsTr("An error occured during the execution of this analysis.")
        }
        else if (root.model.status == "canceled" )
        {
            closeAnalysisInformation.text = qsTr("This analysis have been canceled.")
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

            updateView1FromModel(root.model);
            updateStatusFromModel();

            // Pipeline
            pipelineDetailsButton.visible = false;
            var pipeline = qsTr("Unknow pipeline");
            if (root.model.type == "pipeline" && root.model.pipeline) // Analysis::PIPELINE
            {
                pipelineDetailsButton.visible = true;
                pipeline = root.model.pipeline.name + (root.model.pipeline.version ? " (" + root.model.pipeline.version + ")" : "");
            }
            pipelineField.text = pipeline;

            // Configuration
            var configList = [];
            if (root.model.config)
            {
                for (var key in root.model.config)
                {
                    configList.push({"key": key, "value": root.model.config[key]});
                }
            }
            //configTable.height = 5 * Regovar.theme.font.boxSize.normal;
            configTable.model = configList;

            // Files
            var fileList = [];
            if (root.model.inputsFiles)
            {
                for (var i=0; i<root.model.inputsFiles.rowCount(); i++)
                {
                    var file = root.model.inputsFiles.getAt(i);
                    fileList.push({"usage": qsTr("Input"), "filename": file.filenameUI});
                }
            }
            if (root.model.outputsFiles)
            {
                for (var i=0; i<root.model.outputsFiles.rowCount(); i++)
                {
                    var file = root.model.outputsFiles.getAt(i);
                    fileList.push({"usage": qsTr("Output"), "filename": {
                                          "id": file.id,
                                          "filename": file.filenameUI["filename"],
                                          "icon": file.filenameUI["icon"]}});
                }
            }
            //filesTable.height = 5 * Regovar.theme.font.boxSize.normal;
            filesTable.model = fileList;

            // Events
            eventsTable.model = root.model.events;
        }
    }


    function updateModelFromView()
    {
        if (model)
        {
            model.name = nameField.text;
            model.comment = commentField.text;

            model.save();
            headerTitle.text = model.name;
        }
    }
}



