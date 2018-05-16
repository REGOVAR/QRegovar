import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"

Item
{
    id: root
    anchors.fill: parent

    property File model
    onModelChanged:
    {
        fileContent.text = model.readFile();
        fileName.text = model.name;
    }

    ColumnLayout
    {
        anchors.fill: parent

        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            RowLayout
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10

                Text
                {
                    id: fileName
                    Layout.fillWidth: true
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    elide: Text.ElideRight
                }


                ButtonInline
                {
                    iconTxt: "_"
                    text: qsTr("Open externaly")
                    onClicked: Qt.openUrlExternally(model.localFilePath);
                }
            }



            Rectangle
            {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: parent.width
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }
        }


        TextArea
        {
            id: fileContent
            Layout.fillHeight: true
            Layout.fillWidth: true
            readOnly: true
            font.family: fixedFont
            font.pixelSize: Regovar.theme.font.size.normal
            colorText: "lightgrey"
            colorBack: "black"
        }
    }
}
