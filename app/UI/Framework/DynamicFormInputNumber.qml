import QtQuick 2.9
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../Regovar"


GridLayout
{
    id: root
    columnSpacing: 10
    rowSpacing: 5
    columns: 2
    rows: 2

    property DynamicFormFieldModel model
    onModelChanged:
    {
        if (model)
        {
            model.form.onLabelWidthChanged.connect(function() { label.Layout.minimumWidth = model.form.labelWidth; } );
            model.onDataChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }

    function updateViewFromModel()
    {
        input.text = model.value;
        input.iconLeft = model.error ? "h" : "n";
        input.color =  model.error ? Regovar.theme.frontColor.danger : Regovar.theme.frontColor.normal;
    }

    Text
    {
        id: label
        elide: Text.ElideRight
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.dark
        text: root.model ? root.model.title : "?"
        onWidthChanged: model.form.labelWidth = Math.max(model.form.labelWidth, width)
    }

    TextField
    {
        id: input
        Layout.fillWidth: true
        onEditingFinished: model.value = input.text;
        displayClearButton: false;
    }

    Text
    {
        Layout.row: 1
        Layout.column: 1
        Layout.fillWidth: true
        text: root.model ? root.model.description : "?"
        font.pixelSize: Regovar.theme.font.size.small
        font.italic: true
        color: Regovar.theme.primaryColor.back.normal
        wrapMode: Text.WordWrap
    }
}
