import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"


GenericScreen
{
    id: root
    property real labelColWidth: 100
    readyForNext: true

    onZChanged:
    {
        nameField.text = autoName();
        checkReady();
    }

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("You're almost done! Choose a name and select the project you want to save your analysis to. Below is a summary of the configuration of the analysis.\nIf all is good. press the \"Launch\" button. The Regovar server will prepare your data, and you will then be able to dynamically filter the variants.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }

    RowLayout
    {
        id: projectForm
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 30
        spacing: 10

        Text
        {
            height: Regovar.theme.font.size.header
            Layout.minimumWidth: root.labelColWidth
            text: qsTr("Project")
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
        }

        ComboBox
        {
            Layout.fillWidth: true
            id: projectField
            model: regovar.projects
            textRole: "fullPath"
            currentIndex: regovar.selectedProject
            onCurrentIndexChanged:
            {
                if (regovar.selectedProject != currentIndex)
                {
                    regovar.selectedProject = currentIndex;
                    checkReady();
                }
            }
            delegate: ItemDelegate
            {
                width: projectField.width
                height: Regovar.theme.font.boxSize.normal
                contentItem: Text
                {
                    text: modelData.fullPath
                    color: enabled ? Regovar.theme.boxColor.front : Regovar.theme.frontColor.disable
                    font: projectField.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }


                highlighted: projectField.highlightedIndex === index
            }
        }
    }
    RowLayout
    {
        id: nameForm
        anchors.top: projectForm.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 10
        spacing: 10

        Text
        {
            height: Regovar.theme.font.size.header
            Layout.minimumWidth: root.labelColWidth
            text: qsTr("Name")
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
            onTextChanged: checkReady();
        }
        TextField
        {
            id: nameField
            Layout.fillWidth: true
            placeholderText: qsTr("The name of the analysis")
            text: regovar.newFilteringAnalysis.name
            onTextChanged:
            {
                if (regovar.newFilteringAnalysis.name != text)
                {
                    regovar.newFilteringAnalysis.name = text;
                    checkReady();
                }
            }
        }
        Button
        {
            text: qsTr("Name auto")
            onClicked: nameField.text = autoName();
        }
    }
    Text
    {
        anchors.top: nameForm.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 10
        text: qsTr("Analysis summary")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        //color: Regovar.theme.primaryColor.back.normal
    }


    Rectangle
    {
        anchors.top: nameForm.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.topMargin: Regovar.theme.font.size.normal + 15


        color: Regovar.theme.boxColor.back
        border.color: Regovar.theme.boxColor.border
        border.width: 1


        ScrollView
        {
            id: scrollArea
            anchors.fill: parent

            Column
            {
                x: 5
                y: 5
                spacing: 5

                RowLayout
                {
                    width: scrollArea.viewport.width - 10
                    spacing: 10

                    Text
                    {
                        height: Regovar.theme.font.size.header
                        Layout.minimumWidth: root.labelColWidth
                        text: qsTr("Type")
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        height: Regovar.theme.font.size.header
                        text: "Filtering "
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                RowLayout
                {
                    width: scrollArea.viewport.width - 10
                    spacing: 10

                    Text
                    {
                        height: Regovar.theme.font.size.header
                        Layout.minimumWidth: root.labelColWidth
                        text: qsTr("Referencial")
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        height: Regovar.theme.font.size.header
                        text: regovar.newFilteringAnalysis.refName
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                RowLayout
                {
                    width: scrollArea.viewport.width - 10
                    spacing: 10

                    Text
                    {
                        Layout.alignment: Qt.AlignTop
                        height: Regovar.theme.font.size.header
                        Layout.minimumWidth: root.labelColWidth
                        text: qsTr("Samples")
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    }
                    Column
                    {
                        Layout.fillWidth: true

                        Repeater
                        {
                            model: regovar.newFilteringAnalysis.samples

                            Row
                            {
                                Text
                                {
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    width: Regovar.theme.font.size.normal
                                    text: modelData.subjectUI.sex == "M" ? "9" :modelData.subjectUI.sex == "F" ? "<" : ""
                                    font.family: Regovar.theme.icons.name
                                    color: Regovar.theme.frontColor.disable
                                }
                                Text
                                {
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    text: modelData.subjectUI.lastname + " " + modelData.subjectUI.firstname + " (" + modelData.subjectUI.age + ")"
                                    elide: Text.ElideRight
                                    color: Regovar.theme.frontColor.disable
                                }

                                Text
                                {
                                    width: Regovar.theme.font.boxSize.normal
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    font.family: Regovar.theme.icons.name
                                    color: Regovar.theme.frontColor.disable
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    text: "{"
                                }
                                Text
                                {
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    color: Regovar.theme.frontColor.disable
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: "monospace"
                                    text: modelData.name
                                }
                            }

                        }

                    }
                }
                RowLayout
                {
                    width: scrollArea.viewport.width - 10
                    spacing: 10

                    Text
                    {
                        Layout.alignment: Qt.AlignTop
                        height: Regovar.theme.font.size.header
                        Layout.minimumWidth: root.labelColWidth
                        text: qsTr("Annotations")
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    }
                    Column
                    {
                        Layout.fillWidth: true

                        Repeater
                        {
                            model: regovar.newFilteringAnalysis.selectedAnnotationsDB

                            Text
                            {
                                font.pixelSize: Regovar.theme.font.size.normal
                                color: Regovar.theme.frontColor.disable
                                verticalAlignment: Text.AlignVCenter
                                text: modelData
                            }
                        }
                    }
                }
            }
        }
    }



    function checkReady()
    {
        readyForNext = true; //refField.currentIndex > 0;
    }

    property date currentDate: new Date()
    function autoName()
    {
        currentDate = new Date();

        var name = currentDate.toLocaleString(Qt.locale(), "yyyy.MM.dd");
        if (regovar.newFilteringAnalysis.samples.length == 1)
        {
            name = qsTr("Singleton ") + regovar.newFilteringAnalysis.samples[0].name + " - " + name;
        }
        else if (regovar.newFilteringAnalysis.samples.length == 3 && regovar.newFilteringAnalysis.isTrio)
        {
            name = qsTr("Trio ") + regovar.newFilteringAnalysis.child.name + " - " + name;
        }
        else
        {
            name = qsTr("Custom ") + name;
        }
        return name;
    }

}
