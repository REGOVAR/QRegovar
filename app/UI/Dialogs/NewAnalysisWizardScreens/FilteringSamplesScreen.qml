import QtQuick 2.9
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
        // security if method is called before init of a component
        if (!trioActivated || !childSample || !motherSample || !fatherSample || !childIndex || !motherIndex || !fatherIndex || !childSex)
            return;

        readyForNext = false;

        if (regovar.newFiltering.samples.length > 0)
        {

            // Check for trio
            regovar.newFiltering.isTrio = trioActivated.checked;
            if (trioActivated.checked)
            {
                // assert that child/mother/father are distinct samples
                if (childSample.currentIndex  != motherSample.currentIndex &&
                    childSample.currentIndex  !=  fatherSample.currentIndex &&
                    motherSample.currentIndex != fatherSample.currentIndex)
                {
                    regovar.newFiltering.child = regovar.newFiltering.samples[childSample.currentIndex];
                    regovar.newFiltering.mother = regovar.newFiltering.samples[motherSample.currentIndex];
                    regovar.newFiltering.father = regovar.newFiltering.samples[fatherSample.currentIndex];

                    regovar.newFiltering.child.isIndex = childIndex.checked;
                    regovar.newFiltering.mother.isIndex = motherIndex.checked;
                    regovar.newFiltering.father.isIndex = fatherIndex.checked;

                    regovar.newFiltering.child.sex = childSex.currentIndex == 1 ? "F" : "M";

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
            for(idx=0; idx<regovar.newFiltering.samples.length; idx++)
            {
                var sample = regovar.newFiltering.samples[idx];
                for(var j=0; j<sample.defaultAnnotationsDbUid.length; j++)
                {
                    var uid = sample.defaultAnnotationsDbUid[j];
                    if(annotDbUid.indexOf(uid) == -1)
                    {
                        annotDbUid = annotDbUid.concat(uid);
                    }
                }
            }

            for(idx=0; idx<regovar.newFiltering.allAnnotations.length; idx++)
            {
                var isDefault = annotDbUid.indexOf(regovar.newFiltering.allAnnotations[idx].uid) > -1;
                regovar.newFiltering.allAnnotations[idx].selected = idx < 2 || isDefault;
                regovar.newFiltering.allAnnotations[idx].isDefault = isDefault;
            }
        }
    }

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text:  qsTr("Select the sample(s) you want to analyse.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
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
                id: tableTitle
                text: qsTr("Selected samples")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.normal
            }

            TableView
            {
                id: samplesList
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.newFiltering.samples
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
                                if (styleData.value.status == 1) // 1 = Loading
                                {
                                    statusIconAnimation.start();
                                }
                                else
                                {
                                    statusIconAnimation.stop();
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

                    color: "#aaffffff"

                    visible: regovar.newFiltering.samples.length == 0

                    Text
                    {
                        text: qsTr("No sample selected for the analysis.\nClick on the adjacent button to add it.")
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.normal
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                    Text
                    {
                        anchors.right: parent.right
                        anchors.top : parent.top
                        text: "ä"
                        font.family: Regovar.theme.icons.name
                        font.pixelSize: 30
                        color: Regovar.theme.primaryColor.back.normal

                        NumberAnimation on anchors.rightMargin
                        {
                            duration: 2000
                            loops: Animation.Infinite
                            from: 30
                            to: 0
                            easing.type: Easing.SineCurve
                        }
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
                    checked = regovar.newFiltering.samples.length == 3 && checked;
                    checkReady();
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
                    model: regovar.newFiltering.samples
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
                    model: regovar.newFiltering.samples
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
                    model: regovar.newFiltering.samples
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
                        samples = samples.concat(regovar.newFiltering.samples[rowIndex]);
                    });
                    regovar.newFiltering.removeSamples(samples);
                    trioActivated.checked = regovar.newFiltering.samples.length == 3;
                }
            }
        }
    }

    SelectSamplesDialog
    {
        id: sampleSelector
        referencialSelectorEnabled: false
        onSamplesSelected:
        {
            regovar.newFiltering.addSamples(samples);
            trioActivated.checked = regovar.newFiltering.samples.length == 3;
            checkReady();
        }
    }
}
