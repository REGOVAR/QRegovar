import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.regovar 1.0


Item
{
    id: root
    property var component: null
    property ToolParameter model
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
            elmt.anchors.top = root.top;
            elmt.anchors.right = root.right;
            elmt.anchors.left = root.left;
            elmt.anchors.topMargin = 1;
            root.height = Qt.binding(function() { return elmt.height; });

            if (elmt.hasOwnProperty("model"))
            {
                elmt.model = Qt.binding(function() { return root.model; });
                elmt.enabled = Qt.binding(function() { return root.enabled; });
            }
        }
        else if (comp.status == Component.Error)
        {
            console.log("> Error creating advanced filter block (" + type + ") : ", comp.errorString());
        }

        return elmt;
    }

}
