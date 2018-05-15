import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtWebView 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"


GenericScreen
{
    id: root

    readyForNext: checkReadyreadyForNext();
    property real labelColWidth: 100
    onZChanged:
    {
        if (z == 100)
        {
            regovar.analysesManager.newPipeline.pipeline.configForm.refresh();
        }
    }

    function checkReadyreadyForNext()
    {
        return true; //nameField.text.trim() != "" && projectField.currentIndex > 0;
    }

    function validate()
    {
        return regovar.analysesManager.newPipeline.pipeline.configForm.validate();
    }

    Box
    {
        id: helpInfoBox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("If the pipeline allow it, you can customise some settings of your analysis.")
    }


    Text
    {
        anchors.fill: parent
        text: qsTr("No custom parameters available for this pipeline.")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: Regovar.theme.frontColor.disable
    }


    SplitView
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : parent.top
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? 10 : 0
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        visible: regovar.analysesManager.newPipeline.pipeline.form !== ""


        Flickable
        {
            id: configFormArea
            width: 500
            height: parent.height
            clip: true
            contentWidth: content.width
            contentHeight: content.height
            onContentYChanged: vbar.position = contentY / content.height;

            Behavior on contentY
            {
                NumberAnimation
                {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            DynamicForm
            {

                id: content
                width: configFormArea.width - 10
                anchors.left: parent.left
                anchors.leftMargin: 10

                model: regovar.analysesManager.newPipeline.pipeline.configForm
            }
        }

        Rectangle
        {
            id: helpArea
            color: "transparent"
            height: parent.height

            Text
            {
                anchors.fill: parent
                text: qsTr("No help page available")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.frontColor.disable
            }

            WebView
            {
                id: pipeHelPanel
                anchors.fill: parent
                anchors.leftMargin: 5
                url: regovar.analysesManager.newPipeline.pipeline.helpPage
                visible: !regovar.analysesManager.newPipeline.pipeline.helpPage.isEmpty
            }
        }
    }
}
