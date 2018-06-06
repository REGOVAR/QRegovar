import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model
    onModelChanged:
    {
        if(model)
        {
            model.dataChanged.connect(updateViewFromModel);
        }
        updateViewFromModel();
    }
    Component.onDestruction:
    {
        model.dataChanged.disconnect(updateViewFromModel);
    }

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
                font.pixelSize: Regovar.theme.font.size.title
                font.weight: Font.Black
                color: Regovar.theme.primaryColor.back.dark
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            ConnectionStatus { }
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
        text: qsTr("This page list all samples of the subject.")
    }

    RowLayout
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10


        TableView
        {
            id: tableView
            Layout.fillWidth: true
            Layout.fillHeight: true
            onDoubleClicked: regovar.getSampleInfo(currentSample().id)
            property var statusIcons: ["m", "/", "n", "h"]

            TableViewColumn
            {
                title: qsTr("Reference")
                role: "reference"
            }
            TableViewColumn
            {
                title: qsTr("Sample");
                role: "name";
            }
            TableViewColumn
            {
                title: "Status"
                role: "status"
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
                            duration: 1500
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
                role: "source"
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
                        text: styleData.value ? styleData.value.icon : ""
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
                        text: styleData.value ? styleData.value.filename : "?"
                    }
                }
            }
            TableViewColumn
            {
                title: qsTr("Comment");
                role: "comment"
            }

            Rectangle
            {
                id: emptyPanel
                anchors.fill: parent
                color: Regovar.theme.backgroundColor.overlay

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
                onClicked: regovar.getSampleInfo(currentSample().id)
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
            }
            Button
            {
                id: remButton
                text: qsTr("Remove sample")
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
                onClicked: root.model.removeSample(currentSample())
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

    function updateViewFromModel()
    {
        if (root.model)
        {
            nameLabel.text = root.model.identifier + " : " + root.model.lastname.toUpperCase() + " " + root.model.firstname;
            tableView.model = root.model.samples.proxy;
            emptyPanel.visible = root.model.samples.length > 0;
        }
    }

    function currentSample()
    {
        var idx = root.model.samples.proxy.getModelIndex(tableView.currentRow);
        var id = root.model.samples.data(idx, 257); // 257 = Qt::UserRole+1
        return regovar.samplesManager.getOrCreateSample(id);
    }
}
