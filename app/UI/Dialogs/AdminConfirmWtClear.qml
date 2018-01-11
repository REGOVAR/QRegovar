import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: questionDialog
    modality: Qt.WindowModal


    title: qsTr("Clear temporary data confirmation")

    width: 400
    height: 300

    property string wtId: "0"

    signal yes()
    signal no()

    contentItem: Rectangle
    {
        id: root
        color: Regovar.theme.backgroundColor.main



        GridLayout
        {
            anchors.top: root.top
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: controlButtons.top
            anchors.margins: 10

            rows: 3
            columns: 2
            columnSpacing: 10

            Text
            {
                Layout.fillHeight: true
                width:  100
                text: "i"
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: 50
                font.family: Regovar.theme.icons.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text
            {
                Layout.fillWidth: true
                text: qsTr("Following instruction will executed server side to clear temp data:")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }
            TextArea
            {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "DROP TABLE IF EXISTS wt_" + wtId + " CASCADE;\nDROP TABLE IF EXISTS wt_" + wtId + "_var CASCADE\nDROP TABLE IF EXISTS wt_" + wtId + "_tmp CASCADE\nAnalysis status will be set to 'empty'"
            }
            Text
            {
                Layout.columnSpan: 2
                text: qsTr("After the clear, you will not be able to use 'filtering' feature for this analysis. You will have to regenerate \"temp\" data by clicking on \"prepare filtering\" button in the analysis overview page.")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }

        }



        Rectangle
        {
            id: controlButtons
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.margins: 10
            width: yesButton.width + noButton.width + 30
            height: yesButton.height + 20
            color: "transparent"

            Button
            {
                id: noButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.margins: 10

                text: qsTr("No")
                onClicked:
                {
                    questionDialog.no();
                    questionDialog.close();
                }
            }
            Button
            {
                id: yesButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 10

                text: qsTr("Yes")
                onClicked:
                {
                    questionDialog.yes();
                    questionDialog.close();

                }
            }
        }
    }
}
