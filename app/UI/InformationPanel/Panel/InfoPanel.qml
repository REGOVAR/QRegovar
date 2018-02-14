import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"


ScrollView
{
    id: root

    property var model
    onModelChanged: updateFromModel(model)
    Component.onCompleted: updateFromModel(model)

    Column
    {
        x: 10
        y: 10

        TextEdit
        {
            id: infoText
            width: root.width - 30
            text: ""
            textFormat: TextEdit.RichText
            font.pixelSize: Regovar.theme.font.size.normal + 2
            color: Regovar.theme.frontColor.normal
            readOnly: true
            selectByMouse: true
            selectByKeyboard: true
            wrapMode: TextEdit.Wrap
            onLinkActivated: Qt.openUrlExternally(link)
        }
        Item
        {
            width: 1
            height: 10
        }
    }


    function updateFromModel(data)
    {
        if (data)
        {
            var headVersion = data.getVersion(data.versionsIds[0]);

            var text = "<table>";
            text += "<tr><td><b>Name: </b></td><td>" + data.name + "</td></tr>";
            text += "<tr><td><b>Head version: </b></td><td>" + headVersion.version + "</td></tr>";
            text += "<tr><td><b>Shared: </b></td><td>" + (data.shared ? qsTr("Yes") : qsTr("No")) + "</td></tr>";
            text += "<tr><td><b>Last update: </b></td><td>" + Regovar.formatDate(headVersion.updateDate) + "</td></tr>";
            text += "<tr><td><b>Owner: </b></td><td>" + data.owner + "</td></tr>";
            text += "<tr><td><b>Description: </b></td><td>" + data.description + "</td></tr>";
            text += "</table><br/><br/>";

            infoText.text = text;
        }
        else
        {
             infoText.text = "";
        }
    }
}
