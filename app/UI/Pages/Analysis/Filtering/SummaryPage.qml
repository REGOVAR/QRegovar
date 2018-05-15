import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0
import QtQuick.Dialogs 1.2
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "../../Browse"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    property bool editionMode: false

    property real column1Width: 50
    function updateColumn1Width(newWidth)
    {
        column1Width = Math.max(newWidth + 20, column1Width);
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

        Text
        {
            id: headerTitle
            anchors.fill: header
            anchors.margins: 10
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
        Box
        {
            id: helpInfoBox
            Layout.fillWidth: true
            Layout.columnSpan: 2
            visible: Regovar.helpInfoBoxDisplayed
            icon: "k"
            text: qsTr("This page give you an overview of the analysis. Editable information, original configuration and list of all events regarding the analysis are displayed on this page.")
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
        Button
        {
            Layout.alignment: Qt.AlignTop
            id: statusButton
            text: ""
            onClicked: computingProgressLog.visible = true
            ToolTip.text: qsTr("Display details")
            ToolTip.visible: hovered
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
                text: qsTr("Type")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: Regovar.theme.font.boxSize.normal
            }
        }
        Text
        {
            id: typeField
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            text: "Filtering Trio"
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
        }
        Item
        {
            Layout.rowSpan: 4
            width: 10;height: 10
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
                text: qsTr("Referencial")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: Regovar.theme.font.boxSize.normal
            }
        }
        Text
        {
            id: refField
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
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
                text: qsTr("Annotations DB")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: Regovar.theme.font.boxSize.normal
            }
        }
        Text
        {
            id: annotationsField
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
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
                text: qsTr("Samples")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: Regovar.theme.font.boxSize.normal
            }
        }
        TableView
        {
            id: samplesTable
            Layout.fillWidth: true
            height: 50

            // Generic Column component use to display new one when user select a new annotation
            Component
            {
                id: columnComponent
                TableViewColumn { width: 100 }
            }

            TableViewColumn
            {
                role: "sample"
                title: "Sample"
                width: 150

                delegate: RowLayout
                {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    spacing: 10

                    ButtonInline
                    {
                        iconTxt: "z"
                        text: ""
                        onClicked: regovar.getSampleInfo(styleData.value.id)
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.family
                        color: Regovar.theme.frontColor.normal
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        text: styleData.value.name
                    }
                }
            }
            TableViewColumn
            {
                role: "subject"
                title: "Subject"
                width: 300

                delegate: RowLayout
                {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    spacing: 10

                    ButtonInline
                    {
                        iconTxt: "z"
                        text: ""
                        onClicked: regovar.subjectsManager.openSubject(styleData.value.id)
                        visible: styleData.value
                    }

                    Text
                    {
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.frontColor.normal
                        verticalAlignment: Text.AlignVCenter
                        text: styleData.value ? Regovar.sexToIcon(styleData.value.sex) : ""
                        visible: styleData.value
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.family
                        color: Regovar.theme.frontColor.normal
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        text: styleData.value ? styleData.value.name : ""
                        visible: styleData.value
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
                ToolTip.text: qsTr("Add a custom event to the project")
                ToolTip.visible: hovered
            }

            Button
            {
                id: editFile
                text: qsTr("Edit event")
                enabled: false
                ToolTip.text: qsTr("Edit the selected event")
                ToolTip.visible: hovered
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


    Dialog
    {
        id: computingProgressLog
        title: qsTr("Status details")
        visible: false

        contentItem: Rectangle
        {
            implicitWidth: 400
            implicitHeight: 500
            color: Regovar.theme.backgroundColor.main

            ColumnLayout
            {
                anchors.fill: parent
                anchors.margins: 10


                Text
                {
                    Layout.fillWidth: true
                    height: Regovar.theme.font.boxSize.header
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                    text: qsTr("Computing steps:")
                }

                Rectangle
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    color: Regovar.theme.boxColor.back
                    border.width: 1
                    border.color: Regovar.theme.boxColor.border

                    ListView
                    {
                        id: statusLogsList
                        anchors.fill: parent
                        anchors.margins: 1
                        anchors.leftMargin: 10
                        clip: true
                        model: ListModel { id: statusLogs}

                        delegate:Rectangle
                        {
                            height: Regovar.theme.font.boxSize.header
                            width: parent.width - 15

                            RowLayout
                            {
                                anchors.fill: parent
                                spacing: 10

                                Text
                                {
                                    Layout.fillHeight: true
                                    width: Regovar.theme.font.boxSize.normal
                                    color: Regovar.theme.frontColor.normal
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    font.family: Regovar.theme.icons.name
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    text: regovar.analysisStatusIcon(status)
                                    onTextChanged:
                                    {
                                        if (regovar.analysisStatusIconAnimated(status))
                                        {
                                            stepIconAnimation.start();
                                        }
                                        else
                                        {
                                            stepIconAnimation.stop();
                                            rotation = 0;
                                        }
                                    }

                                    NumberAnimation on rotation
                                    {
                                        id: stepIconAnimation
                                        duration: 1500
                                        loops: Animation.Infinite
                                        from: 0
                                        to: 360
                                    }
                                }
                                Text
                                {
                                    Layout.fillHeight: true
                                    width: Regovar.theme.font.boxSize.normal
                                    color: Regovar.theme.frontColor.normal
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    font.family: Regovar.theme.font.family
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignRight
                                    text: index + " -"
                                }
                                Text
                                {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    color: Regovar.theme.frontColor.normal
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    font.family: Regovar.theme.font.family
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                    elide: Text.ElideRight
                                    text: label
                                }
                                ProgressBar
                                {
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 130
                                    value: progress
                                }
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: computingMessage
                    Layout.minimumHeight: 100
                    Layout.fillWidth: true

                    color: Regovar.theme.boxColor.back
                    border.width: 1
                    border.color: Regovar.theme.boxColor.border

                    TextEdit
                    {
                        id: computingMessageText
                        anchors.fill: parent
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: "WordWrap"
                        readOnly: true
                        selectByMouse: true
                        selectByKeyboard: true
                    }
                }

            }
        }
    }




    function updateView1FromModel(model)
    {
        headerTitle.text = model.name;
        nameField.text = model.name;
        commentField.text = model.comment;

    }

    property var statusTextMap: ({"ready": qsTr("Ready"), "error": qsTr("Error"), "computing": qsTr("Computing database"), "waiting": qsTr("Waiting samples import"), "empty": qsTr("Initializing"), "close": qsTr("Closed")})
    function updateStatusFromModel()
    {
        var globalProgress = 0;
        // update logs
        statusLogs.clear();
        statusButton.text = qsTr("Details")
        statusButton.ToolTip.text = qsTr("Display data processing progress details")
        statusButton.colorMain = Regovar.theme.secondaryColor.back.normal;
        statusButton.colorHover = Regovar.theme.secondaryColor.back.light;
        statusButton.colorDown = Regovar.theme.secondaryColor.back.dark;
        var data = root.model.computingProgress.log;
        for (var idx in data)
        {
            statusLogs.append(data[idx]);
            globalProgress += data[idx]["progress"];
        }

        // Update message
        var status = root.model.status;
        var statusIcon = regovar.analysisStatusIcon(status);
        var statusLabel = regovar.analysisStatusLabel(status);
        var statusText = "";
        var statusColor = Regovar.theme.frontColor.success;


        if (status == "error")
        {
            statusColor = Regovar.theme.frontColor.danger;
            statusText = ". " + root.model.computingProgress.error_message;
        }
        else if (status == "empty" || status == "close")
        {
            statusColor = Regovar.theme.frontColor.warning;
            statusText = ". " + qsTr("This analysis is closed. To be able to use dynamic filtering features you have to (re)open it with the opposite button.\nReopenning the analysis may take long time as we need to recompute some data.");
            statusButton.text = qsTr("Open it");
            statusButton.ToolTip.text = qsTr("Open or reopen the analysis to use dynamic filtering.")
            statusButton.colorMain = Regovar.theme.frontColor.danger;
            statusButton.colorHover = Regovar.theme.lighter(Regovar.theme.frontColor.danger);
            statusButton.colorDown = Regovar.theme.darker(Regovar.theme.frontColor.danger);
        }
        else if (root.model.status == "ready")
        {
            statusText = ". " + qsTr("Data are ready to be analysed");
        }
        else
        {
            statusText = " (" + (globalProgress/root.model.computingProgress.log.length*100).toFixed(1) + "%)";
            statusText += ". " + qsTr("We are processing variant's data for your analysis. It might take some time...");
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

            updateView1FromModel(root.model);
            updateStatusFromModel();
            refField.text = root.model.refName;

            // Type
            var type = qsTr("Unknow");
            if (root.model.type == "analysis") // Analysis::FILTERING
            {
                type = qsTr("Variants filtering");
                if (root.model.isTrio)
                {
                    type += " (" + qsTr("trio analysis") + ")";
                }
                else if (root.model.samples.length == 1)
                {
                    type += " (" + qsTr("singleton analysis") + ")";
                }
                else
                {
                    type += " (" + qsTr("custom analysis") + ")";
                }
            }
            typeField.text = type;

            // Annotations
            var annotations = "";
            for (var idx in root.model.selectedAnnotationsDB)
            {
                annotations += root.model.selectedAnnotationsDB[idx] + ", ";
            }

            annotationsField.text = annotations.substring(0, annotations.length-2);

            // Samples
            // Add columns
            var colCount = 2;
            if (root.model.isTrio)
            {
                insertColumn("trio", qsTr("Trio"), 0);
                colCount += 1;
            }
            for (idx in root.model.attributes)
            {
                insertColumn("attr_" + idx, model.attributes[idx].name, colCount);
                colCount += 1;
            }

            // Create table model
            var samplesModel = [];
            samplesTable.height = Math.min(root.model.samples.length, 5) * Regovar.theme.font.boxSize.normal;
            for (idx in root.model.samples)
            {
                var sample = root.model.samples[idx];
                var item = {
                    "sample": {"id": sample.id, "name": sample.name},
                    "subject": sample.subject ? sample.subject.subjectUI : false,
                };
                if (root.model.isTrio)
                {
                    if (root.model.child === sample)
                    {
                        item["trio"] = qsTr("Child");
                    }
                    else if (root.model.mother === sample)
                    {
                        item["trio"] = qsTr("Mother");
                    }
                    else
                    {
                        item["trio"] = qsTr("Father");
                    }
                }
                for (idx in root.model.attributes)
                {
                    item["attr_" + idx] = root.model.attributes[idx].getValue(sample.id);
                }
                samplesModel.push(item);
            }

            samplesTable.model = samplesModel;

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


    function insertColumn(role, title, position)
    {
        var col = columnComponent.createObject(samplesTable, {"role": role, "title": title, "width": 100});
        samplesTable.insertColumn(position, col);
    }
}



