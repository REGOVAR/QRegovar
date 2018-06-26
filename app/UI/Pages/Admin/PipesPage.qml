import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model
    property QtObject currentAnalysis // TODO: need it ?

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Regovar pipelines")
        }
        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
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
        text: qsTr("Browse, install and uninstall pipeline.")
    }


    ColumnLayout
    {
        id: actionsPanel
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            id: newAnalysis
            text: qsTr("Install")
            onClicked: fileSelector.open()
        }
        Button
        {
            id: deleteAnalysis
            text: qsTr("Remove")
            onClicked:  deleteSelectedPipeline()
        }
    }


    Item
    {
        id: topPanel
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.left: root.left
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 10

            TextField
            {
                id: searchField
                Layout.fillWidth: true
                placeholder: qsTr("Filter/Search pipelines")
                iconLeft: "z"
                displayClearButton: true

                onTextEdited: regovar.pipelinesManager.allPipes.proxy.setFilterString(text)
                onTextChanged: regovar.pipelinesManager.allPipes.proxy.setFilterString(text)
            }


            TableView
            {
                id: browser
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: regovar.pipelinesManager.allPipes.proxy

                // Default delegate for all column
                itemDelegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal
                        text: styleData.value
                        elide: Text.ElideRight
                    }
                }

                TableViewColumn
                {
                    role: "starred"
                    title: qsTr("Starred")
                    width: 75
                }
                TableViewColumn
                {
                    role: "status"
                    title: qsTr("Status")
                    width: 75
                }
                TableViewColumn
                {
                    role: "name"
                    title: qsTr("Name")
                    width: 200
                }
                TableViewColumn
                {
                    role: "version"
                    title: qsTr("Version")
                    width: 75
                }
                TableViewColumn
                {
                    role: "description"
                    title: qsTr("Description")
                    width: 400
                }

            } // end TableView
        } // end topPanel
    }



    SelectFilesDialog
    {
        id: fileSelector
        onFileSelected:
        {
            for(var idx in files)
            {
                var file = files[idx];
                regovar.pipelinesManager.install(file.id);
            }
        }
    }
    QuestionDialog
    {
        id: deletePipelineConfirmDialog
        width: 400
        property var model
        onModelChanged:
        {
            if (model)
            {
                var txt = qsTr("Do you confirm the uninstallation of the pipeline '{0}' ({1}) ?");
                txt = txt.replace('{0}', model.name);
                txt = txt.replace('{1}', model.version);
                text = txt;
            }
        }
        title: qsTr("Uninstall pipeline")
        onYes:
        {
            regovar.pipelinesManager.uninstall(model);
        }
    }


    /// Retrive model of the selected pipeline in the treeview and delete it.
    function deleteSelectedPipeline()
    {
        var idx = regovar.pipelinesManager.allPipes.proxy.mapToSource(browser.currentIndex);
        var pipe = regovar.pipelinesManager.allPipes.getAt(idx);


        if (pipe)
        {
            deletePipelineConfirmDialog.model = pipe;
            deletePipelineConfirmDialog.visible = true;
        }
    }
}
