import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    property bool editionMode: false

    onModelChanged: updateViewFromModel()



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
        text: qsTr("This page give you an overview of the analysis.")
    }


    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        rows: 11
        columns: 3
        columnSpacing: 10
        rowSpacing: 10


        Text
        {
            text: qsTr("Name*")
            font.bold: true
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
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
            Layout.rowSpan: 10
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
            }

            Button
            {
                visible: editionMode
                text: qsTr("Cancel")
                onClicked: { updateView1FromModel(model); editionMode = false; }
            }
        }

        Text
        {
            text: qsTr("Indicator")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.normal
            color: "transparent"
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            Text
            {
                anchors.centerIn: parent
                text: qsTr("Not yet implemented")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.disable
                verticalAlignment: Text.AlignVCenter
            }
        }

        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Comment")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextArea
        {
            id: commentField
            Layout.fillWidth: true
            enabled: editionMode
            height: 3 * Regovar.theme.font.size.normal
            onTextChanged: if (model) model.comment = text
        }





        Rectangle
        {
            Layout.columnSpan: 2
            height: 1
            color: Regovar.theme.primaryColor.back.dark
            Layout.fillWidth: true
        }



        Text
        {
            text: qsTr("Status")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Row
        {
            spacing: 10
            Text
            {
                id: statusIcon
                Layout.fillWidth: true
                height: Regovar.theme.font.size.header
                color: Regovar.theme.frontColor.normal
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.icons.name
                verticalAlignment: Text.AlignVCenter
                text: "n"
                NumberAnimation on rotation
                {
                    id: statusIconAnimation
                    duration: 1000
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
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
            }

            ButtonInline
            {
                icon: "Y"
                text: ""
                ToolTip.text: qsTr("Display details")
                ToolTip.visible: hovered
            }
        }

        Text
        {
            text: qsTr("Type")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: typeField
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            text: "Filtering Trio"
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
        }


        Text
        {
            text: qsTr("Referencial")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: refField
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
        }

        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Annotations DB")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: annotationsField
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
        }


        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Samples")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
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
                        icon: "z"
                        text: ""
                        onClicked: regovar.getSampleInfo(styleData.value.id)
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
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
                        icon: "z"
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
                        text: styleData.value ? (styleData.value.sex == "male" ? "9" : styleData.value.sex == "female" ? "<" : "b") : ""
                        visible: styleData.value
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
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


        Rectangle
        {
            Layout.columnSpan: 2
            height: 1
            color: Regovar.theme.primaryColor.back.dark
            Layout.fillWidth: true
        }


        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Events")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TableView
        {
            id: eventsTable
            Layout.fillWidth: true
            Layout.fillHeight: true


            TableViewColumn
            {
                title: "Date"
                role: "data"
            }
            TableViewColumn
            {
                title: "Event"
                role: "filenameUI"
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
            }

            Button
            {
                id: editFile
                text: qsTr("Edit event")
            }
        }

    }

    Rectangle
    {
        id: busyIndicator
        anchors.fill: parent

        color: Regovar.theme.backgroundColor.overlay
        visible: root.model ? root.model.loaded : false

        MouseArea
        {
            anchors.fill: parent
        }

        BusyIndicator
        {
            anchors.centerIn: parent
        }
    }

    function updateView1FromModel(model)
    {
        headerTitle.text = model.name;
        nameField.text = model.name;
        commentField.text = model.comment;
    }

    property var statusIconMap: ({"ready": "n", "error": "l", "computing": "/", "waiting": "m", "empty": "g"})
    property var statusTextMap: ({"ready": qsTr("Ready"), "error": qsTr("Error"), "computing": qsTr("Computing database"), "waiting": qsTr("Waiting samples import"), "empty": qsTr("Closed")})
    function updateStatusFromModel()
    {
        // update status
        statusField.text = root.statusTextMap[root.model.status];
        statusIcon.text = root.statusIconMap[root.model.status];
        if (root.model.status == "computing")
        {
            statusIconAnimation.start();
        }
        else
        {
            statusIconAnimation.stop();
            rotation = 0;
        }

        // update logs
    }

    function updateViewFromModel()
    {
        if (root.model)
        {
            if (!root.model.loaded)
            {
                root.model.dataChanged.connect(updateViewFromModel);
            }
            else
            {
                root.model.dataChanged.disconnect(updateViewFromModel);
                root.model.statusChanged.connect(updateStatusFromModel);
            }

            updateView1FromModel(root.model);
            updateStatusFromModel();
            //creationDate.text = Regovar.formatShortDate(root.model.createDate);
            refField.text = root.model.refName;

            // Type
            var type = qsTr("Unknow");
            if (root.model.type == "Filtering")
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

            // Events ...
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



