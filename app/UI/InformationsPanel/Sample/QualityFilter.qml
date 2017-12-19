import QtQuick 2.9
import QtQuick.Layouts 1.3

import "../../Regovar"

Item
{
    id: root
    width: 250
    height: 250

    property var model
    onModelChanged:
    {
        if (model)
        {
            updateViewFromModel(model);
        }
    }

    //
    // Header
    //
    Text
    {
        anchors.top: root.top
        anchors.left: root.left
        text: qsTr("Filter & Qual")
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
        height: Regovar.theme.font.boxSize.normal
        verticalAlignment: Text.AlignVCenter
        font.bold: true
    }

    Rectangle
    {
        anchors.fill: parent
        anchors.topMargin: Regovar.theme.font.boxSize.normal
        color: Regovar.theme.boxColor.back
        border.width: 1
        border.color: Regovar.theme.boxColor.border
        clip: true


        Rectangle
        {
            anchors.centerIn: parent

            color: "transparent"
            height: Regovar.theme.font.boxSize.normal
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            Text
            {
                anchors.centerIn: parent
                text: qsTr("Not yet implemented")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.disable
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
