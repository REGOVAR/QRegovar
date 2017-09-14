import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    signal selected(var choice)

    Text
    {
        id: startScreenTip
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        text: qsTr("Select which kind of analysis you want to do.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.header
        color: Regovar.theme.primaryColor.back.dark
        horizontalAlignment: Text.AlignHCenter
    }

    RowLayout
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 50

        AnalysisTypeButtom
        {
            Layout.alignment : Qt.AlignHCenter
            label : qsTr("Pipeline")
            description: qsTr("Run a pipeline to analyse one or several files.")
            // source: "qrc:/pipeline.gif"
            onClicked: selected(1);
            onIsHoverChanged:
            {
                if (isHover)
                {
                    helpBox.text = description;
                }
                else
                {
                    helpBox.text = "";
                }
            }
        }
        AnalysisTypeButtom
        {
            Layout.alignment : Qt.AlignHCenter
            label : qsTr("Variants filtering")
            description: qsTr("Load your sample's data into the Regovar database and then dynamically filter the variants thanks the friendly interface.")
            //source: "qrc:/filtering.gif"
            onClicked: selected(2);
            onIsHoverChanged:
            {
                if (isHover)
                {
                    helpBox.text = description;
                }
                else
                {
                    helpBox.text = "";
                }
            }
        }
    }
    Text
    {
        id: helpBox
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        text: qsTr("Select above what you want to do.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.control
        color: Regovar.theme.primaryColor.back.dark
        horizontalAlignment: Text.AlignHCenter
    }



}
