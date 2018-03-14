import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: checkReadyreadyForNext();
    property real labelColWidth: 100

    function checkReadyreadyForNext()
    {
        return true; //nameField.text.trim() != "" && projectField.currentIndex > 0;
    }

    function validate()
    {
        return regovar.analysesManager.newPipeline.pipeline.configForm.validate();
    }

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Hugodims pipeline parameters.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }

//    Text
//    {
//        id: scrollArea
//        anchors.top : header.bottom
//        anchors.left: root.left
//        anchors.right: root.right
//        anchors.bottom: root.bottom
//        anchors.topMargin: 30
//        text: qsTr("No parameters for this pipeline.")
//        wrapMode: Text.WordWrap
//        font.pixelSize: Regovar.theme.font.size.normal
//        color: Regovar.theme.primaryColor.back.normal
//        font.italic: true
//    }


    SplitView
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.topMargin: 30


        Rectangle
        {
            id: configFormArea
            color: "transparent"
            width: 500
            height: parent.height
            clip: true

            Text
            {
                id: analysesHeader
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.header
                text: qsTr("Configure the pipeline for your analysis")
            }

            Rectangle
            {
                anchors.top: analysesHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 10
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }



            ScrollView
            {
                id: analysesColumn
                anchors.fill: parent
                anchors.topMargin: Regovar.theme.font.boxSize.header + 5
                anchors.rightMargin: 10
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                DynamicForm
                {
                    width: configFormArea.width - 40
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    model: regovar.analysesManager.newPipeline.pipeline.configForm
                }
            }
        }

        Rectangle
        {
            id: helpArea
            color: "transparent"
            height: parent.height
            clip: true

            Text
            {
                id: subjectsHeader
                anchors.left: parent.left
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.header
                text: qsTr("Help")
            }

            Rectangle
            {
                anchors.top: subjectsHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }


//            Rectangle
//            {
//                id: subjectsColumn
//                anchors.fill: parent
//                anchors.topMargin: Regovar.theme.font.boxSize.header + 5
//                anchors.leftMargin: 10

//                color: "transparent"

//            }
        }
    }
}
