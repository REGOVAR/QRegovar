import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtWebView 1.0
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"
import "qrc:/qml/InformationPanel/Pipeline"


GenericScreen
{
    id: root

    readyForNext: true
    property PipelineAnalysis selectedPipeline: regovar.analysesManager.newFiltering.refId
    onZChanged:
    {
        if (z == 100) // = When page is displayed
        {
            regovar.analysesManager.resetNewPipeline();
        }
    }


    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("Choose which pipeline to use to do your analysis among the list below.")
    }


    SplitView
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : parent.top
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? 10 : 0
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
                    onCurrentItemChanged: updatePipeInfoPanel()
                    Component.onCompleted: updatePipeInfoPanel()

                    delegate: Rectangle
                    {
                        id: pipelineItem
                        property bool hovered: false

                        width: pipelinesList.width
                        height: Regovar.theme.font.boxSize.normal
                        color: pipelinesList.currentIndex == index ? Regovar.theme.secondaryColor.back.light : "transparent"

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
                                color: pipelinesList.currentIndex == index ? Regovar.theme.secondaryColor.front.normal : pipelineItem.hovered ? Regovar.theme.secondaryColor.back.light : Regovar.theme.frontColor.normal
                            }
                            Text
                            {
                                text: model.name + " (" + model.version + ")"
                                height: Regovar.theme.font.boxSize.normal
                                font.pixelSize: Regovar.theme.font.size.normal
                                verticalAlignment: Text.AlignVCenter
                                color: pipelinesList.currentIndex == index ? Regovar.theme.secondaryColor.front.normal : pipelineItem.hovered ? Regovar.theme.secondaryColor.back.light : Regovar.theme.frontColor.normal
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
                        if (pipelinesList.currentIndex > -1)
                        {
                            var idx = regovar.pipelinesManager.intalledPipes.proxy.getModelIndex(pipelinesList.currentIndex);
                            var id = regovar.pipelinesManager.intalledPipes.data(idx, 257); // 257 = Qt::UserRole+1 = id
                            var pipe = regovar.pipelinesManager.getOrCreatePipe(id);

                            if (pipe && !pipe.aboutPage !== "")
                            {
                                regovar.analysesManager.newPipeline.pipeline = pipe;
                                pipeInfoPanel.url = pipe.aboutPage;
                                pipeInfoPanel.visible = true;
                            }
                            else
                            {
                                pipeInfoPanel.url = "";
                                pipeInfoPanel.visible = false;
                            }
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
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.frontColor.disable
            }

            WebView
            {
                id: pipeInfoPanel
                anchors.fill: parent
                anchors.leftMargin: 5
                visible: false
            }

        }
    }
}
