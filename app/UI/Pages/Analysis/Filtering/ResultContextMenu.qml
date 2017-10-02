import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import "../../../Regovar"

Dialog
{
    id: dialogBox
    title: qsTr("External tools")

    property var data
    property var variantsTools
    property var geneTools
    onDataChanged:
    {
        if (data)
        {
            title.text = "chr" + data["chr"] + ":" + data["pos"] + " " + data["ref"] + ">" + data["alt"];
            variantsTools = data["online_tools_variant"];
            geneTools = data["online_tools_gene"];
            geneTitle.text = data["genename"];

            if (geneTitle.text)
                geneHeader.visible = true;
            else
                geneHeader.visible = false;

        }
    }

    contentItem: Rectangle
    {
        id: root

        color: Regovar.theme.backgroundColor.main
        border.width: 1
        border.color: Regovar.theme.boxColor.border


        width: 200
        height: rootLayout.height + 2







        Column
        {
            id: rootLayout

            Rectangle
            {
                id: header
                width: root.width - 2
                height: Regovar.theme.font.boxSize.header
                color: Regovar.theme.primaryColor.back.normal

                Row
                {
                    anchors.fill: parent

                    Text
                    {
                        text: "j"
                        width: Regovar.theme.font.boxSize.header
                        height: Regovar.theme.font.boxSize.header

                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.primaryColor.front.normal
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text
                    {
                        id: title
                        height: Regovar.theme.font.boxSize.header
                        color: Regovar.theme.primaryColor.front.normal
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle
                {
                    height: 1
                    width: root.width
                    anchors.bottom: header.bottom
                    color: Regovar.theme.primaryColor.back.dark
                }
            }

            Repeater
            {
                model: variantsTools

                ResultContextMenuAction
                {
                    url: modelData.url
                    iconText: "_"
                    label: modelData.name
                    width: root.width - 2
                }
            }

            Rectangle
            {
                id: geneHeader
                width: root.width - 2
                height: Regovar.theme.font.boxSize.header
                color: Regovar.theme.primaryColor.back.normal

                Row
                {
                    anchors.fill: parent

                    Text
                    {
                        text: "j"
                        width: Regovar.theme.font.boxSize.header
                        height: Regovar.theme.font.boxSize.header

                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.primaryColor.front.normal
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text
                    {
                        id: geneTitle
                        height: Regovar.theme.font.boxSize.header
                        color: Regovar.theme.primaryColor.front.normal
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle
                {
                    height: 1
                    width: root.width
                    anchors.bottom: geneHeader.bottom
                    color: Regovar.theme.primaryColor.back.dark
                }
            }

            Repeater
            {
                model: geneTools

                ResultContextMenuAction
                {
                    url: modelData.url
                    iconText: "_"
                    label: modelData.name
                    width: root.width - 2
                }
            }
        }
    }
}
