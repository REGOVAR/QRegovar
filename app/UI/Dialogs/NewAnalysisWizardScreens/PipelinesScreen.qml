import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"
import "qrc:/qml/InformationPanel/Pipeline"


GenericScreen
{
    id: root

    readyForNext: true

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Choose which pipeline to use to do your analysis among the list below.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }

    SplitView
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        ColumnLayout
        {
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            width: 300

            spacing: 10

            TextField
            {
                Layout.fillWidth: true
                anchors.rightMargin: 5
                iconLeft: "z"
                displayClearButton: true
                placeholder: qsTr("Search pipeline...")
                onTextEdited: regovar.pipelinesManager.intalledPipes.proxy.setFilterString(text)
                onTextChanged: regovar.pipelinesManager.intalledPipes.proxy.setFilterString(text)
            }

            Rectangle
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                anchors.rightMargin: 5
                color: Regovar.theme.boxColor.back
                border.width: 1
                border.color: Regovar.theme.boxColor.border
                radius: 2

                ListView
                {
                    id: pipelinesList
                    clip: true
                    anchors.fill: parent
                    anchors.margins: 1
                    model: regovar.pipelinesManager.intalledPipes.proxy
                    onModelChanged: updatePipeInfoPanel()
                    onCurrentItemChanged: updatePipeInfoPanel()

                    delegate: Rectangle
                    {
                        property bool hovered: false

                        width: pipelinesList.width
                        height: Regovar.theme.font.boxSize.normal
                        color: hovered ? Regovar.theme.secondaryColor.back.light : pipelinesList.currentIndex == index ? Regovar.theme.secondaryColor.back.normal : "transparent"

                        Row
                        {
                            Text
                            {
                                height: Regovar.theme.font.boxSize.normal
                                width: Regovar.theme.font.boxSize.normal
                                text: model.starred ? "D" : ""
                                font.family: Regovar.theme.icons.name
                                font.pixelSize: Regovar.theme.font.size.normal
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text
                            {
                                text: model.name + " (" + model.version + ")"
                                height: Regovar.theme.font.boxSize.normal
                                font.pixelSize: Regovar.theme.font.size.normal
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        MouseArea
                        {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.hovered = true
                            onExited: parent.hovered = false
                            onClicked: pipelinesList.currentIndex = index
                        }
                    }

                    function updatePipeInfoPanel()
                    {
                        if (pipelinesList.currentItem)
                        {
                            var idx = regovar.pipelinesManager.intalledPipes.proxy.getModelIndex(pipelinesList.currentIndex);
                            var id = regovar.pipelinesManager.intalledPipes.data(idx, 257); // 257 = Qt::UserRole+1 = id
                            var pipe = regovar.pipelinesManager.getOrCreatePipe(id);

                            pipeInfoPanel.model = pipe.toJson();
                            pipeInfoPanel.visible = true;
                            regovar.analysesManager.newPipeline.pipeline = pipe;
                        }
                    }
                }
            }
        }

        Rectangle
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            color: "transparent"

            Text
            {
                anchors.fill: parent
                text: qsTr("No pipeline selected")
                font.pixelSize: Regovar.theme.font.size.small
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.frontColor.disable
            }

            PipelineInformation
            {
                id: pipeInfoPanel
                anchors.fill: parent
                anchors.leftMargin: 5
                visible: false
            }

        }
    }
}
