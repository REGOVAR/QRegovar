import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    signal selected(var choice)

    DialogHeader
    {
        id: startScreenTip
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        iconText: "I"
        title: qsTr("New analysis")
        text: qsTr("Select first which kind of analysis you want to perform.\n  - Pipeline : run a bioinformatic pipeline to analyse one or several files\n  - Variants filtering : load your samples' data into the Regovar database and then dynamically filter the variants thanks to the friendly interface")

    }

    RowLayout
    {
        anchors.top: startScreenTip.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        AnalysisTypeButtom
        {
            Layout.alignment : Qt.AlignHCenter
            label : qsTr("Pipeline")
            source: "qrc:/pipelineIcon.png"
            onClicked: selected(1);
        }
        AnalysisTypeButtom
        {
            Layout.alignment : Qt.AlignHCenter
            label : qsTr("Variants filtering")
            source: "qrc:/filteringIcon.png"
            onClicked: selected(2);
        }
    }

}
