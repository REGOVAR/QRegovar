import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"

Rectangle
{
    id: root

    property FilteringAnalysis analysis
    property AdvancedFilterModel model
    property bool isEnabled
    onIsEnabledChanged: if (component) { component.isEnabled = isEnabled; }
    property var component: null

    color: "transparent"

    onModelChanged:
    {
        if (model)
        {
            console.log("model = " + model);
            console.log("type  = " + model.type);
            if (model.type === 0)
            {
                component = createBlock("LogicalBlock.qml", model);
            }
            else if (model.type === 2)
            {
                component = createBlock("SetBlock.qml", model);
            }
            else
            {
                component = createBlock("FieldBlock.qml", model);
            }
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
            elmt.anchors.topMargin = 1;
            root.height = Qt.binding(function() { return elmt.height; });

            if (elmt.hasOwnProperty("model"))
            {
                elmt.model = Qt.binding(function() { return root.model; });
                elmt.isEnabled = Qt.binding(function() { return root.isEnabled; });
            }
        }
        else if (comp.status == Component.Error)
        {
            console.log("> Error creating advanced filter block (" + type + ") : ", comp.errorString());
        }

        return elmt;
    }
}
