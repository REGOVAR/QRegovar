import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"


ScrollView
{
    id: root
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    property var model
    onModelChanged:  if (model) { updateFromModel(model); }

    property string varId
    onVarIdChanged:
    {
        if (varId)
        {
            // Display loading feedback

            // request information

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
