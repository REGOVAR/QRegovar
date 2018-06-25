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

    SplitView
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.left: root.left
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10
        orientation: Qt.Vertical

        Rectangle
        {
            id: topPanel
            width: root.width
            color: Regovar.theme.backgroundColor.main
            Layout.minimumHeight: 200
            Layout.fillHeight: true

            ColumnLayout
            {
                anchors.fill: parent
                anchors.bottomMargin: 10
                spacing: 10

                TextField
                {
                    id: searchField
                    Layout.fillWidth: true
                    placeholder: qsTr("Filter/Search pipelines")
                    iconLeft: "z"
                    displayClearButton: true

                    onTextEdited: regovar.pipelinesManager.availablePipes.proxy.setFilterString(text)
                    onTextChanged: regovar.pipelinesManager.availablePipes.proxy.setFilterString(text)
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

        Rectangle
        {
            id: bottomPanel
            width: root.width
            color: Regovar.theme.backgroundColor.main
            Layout.minimumHeight: 200

            GridLayout
            {
                anchors.fill: parent
                anchors.topMargin: 10
                columns: 3
                rowSpacing: 10
                columnSpacing: 10

                Text
                {
                    Layout.fillWidth: true
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                    text: currentAnalysis ? currentAnalysis.name : ""
                }

                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                    font.family: Regovar.theme.icons.name
                    text: currentAnalysis ? "H" : ""
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                    text: currentAnalysis ? regovar.formatDate(currentAnalysis.updateDate) : ""
                }

                Rectangle
                {
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: 3
                    border.width: 1
                    border.color: Regovar.theme.boxColor.border
                    Text
                    {
                        anchors.centerIn: parent
                        text: qsTr("No pipeline selected.")
                        font.pixelSize: Regovar.theme.font.size.title
                        color: Regovar.theme.primaryColor.back.light
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        } // end bottomPanel
    } // end SplitView

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
