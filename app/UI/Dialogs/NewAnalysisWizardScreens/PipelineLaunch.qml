import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"


GenericScreen
{
    id: root
    property real labelColWidth: 100
    readyForNext: true

    onZChanged: checkReady()
    Component.onCompleted: checkReady()

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("You're almost done! Choose a name and select the folder you want to save your analysis to. Below is a summary of the configuration of the analysis.\nIf all is good. press the \"Launch\" button. The Regovar server will prepare your data, and you will then be able to dynamically filter the variants.")
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
            text: qsTr("Folder")
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
        }


        ComboBox
        {
            Layout.fillWidth: true
            id: projectField
            model: regovar.projectsManager.projectsFlatList
            textRole: "fullPath"
            onCurrentIndexChanged:
            {
                regovar.analysesManager.newFiltering.project = regovar.projectsManager.projectsFlatList[currentIndex];
                checkReady();
            }
            property int projectId

            Connections
            {
                target: regovar.projectsManager
                onProjectCreationDone:
                {
                    projectField.projectId = projectId;
                    projectField.model.push(regovar.projectsManager.getOrCreateProject(projectId).fullPath);
                    projectField.currentIndex = regovar.projectsManager.projectsFlatList.length - 1;
                }
            }
            Connections
            {
                target: regovar.projectsManager
                onProjectsFlatListChanged:
                {
                    projectField.currentIndex = 0;
                    for (var idx=0; idx<regovar.projectsManager.projectsFlatList.length; idx++)
                    {
                        if (regovar.projectsManager.projectsFlatList[idx].id == projectField.projectId)
                        {
                            projectField.currentIndex = idx;
                            break;
                        }
                    }
                }
            }
        }

        Button
        {
            text: qsTr("New folder")
            onClicked: regovar.openNewProjectWizard()
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
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
            onTextChanged: checkReady();
        }
        TextField
        {
            id: nameField
            Layout.fillWidth: true
            placeholder: qsTr("The name of the analysis")
            text: regovar.analysesManager.newPipeline.name
            onTextChanged:
            {
                if (regovar.analysesManager.newPipeline.name != text)
                {
                    regovar.analysesManager.newPipeline.name = text;
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
                spacing: 10

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
                        font.family: Regovar.theme.font.family
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        height: Regovar.theme.font.size.header
                        text: regovar.analysesManager.newPipeline.pipeline.name + (regovar.analysesManager.newPipeline.pipeline.version ? " (" + regovar.analysesManager.newPipeline.pipeline.version + ")" : "")
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.family
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
                        text: qsTr("Inputs")
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.family
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    }
                    Column
                    {
                        id: inputsList
                        Layout.fillWidth: true

                        Repeater
                        {
                            model: regovar.analysesManager.newPipeline.inputsFiles
                            RowLayout
                            {
                                height: Regovar.theme.font.boxSize.normal
                                width: inputsList.width
                                spacing: 5

                                Text
                                {
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    text: name.icon
                                    font.family: Regovar.theme.icons.name
                                    color: Regovar.theme.frontColor.disable
                                }
                                Text
                                {
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    text: name.filename
                                    elide: Text.ElideRight
                                    color: Regovar.theme.frontColor.disable
                                }
                            }
                        }
                    }
                }
                RowLayout
                {
                    width: scrollArea.viewport.width - 10
                    spacing: 10
                    height: Regovar.theme.font.boxSize.normal

                    Text
                    {
                        Layout.alignment: Qt.AlignTop
                        height: Regovar.theme.font.size.header
                        Layout.minimumWidth: root.labelColWidth
                        text: qsTr("Configuration")
                        color: Regovar.theme.frontColor.disable
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.family
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    }
                    Text
                    {
                        id: configSummary
                        Layout.fillWidth: true
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.frontColor.disable
                        verticalAlignment: Text.AlignVCenter
                        text: regovar.analysesManager.newPipeline.pipeline.configForm.printConfig()
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }



    function checkReady()
    {
        configSummary.text = regovar.analysesManager.newPipeline.pipeline.configForm.printConfig();
        readyForNext = true; //refField.currentIndex > 0;
    }

    function autoName()
    {
        var name = "";
        name +=  "Hugodims-2017-09-15";
        name += Qt.formatDate(Date.now(), "yyyy-MM-dd");
        return name;
    }

}
