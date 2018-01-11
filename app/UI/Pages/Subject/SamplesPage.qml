import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.regovar 1.0
import "../../Regovar"
import "../../Framework"
import "../../Dialogs"

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

        RowLayout
        {
            anchors.fill: parent
            anchors.margins: 10

            Text
            {
                id: nameLabel
                Layout.fillWidth: true

                font.pixelSize: 22
                font.family: Regovar.theme.font.familly
                color: Regovar.theme.frontColor.normal
                verticalAlignment: Text.AlignVCenter
                text: model ? model.identifier + " : " + model.lastname.toUpperCase() + " " + model.firstname : "-"
                elide: Text.ElideRight
            }

            ConnectionStatus { }
        }
    }

    RowLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10


        TableView
        {
            id: tableView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model ? root.model.samples : []
            selectionMode: SelectionMode.ExtendedSelection


            property var statusIcons: ["m", "/", "n", "h"]

            TableViewColumn
            {
                title: qsTr("Reference")
                role: "reference"

                delegate: Item
                {

                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: styleData.textAlignment
                        font.pixelSize: Regovar.theme.font.size.normal
                        text: styleData.value.name
                    }
                }
            }
            TableViewColumn { title: qsTr("Sample"); role: "name"; horizontalAlignment: Text.AlignLeft; }
            TableViewColumn
            {
                title: "Status"
                role: "statusUI"
                delegate: Item
                {

                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: styleData.textAlignment
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.icons.name
                        text: tableView.statusIcons[styleData.value.status]
                        onTextChanged:
                        {
                            if (styleData.value.status == 1) // 1 = Loading
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
                            duration: 1000
                            loops: Animation.Infinite
                            from: 0
                            to: 360
                        }
                    }
                    Text
                    {
                        anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                        anchors.rightMargin: 5
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: styleData.textAlignment
                        font.pixelSize: Regovar.theme.font.size.normal
                        text: styleData.value.label
                        elide: Text.ElideRight
                    }
                }
            }

            TableViewColumn
            {
                title: qsTr("Source")
                role: "sourceUI"
                delegate: Item
                {
                    Text
                    {
                        id: sourceIcon
                        anchors.leftMargin: 5
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: styleData.textAlignment
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.icons.name
                        text: styleData.value.icon
                    }
                    Text
                    {
                        id: sourceLabel
                        anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                        anchors.rightMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: styleData.textAlignment
                        font.pixelSize: Regovar.theme.font.size.normal
                        elide: Text.ElideRight
                        text: styleData.value.filename
                    }
                }
            }
            TableViewColumn { title: qsTr("Comment"); role: "comment" }

            Rectangle
            {
                id: helpPanel
                anchors.fill: parent

                color: Regovar.theme.backgroundColor.overlay

                visible: root.model ? root.model.samples.length == 0 : true

                Text
                {
                    text: qsTr("No sample associated to this subject.\nClick on the opposite button to add it.")
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.normal
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
            }
        }


        Column
        {
            id: actionColumn
            Layout.alignment: Qt.AlignTop
            spacing: 10

            property real maxWidth: 0
            onMaxWidthChanged:
            {
                addButton.width = maxWidth;
                remButton.width = maxWidth;
            }

            Button
            {
                id: addButton
                text: qsTr("Add sample")
                onClicked:
                {
                    sampleSelector.referencialSelectorEnabled = true;
                    sampleSelector.reset();
                    sampleSelector.open();
                }
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
            }
            Button
            {
                id: editButton
                text: qsTr("Open sample")
                onClicked: regovar.getSampleInfo(root.model.samples[tableView.currentRow].id)
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
            }
            Button
            {
                id: remButton
                text: qsTr("Remove sample")
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
                onClicked:
                {
                    tableView.selection.forEach( function(rowIndex)
                    {
                        root.model.removeSample(root.model.samples[rowIndex]);
                    });
                }
            }
        }
    }

    SelectSamplesDialog
    {
        id: sampleSelector
        onSamplesSelected:
        {
            for (var idx=0; idx<samples.length; idx++)
            {
                root.model.addSample(samples[idx]);
            }
        }
    }
}
