import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0
import QtQuick.Dialogs 1.2

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"
import "qrc:/qml/Pages/Browser/Items"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property PipelineAnalysis model
    property bool editionMode: false
    property bool isRunning: false
    property bool isResumable: false
    property bool isClosed: false

    property real column1Width: 50
    property real column3Width: 50
    function updateColumn1Width(newWidth)
    {
        column1Width = Math.max(newWidth + 20, column1Width);
    }
    function updateColumn3Width(newWidth)
    {
        column3Width = Math.max(newWidth + 20, column3Width);
    }

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
        width: root.column1Width
        color: Regovar.theme.backgroundColor.alt
    }

    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        anchors.bottom: root.bottom
        columns: 3
        columnSpacing: 20
        rowSpacing: 10


        // HELP ========================================================
        Item
        {
            width: 10; height: 10
            visible: Regovar.helpInfoBoxDisplayed
        }
        // Help information on this page
        Box
        {
            id: helpInfoBox
            Layout.fillWidth: true
            Layout.columnSpan: 2
            visible: Regovar.helpInfoBoxDisplayed
            icon: "k"
            text: qsTr("This page give you an overview of the analysis.")
        }

        // STATUS ========================================================
        Item
        {
            width: root.column1Width - 20; height: 10
        }
        Box
        {
            id: statusBox
            Layout.fillWidth: true
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


        // INFO ========================================================
        Rectangle
        {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            color: Regovar.theme.backgroundColor.alt

            Row
            {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                onWidthChanged: updateColumn1Width(width)
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
        }

        RowLayout
        {
            onWidthChanged: updateColumn1Width(width)
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
            Layout.rowSpan: 3
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

        // TODO: Pipeline indicator
//        RowLayout
//        {
//            onWidthChanged: updateColumn1Width(width)
//            Item
//            {
//                Layout.minimumWidth: Regovar.theme.font.boxSize.header
//                height: Regovar.theme.font.boxSize.normal
//            }

//            Text
//            {
//                text: qsTr("Indicator")
//                color: Regovar.theme.primaryColor.back.dark
//                font.pixelSize: Regovar.theme.font.size.normal
//                font.family: Regovar.theme.font.family
//                verticalAlignment: Text.AlignVCenter
//                height: Regovar.theme.font.boxSize.normal
//            }
//        }
//        Rectangle
//        {
//            Layout.fillWidth: true
//            height: Regovar.theme.font.boxSize.normal
//            color: "transparent"
//            border.width: editionMode ? 1 : 0
//            border.color: Regovar.theme.boxColor.border
//            Text
//            {
//                anchors.fill: parent
//                anchors.leftMargin: 5
//                text: qsTr("Not yet implemented")
//                font.pixelSize: Regovar.theme.font.size.normal
//                color: Regovar.theme.frontColor.disable
//                verticalAlignment: Text.AlignVCenter
//            }
//        }

        RowLayout
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            onWidthChanged: updateColumn1Width(width)
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


        // CONFIG ========================================================
        Rectangle
        {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            color: Regovar.theme.backgroundColor.alt

            Row
            {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                onWidthChanged: updateColumn1Width(width)

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
        }

        RowLayout
        {
            onWidthChanged: updateColumn1Width(width)
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
        Item
        {
            Layout.rowSpan: 3
            width: 10;height: 10
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignTop
            onWidthChanged: updateColumn1Width(width)
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
        Rectangle
        {
            id: configParametersFrame
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            radius: 2
            property real colParamWidth: 50
            ListView
            {
                id: configTable
                anchors.fill: parent
                anchors.margins: 5
                clip: true
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar {}
                delegate: Row
                {
                    spacing: 10
                    width: parent.width - 10
                    Text
                    {
                        onContentWidthChanged: configParametersFrame.colParamWidth = Math.max(contentWidth, configParametersFrame.colParamWidth)
                        width: configParametersFrame.colParamWidth
                        font.pixelSize: Regovar.theme.font.size.normal
                        verticalAlignment: Text.AlignVCenter
                        text: modelData.key + " :"
                    }
                    Text
                    {
                        font.pixelSize: Regovar.theme.font.size.normal
                        verticalAlignment: Text.AlignVCenter
                        text: modelData.value
                    }
                }
            }
        }
        Text
        {
            id: configParametersNone
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
            text: qsTr("No custom config for this pipeline.")
            color: Regovar.theme.frontColor.disable
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignTop
            onWidthChanged: updateColumn1Width(width)
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
                        delegate: BrowserItemFile
                        {
                            width: parent.width - 10
                            indent: 0
                            fileId: model.id
                            icon: model.name.icon
                            filename: model.name.filename
                            onClicked: regovar.getFileInfo(fileId)
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
                        delegate: BrowserItemFile
                        {
                            width: parent.width - 10
                            indent: 0
                            fileId: model.id
                            icon: model.name.icon
                            filename: model.name.filename
                            onClicked: regovar.getFileInfo(fileId)
                        }
                    }
                }
            }
        }


        // EVENTS ========================================================
        Rectangle
        {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            color: Regovar.theme.backgroundColor.alt

            Row
            {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                onWidthChanged: updateColumn1Width(width)
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
                delegate: BrowserItemEvent
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
        // Update message
        var status = root.model.status;
        var statusIcon = regovar.analysisStatusIcon(status);
        var statusLabel = regovar.analysisStatusLabel(status);
        var statusText = "";
        var statusColor = Regovar.theme.frontColor.success;

        root.isRunning = status == "running";
        root.isClosed = status == "done" ||  status == "canceled"  ||  status == "error" ;
        root.isResumable = status == "running" || status == "pause";

        if (status == "error" )
        {
            statusText = qsTr("An error occured during the execution of this analysis.")
            statusColor = Regovar.theme.frontColor.danger;
        }
        else if (status == "canceled" )
        {
            statusText = qsTr("This analysis have been canceled.")
            statusColor = Regovar.theme.frontColor.danger;
        }
        else if (status == "pause" )
        {
            statusText = qsTr("This analysis is paused. Click on opposite \"play\" button to resume the task.")
            statusColor = Regovar.theme.frontColor.warning;
        }

        if (root.model.progressValue > 0 && status != "done")
        {
            statusText += "\nProgress: " (root.model.progressValue*100).toFixed(1) + "% " + root.model.progressLabel;
        }

        // update view
        statusBox.icon = statusIcon;
        statusBox.text = statusLabel + statusText;
        statusBox.mainColor = statusColor;
        statusBox.iconAnimation = regovar.analysisStatusIconAnimated(status);

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

            if (configList.length > 0)
            {
                configTable.model = configList;
                configParametersNone.visible = false;
            }
            else
            {
                configParametersFrame.visible = false;
            }

            // Files
            inputsTable.model = root.model.inputsFiles;
            outputsTable.model = root.model.outputsFiles;

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



