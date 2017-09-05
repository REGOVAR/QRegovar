import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"

Rectangle
{
    id: root
    width: parent.width

    color: "transparent"

    property FilteringAnalysis analysis
    property var model
    property var component

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
            component = createBlock("FieldBlock.qml", model);
        }
    }



    function createBlock(type, model)
    {
        var comp = Qt.createComponent(type);
        var elmt;
        if (comp.status == Component.Ready)
        {
            elmt = comp.createObject(root);
            elmt.analysis = root.analysis;
            elmt.anchors.top = root.top;
            elmt.anchors.right = root.right;
            elmt.anchors.left = root.left;
            root.height = Qt.binding(function() { return elmt.height; });

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
