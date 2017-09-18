import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true

    function checkReady()
    {
        readyForNext = true; // samplesList.count > 0;
    }

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
                property var statusIcons: ["m", "/", "n", "h"]

                TableViewColumn { title: qsTr("Sample"); role: "name" }
                TableViewColumn
                {
                    title: qsTr("Subject")
                    role: "subjectUI"
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
                            text: styleData.value.sex == "M" ? "9" : styleData.value.sex == "F" ? "<" : ""
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.lastname + " " + styleData.value.firstname + " (" + styleData.value.age + ")"
                            elide: Text.ElideRight
                        }

                    }
                }
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
                            font.pixelSize: Regovar.theme.font.size.control
                            text: samplesList.statusIcons[styleData.value.status]
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
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
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.fill: parent
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.filename
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn { title: qsTr("Comment"); role: "comment" }
            }

            Column
            {
                Layout.alignment: Qt.AlignTop
                spacing: 10
                Button
                {
                    id: addButton
                    text: qsTr("Add sample")
                    onClicked: { sampleSelector.reset(); sampleSelector.open(); }
                }
                Button
                {
                    id: remButton
                    text: qsTr("Remove sample")
                    onClicked:
                    {
                        // Get list of objects to remove
                        var samples= []
                        samplesList.selection.forEach( function(rowIndex)
                        {
                            samples = samples.concat(regovar.remoteSamplesList[rowIndex]);
                        });
                        regovar.newFilteringAnalysis.removeSamples(samples);
                    }
                }
            }
        }
        RowLayout
        {
            spacing: 10
            Layout.fillWidth: true
            CheckBox
            {
                id: trioActivated
                text: "Trio"
                checked: false
            }

        }
        GridLayout
        {
            Layout.fillWidth: true
            rowSpacing: 5
            columnSpacing: 5

            rows:3
            columns: 5

            Text { text: "Child"; enabled: trioActivated.checked }
            ComboBox
            {
                id: childSample
                model: regovar.newFilteringAnalysis.samples
                Layout.fillWidth: true
                enabled: trioActivated.checked
                delegate: Text
                {
                    text: modelData.name
                }
            }
            CheckBox
            {
                id: childIndex
                enabled: trioActivated.checked
                checked: false
                text: "Index"
            }
            Text { text: "Sex"; enabled: trioActivated.checked }
            ComboBox
            {
                id: childSex
                enabled: trioActivated.checked
                model: ["Male", "Female"]
            }

            Text { text: "Mother"; enabled: trioActivated.checked }
            ComboBox
            {
                id: motherSample
                enabled: trioActivated.checked
                model: regovar.newFilteringAnalysis.samples
                Layout.fillWidth: true
                delegate: Text
                {
                    text: modelData.name
                }
            }
            CheckBox
            {
                id: motherdIndex
                enabled: trioActivated.checked
                text: "Index"
                checked: true
            }
            Text { text: ""; Layout.columnSpan: 2 }

            Text { text: "Father"; enabled: trioActivated.checked }
            ComboBox
            {
                id: fatherSample
                enabled: trioActivated.checked
                model: regovar.newFilteringAnalysis.samples
                Layout.fillWidth: true
                delegate: Text
                {
                    text: modelData.name
                }
            }
            CheckBox
            {
                id: fatherIndex
                enabled: trioActivated.checked
                text: "Index"
            }
            Text { text: ""; Layout.columnSpan: 2 }
        }

    }

    SelectSamplesDialog
    {
        id: sampleSelector
        onSamplesSelected:
        {
            regovar.newFilteringAnalysis.addSamples(samples);
            checkReady();
        }
    }
}
