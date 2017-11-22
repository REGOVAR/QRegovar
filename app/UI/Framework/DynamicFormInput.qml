import QtQuick 2.7
import QtQuick.Layouts 1.3


Item
{
    id: root
    property var component: null
    property var model
    onEnabledChanged: if (component) component.enabled = enabled;
    onModelChanged:
    {
        if (model)
        {
            console.log("model = " + model);
            console.log("type  = " + model.type);
            if (model.type === "enum")
            {
                component = createBlock("DynamicFormInputEnum.qml", model);
            }
            else if (model.type === "bool")
            {
                component = createBlock("DynamicFormInputBool.qml", model);
            }
            else if (model.type === "int")
            {
                component = createBlock("DynamicFormInputNumber.qml", model);
            }
            else
            {
                component = createBlock("DynamicFormInputString.qml", model);
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
