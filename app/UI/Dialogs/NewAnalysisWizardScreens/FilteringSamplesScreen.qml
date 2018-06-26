import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"


GenericScreen
{
    id: root

    readyForNext: true

    function checkReady()
    {
        // security if method is called before init of a component
        if (!trioActivated || !childSample || !motherSample || !fatherSample || !childIndex || !motherIndex || !fatherIndex || !childSex)
            return;

        readyForNext = false;

        if (regovar.analysesManager.newFiltering.samples.length > 0)
        {

            // Check for trio
            regovar.analysesManager.newFiltering.isTrio = trioActivated.checked;
            if (trioActivated.checked)
            {
                // assert that child/mother/father are distinct samples
                if (childSample.currentIndex  != motherSample.currentIndex &&
                    childSample.currentIndex  !=  fatherSample.currentIndex &&
                    motherSample.currentIndex != fatherSample.currentIndex)
                {
                    regovar.analysesManager.newFiltering.child = regovar.analysesManager.newFiltering.samples[childSample.currentIndex];
                    regovar.analysesManager.newFiltering.mother = regovar.analysesManager.newFiltering.samples[motherSample.currentIndex];
                    regovar.analysesManager.newFiltering.father = regovar.analysesManager.newFiltering.samples[fatherSample.currentIndex];

                    regovar.analysesManager.newFiltering.child.isIndex = childIndex.checked;
                    regovar.analysesManager.newFiltering.mother.isIndex = motherIndex.checked;
                    regovar.analysesManager.newFiltering.father.isIndex = fatherIndex.checked;

                    regovar.analysesManager.newFiltering.child.sex = childSex.currentIndex == 1 ? "F" : "M";

                    readyForNext = true;
                }
            }
            else
            {
                readyForNext = true;
            }
        }
    }



    onZChanged:
    {
        checkReady();
        if (z == 0)
        {
            // When sample screen disapear (occure on next/previous)
            // Refresh selected annotation by default according to the samples
            var idx;
            var annotDbUid=[];
            for(idx=0; idx<regovar.analysesManager.newFiltering.samples.length; idx++)
            {
                var sample = regovar.analysesManager.newFiltering.samples[idx];
                for(var j=0; j<sample.defaultAnnotationsDbUid.length; j++)
                {
                    var uid = sample.defaultAnnotationsDbUid[j];
                    if(annotDbUid.indexOf(uid) == -1)
                    {
                        annotDbUid = annotDbUid.concat(uid);
                    }
                }
            }

            for(idx=0; idx<regovar.analysesManager.newFiltering.allAnnotations.length; idx++)
            {
                var isDefault = annotDbUid.indexOf(regovar.analysesManager.newFiltering.allAnnotations[idx].uid) > -1;
                regovar.analysesManager.newFiltering.allAnnotations[idx].selected = idx < 2 || isDefault;
                regovar.analysesManager.newFiltering.allAnnotations[idx].isDefault = isDefault;
            }
        }
    }


    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("Select the sample(s) you want to analyse.")
    }

    RowLayout
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : parent.top
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? 10 : 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10


        ColumnLayout
        {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            // TODO: feature #142 in developpment
//            Rectangle
//            {
//                Layout.fillWidth: true
//                height: Regovar.theme.font.boxSize.normal + 5

//                color: Regovar.theme.boxColor.back
//                border.width: 1
//                border.color: Regovar.theme.boxColor.border

//                RowLayout
//                {
//                    anchors.left: parent.left
//                    anchors.right: parent.right
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.leftMargin: 5
//                    anchors.rightMargin: 5
//                    spacing: 5

//                    Text
//                    {
//                        Layout.fillWidth: true
//                        text: qsTr("Warning your files are still downloading.") + " (" + regovar.analysesManager.newFiltering.samplesInputsFilesList.length + ")"
//                        font.pixelSize: Regovar.theme.font.size.normal
//                        color: Regovar.theme.frontColor.normal
//                        elide: Text.ElideRight
//                    }

//                    ProgressBar
//                    {
//                        width: 150
//                        value: 0.3
//                    }
//                }
//            }



            TableView
            {
                id: samplesList
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.analysesManager.newFiltering.samples
                selectionMode: SelectionMode.ExtendedSelection
                property var statusIcons: ["m", "/", "n", "h"]

                TableViewColumn { title: qsTr("Sample"); role: "name" }
                TableViewColumn
                {
                    title: qsTr("Subject")
                    role: "subject"
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
                            text: styleData.value ? styleData.value.subjectUI.sex : ""
                            font.family: Regovar.theme.icons.name
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
                            text: styleData.value ? styleData.value.subjectUI.name : ""
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
                            font.pixelSize: Regovar.theme.font.size.normal
                            font.family: Regovar.theme.icons.name
                            text: samplesList.statusIcons[styleData.value.status]
                            onTextChanged:
                            {
                                if (styleData.value.status === 1) // 1 = Loading
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
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.icon
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.filename
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn { title: qsTr("Comment"); role: "comment" }


                Rectangle
                {
                    id: helpPanel
                    anchors.fill: parent

                    color: Regovar.theme.backgroundColor.overlay

                    visible: regovar.analysesManager.newFiltering.samples.length === 0

                    Text
                    {
                        text: qsTr("No sample selected for the analysis.\nClick on the adjacent button to add it.")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }
            }


            CheckBox
            {
                Layout.fillWidth: true
                id: trioActivated
                text: "Trio"
                checked: false
                onCheckedChanged:
                {
                    checked = regovar.analysesManager.newFiltering.samples.length === 3 && checked;
                    checkReady();
                }
            }

            GridLayout
            {
                Layout.fillWidth: true
                rowSpacing: 5
                columnSpacing: 5
                visible: trioActivated.checked

                rows:3
                columns: 5

                Text { text: "Child"; enabled: trioActivated.checked }
                ComboBox
                {
                    id: childSample
                    model: regovar.analysesManager.newFiltering.samples
                    Layout.fillWidth: true
                    enabled: trioActivated.checked
                    textRole: 'name'
                    onCurrentIndexChanged: checkReady();
                    delegate: ItemDelegate
                    {
                        width: childSample.width
                        height: Regovar.theme.font.boxSize.normal
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
                    text: qsTr("Index")
                    checked: true
                }
                Text { text: "Sex"; enabled: trioActivated.checked }
                ComboBox
                {
                    id: childSex
                    enabled: trioActivated.checked
                    model: [qsTr("Male"), qsTr("Female")]
                }

                Text { text: "Mother"; enabled: trioActivated.checked }
                ComboBox
                {
                    id: motherSample
                    enabled: trioActivated.checked
                    model: regovar.analysesManager.newFiltering.samples
                    textRole: 'name'
                    Layout.fillWidth: true
                    onCurrentIndexChanged: checkReady();
                    delegate: ItemDelegate
                    {
                        width: motherSample.width
                        height: Regovar.theme.font.boxSize.normal
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
                    id: motherIndex
                    enabled: trioActivated.checked
                    text: qsTr("Index")
                    checked: false
                }
                Text { text: ""; Layout.columnSpan: 2 }

                Text { text: "Father"; enabled: trioActivated.checked }
                ComboBox
                {
                    id: fatherSample
                    enabled: trioActivated.checked
                    model: regovar.analysesManager.newFiltering.samples
                    textRole: 'name'
                    Layout.fillWidth: true
                    onCurrentIndexChanged: checkReady();
                    delegate: ItemDelegate
                    {
                        width: fatherSample.width
                        height: Regovar.theme.font.boxSize.normal
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
                    text: qsTr("Index")
                    checked: false
                }
                Text { text: ""; Layout.columnSpan: 2 }
            }

        }

        Column
        {
            id: actionColumn
            anchors.top: parent.top
            anchors.topMargin:  tableTitle.height + 10
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
                        samples = samples.concat(regovar.analysesManager.newFiltering.samples[rowIndex]);
                    });
                    regovar.analysesManager.newFiltering.removeSamples(samples);
                    trioActivated.checked = regovar.analysesManager.newFiltering.samples.length === 3;
                }
            }
        }
    }

    SelectSamplesDialog
    {
        id: sampleSelector
        filteringAnalysis: regovar.analysesManager.newFiltering
        subject: null
        onSamplesSelected:
        {
            regovar.analysesManager.newFiltering.addSamples(samples);
            trioActivated.checked = regovar.analysesManager.newFiltering.samples.length === 3;
            checkReady();
        }
    }
}
