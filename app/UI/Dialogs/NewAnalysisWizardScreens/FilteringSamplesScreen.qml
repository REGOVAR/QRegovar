import QtQuick 2.7
import QtQuick.Controls 2.2
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

    RowLayout
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10


        ColumnLayout
        {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Text
            {
                text: qsTr("Selected samples")
                font.pixelSize: Regovar.theme.font.size.control
                color: Regovar.theme.frontColor.normal
            }

            TableView
            {
                id: samplesList
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.newFilteringAnalysis.samples
                selectionMode: SelectionMode.ExtendedSelection
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


            CheckBox
            {
                Layout.fillWidth: true
                id: trioActivated
                text: "Trio"
                checked: false
                onCheckedChanged: checked = regovar.newFilteringAnalysis.samples.length == 3 && checked
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
                    textRole: 'name'
                    onCurrentIndexChanged:
                    {
                        if (currentIndex != regovar.selectedReference)
                        {
                            // Todo
                            checkReady();
                        }
                    }
                    delegate: ItemDelegate
                    {
                        width: childSample.width
                        height: Regovar.theme.font.boxSize.control
                        contentItem: Text
                        {
                            text: modelData.name
                            color: enabled ? Regovar.theme.boxColor.front : Regovar.theme.frontColor.disable
                            font: childSample.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: childSample.highlightedIndex === index
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
                    textRole: 'name'
                    Layout.fillWidth: true
                    onCurrentIndexChanged:
                    {
                        if (currentIndex != regovar.selectedReference)
                        {
                            // Todo
                            checkReady();
                        }
                    }
                    delegate: ItemDelegate
                    {
                        width: motherSample.width
                        height: Regovar.theme.font.boxSize.control
                        contentItem: Text
                        {
                            text: modelData.name
                            color: enabled ? Regovar.theme.boxColor.front : Regovar.theme.frontColor.disable
                            font: motherSample.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: motherSample.highlightedIndex === index
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
                    textRole: 'name'
                    Layout.fillWidth: true
                    onCurrentIndexChanged:
                    {
                        if (currentIndex != regovar.selectedReference)
                        {
                            // Todo
                            checkReady();
                        }
                    }
                    delegate: ItemDelegate
                    {
                        width: fatherSample.width
                        height: Regovar.theme.font.boxSize.control
                        contentItem: Text
                        {
                            text: modelData.name
                            color: enabled ? Regovar.theme.boxColor.front : Regovar.theme.frontColor.disable
                            font: fatherSample.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: fatherSample.highlightedIndex === index
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

        Column
        {
            id: actionColumn
            anchors.top: parent.top
            anchors.topMargin: header.height + 10
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
                onClicked: { sampleSelector.reset(); sampleSelector.open(); }
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
            }
            Button
            {
                id: remButton
                text: qsTr("Remove sample")
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
                onClicked:
                {
                    // Get list of objects to remove
                    var samples= []
                    samplesList.selection.forEach( function(rowIndex)
                    {
                        samples = samples.concat(regovar.newFilteringAnalysis.samples[rowIndex]);
                    });
                    regovar.newFilteringAnalysis.removeSamples(samples);
                    trioActivated.checked = regovar.newFilteringAnalysis.samples.length == 3;
                }
            }
        }
    }

    SelectSamplesDialog
    {
        id: sampleSelector
        onSamplesSelected:
        {
            regovar.newFilteringAnalysis.addSamples(samples);
            trioActivated.checked = regovar.newFilteringAnalysis.samples.length == 3;
            checkReady();
        }
    }
}
