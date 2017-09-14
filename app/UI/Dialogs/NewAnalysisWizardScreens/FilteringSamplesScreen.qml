import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true // samplesList.count > 0

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text:  qsTr("Select the sample(s) you want to analyse.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.control
        color: Regovar.theme.primaryColor.back.normal
    }

    ColumnLayout
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10

        Text
        {
            text: qsTr("Selected samples")
            font.pixelSize: Regovar.theme.font.size.control
            color: Regovar.theme.frontColor.normal
        }
        RowLayout
        {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            TableView
            {
                id: samplesList
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.newFilteringAnalysis.samples


                Rectangle
                {
                    id: dropAreaFeedBack
                    anchors.fill: parent;
                    color: "#99ffffff"
                    visible: false
                    Text
                    {
                        anchors.centerIn: parent
                        text: qsTr("Drop your files here")
                    }
                }

                DropArea
                {
                    id: dropArea;
                    anchors.fill: parent;
                    onEntered:
                    {
                        if (drag.hasUrls)
                        {
                            dropAreaFeedBack.visible = true;
                            drag.accept (Qt.CopyAction);
                        }
                    }
                    onDropped:
                    {
                        var files= []
                        for(var i=0; i<drop.urls.length; i++)
                        {
                            files = files.concat(drop.urls[i]);
                        }
                        regovar.enqueueUploadFile(files);
                        dropAreaFeedBack.visible = false;
                    }
                    onExited: dropAreaFeedBack.visible = false;
                }

                TableViewColumn
                {
                    title: qsTr("Name")
                    role: "nameUI"
                    delegate: Item
                    {
                        TextField
                        {
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            text: styleData.value.nickname
                            placeholderText: styleData.value.name
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Subject")
                    role: "subjectUI"
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.firstname + " " + styleData.value.lastname
                            elide: Text.ElideRight
                        }

                    }
                }
                TableViewColumn
                {
                    title: qsTr("Status")
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
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.icon
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            verticalAlignment: Text.AlignVCenter
                            anchors.fill: parent
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.label
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn { title: "Source"; role: "sourceUI" }
                TableViewColumn { title: "Comment"; role: "comment" }
            }

            Column
            {
                Layout.alignment: Qt.AlignTop
                spacing: 10
                Button
                {
                    id: addButton
                    text: qsTr("Add sample")
                    onClicked: { regovar.loadSampleBrowser(2); sampleSelector.open(); }
                }
                Button
                {
                    id: remButton
                    text: qsTr("Remove sample")
                    onClicked: samplesList.model = null;
                }
            }
        }
    }

    SelectSamplesDialog
    {
        id: sampleSelector
        currentAnalysis: regovar.newFilteringAnalysis
        //onSampleSelected: { regovar.newPipelineAnalysis.addInputs(files); checkReady(); }
    }
}
