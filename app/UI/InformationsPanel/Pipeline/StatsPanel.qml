import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var model
    onModelChanged:  if (model) { updateFromModel(model); }

    function updateFromModel(data)
    {
    }



    Rectangle
    {
        id: empty
        anchors.fill: parent
        anchors.margins: 10
        color: "transparent"

        Text
        {
            anchors.centerIn: parent
            text: qsTr("Not yet implemented")
            font.pixelSize: Regovar.theme.font.size.title
            color: Regovar.theme.primaryColor.back.light
        }
    }
}
