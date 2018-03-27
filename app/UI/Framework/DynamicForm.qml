import QtQuick 2.9
import Regovar.Core 1.0
import "qrc:/qml/Regovar"

Column
{
    id: root
    property DynamicFormModel model

    spacing: 10
    Repeater
    {
        model: root.model

        DynamicFormInput
        {
            width: root.width
            height: 30
            model: root.model.getAt(index)
        }
    }
}
