import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var model
    onModelChanged:  if (model) { updateFromModel(model); }

    property string varId
    onVarIdChanged:
    {
        if (varId)
        {
            // Display loading feedback

            // request informations

        }
        else
        {
            // Display help message
        }
    }

    function updateFromModel(data)
    {
    }



    Text
    {
        text: "Stats !"
        width: Regovar.theme.font.boxSize.header
        height: Regovar.theme.font.boxSize.header

        color: Regovar.theme.primaryColor.front.normal
        font.pixelSize: Regovar.theme.font.size.header
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

}
