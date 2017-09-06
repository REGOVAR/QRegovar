import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"



Rectangle
{
    id: root
    implicitWidth: 200
    implicitHeight: container.height

    color: "lightgreen"
    border.color: "darkgreen"
    border.width: 1

    property FilteringAnalysis analysis
    property var model
    property var component
    property bool enabled: true
    property string logicalColor: ""

    Rectangle
    {
        x: Regovar.theme.font.boxSize.control / 2
        y: 0
        width: 1
        height: parent.height / 3
        color: root.logicalColor
    }

    Text
    {
        height: Regovar.theme.font.boxSize.control
        width: Regovar.theme.font.boxSize.control
        x: 5
        y: 0

        text: enabled ? "p" : "r"
        font.family: Regovar.theme.icons.name
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 0

        color: root.logicalColor
    }

    Container
    {
        id: container
        x: 0
        y: 5 + Regovar.theme.font.boxSize.control

        implicitHeight: Regovar.theme.font.boxSize.control
        width: root.width - 5 - Regovar.theme.font.boxSize.control
        onWidthChanged: console.log("new width : " + width);
        onHeightChanged: console.log("new height : " + height);
    }














    onModelChanged:
    {
        var operator = model[0];
        if (operator === "AND" || operator === "OR")
        {
            component = createBlock("LogicalBlock.qml", model);
        }
        else if  (operator === "IN" || operator === "NOTIN")
        {
            component = createBlock("SetBlock.qml", model);
        }
        else
        {
            console.log("create FIELD block");
            component = createBlock("FieldBlock.qml", model);
        }
    }


    function updateHeight()
    {
        container.height = component.height;
    }

    function createBlock(type, model)
    {
        var comp = Qt.createComponent(type);
        var elmt;
        if (comp.status == Component.Ready)
        {
            elmt = comp.createObject(container);
            elmt.analysis = root.analysis;
            elmt.onHeightChanged.connect(updateHeight);

            if (elmt.hasOwnProperty("model"))
            {
                elmt.model = Qt.binding(function() { return root.model; });
            }
        }
        else if (comp.status == Component.Error)
        {
            console.log("> Error creating advanced filter block (" + type + ") : ", comp.errorString());
        }

        return elmt;
    }
}
