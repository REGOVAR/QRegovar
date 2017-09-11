import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: inputsList.count > 0

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text:  qsTr("Select the sample(s) you want to analyse.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.control
        color: Regovar.theme.primaryColor.back.normal
    }

    ColumnLayout
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10

        Text
        {
            text: qsTr("Selected samples")
            font.pixelSize: Regovar.theme.font.size.control
            color: Regovar.theme.frontColor.normal
        }
        RowLayout
        {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Rectangle
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Regovar.theme.boxColor.back
                border.width: 1
                border.color: Regovar.theme.boxColor.border

                ListView
                {
                    id: inputsList
                    clip: true
                    anchors.fill: parent
                    anchors.margins: 1

                    model: [{"subject" : "MD-02-75 - DUPONT Michel (64y)", "sample" : "HP-col5"}, {"subject" : "MD-02-72 - DUPONT Michelline", "sample" : "HP-col75"}, {"subject" : "MD-02-77 - DUPONT Michou", "sample" : "HP-col8"}]

                    delegate: Rectangle
                    {
                        width: inputsList.width
                        height: Regovar.theme.font.boxSize.control
                        color: index % 2 == 0 ? Regovar.theme.backgroundColor.main : "transparent"

                        Row
                        {
                            anchors.fill: parent
                            Text
                            {
                                text: model.modelData.subject
                            }
                            Text
                            {
                                width: Regovar.theme.font.boxSize.control
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.icons.name
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: "{"
                            }
                            Text
                            {
                                text: model.modelData.sample
                            }
                        }
                    }
                }
            }



            Column
            {
                Layout.alignment: Qt.AlignTop
                spacing: 10
                Button
                {
                    id: addButton
                    text: qsTr("Add sample")
                    onClicked: { sampleSelector.open(); inputsList.model = 10; }
                }
                Button
                {
                    id: remButton
                    text: qsTr("Remove sample")
                    onClicked: inputsList.model = null;
                }
                Button
                {
                    id: addAttrButton
                    text: qsTr("Add attribute")
                    onClicked: { sampleSelector.open(); inputsList.model = 10; }
                }
                Button
                {
                    id: remAttrButton
                    text: qsTr("Remove attribute")
                    onClicked: inputsList.model = null;
                }
            }
        }
    }


    SelectSamplesDialog { id: sampleSelector }

}