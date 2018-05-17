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
            height: Regovar.theme.font.boxSize.title
            color: Regovar.theme.backgroundColor.alt
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            radius: 2

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text
                {
                    id: fileIcon
                    Layout.minimumWidth: Regovar.theme.font.boxSize.header
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.header
                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.dark
                }
                Text
                {
                    id: fileName
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    elide: Text.ElideRight
                }


                ButtonIcon
                {
                    iconTxt: "_"
                    text: qsTr("Open externaly")
                    onClicked: Qt.openUrlExternally(model.localFilePath);
                }
            }
        }


        TextArea
        {
            id: fileContent
            Layout.fillHeight: true
            Layout.fillWidth: true
            readOnly: true
            font.family: fixedFont
        }
    }
}
