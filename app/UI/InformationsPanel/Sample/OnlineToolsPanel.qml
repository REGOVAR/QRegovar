import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"
import "../Common"


ScrollView
{
    id: root
    anchors.fill: parent
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    property var variantsTools
    property var geneTools
    property var model
    onModelChanged:  if (model) { updateFromModel(model); }

    function updateFromModel(data)
    {
        if (data)
        {
            variantsTools = data["online_tools_variant"];
            geneTools = data["online_tools_gene"];

            if (data["genename"])
                geneHeader.visible = true;
            else
                geneHeader.visible = false;
        }
    }

    Column
    {
        x:0
        y:0
        width: root.width
        Rectangle
        {
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Regarding the variant")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Repeater
        {
            model: variantsTools

            OnlineToolAction
            {
                url: modelData.url
                icon: "_"
                label: modelData.name
                width: root.width - 2
            }
        }

        Rectangle
        {
            id: geneHeader
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Regarding the gene")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Repeater
        {
            model: geneTools

            OnlineToolAction
            {
                url: modelData.url
                icon: "_"
                label: modelData.name
                width: root.width - 2
            }
        }
    }
}
