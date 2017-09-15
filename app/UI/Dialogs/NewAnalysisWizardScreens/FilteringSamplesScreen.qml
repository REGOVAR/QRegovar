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

                // model: regovar.newFilteringAnalysis.samples

                model: ListModel
                {
                    ListElement {
                        nameUI: "Hp-4456223"
                        subjectUI: "Michel DUPONT"
                        statusUI: "Ready"
                        sourceUI: "trio-dm-00.vcf"
                        comment: ""
                    }
                    ListElement {
                        nameUI: "Hp-4177789"
                        subjectUI: "Micheline DUPONT"
                        statusUI: "Ready"
                        sourceUI: "trio-dm-00.vcf"
                        comment: ""
                    }
                    ListElement {
                        nameUI: "Hp-4177789"
                        subjectUI: ""
                        statusUI: "Loading (63%)"
                        sourceUI: "trio-dm-01.vcf"
                        comment: ""
                    }
                }


                TableViewColumn
                {
                    title: qsTr("Sample")
                    role: "nameUI"
                    delegate: Item
                    {
                        TextField
                        {
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            text: model.nickname // styleData.value
                            placeholderText: model.nameUI
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Subject")
                    role: "subjectUI"
                }
                TableViewColumn
                {
                    title: qsTr("Status")
                    role: "statusUI"
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
                   // onClicked: { regovar.loadSampleBrowser(2); sampleSelector.open(); }
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

//    SelectSamplesDialog
//    {
//        id: sampleSelector
//        currentAnalysis: regovar.newFilteringAnalysis
//        //onSampleSelected: { regovar.newPipelineAnalysis.addInputs(files); checkReady(); }
//    }
}
