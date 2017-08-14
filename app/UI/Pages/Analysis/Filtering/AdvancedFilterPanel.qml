import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"

ColumnLayout
{
    id: root
    property FilteringAnalysis model


    Text
    {
        text: qsTr("Saved filters")
        font.pixelSize: Regovar.theme.font.size.header
        color: Regovar.theme.primaryColor.back.dark
    }
    Text
    {
        text: qsTr("Current filter")
        font.pixelSize: Regovar.theme.font.size.header
        color: Regovar.theme.primaryColor.back.dark
    }
    TextArea
    {
        id: advancedFilterJsonEditor
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: root.model.filter
    }
    RowLayout
    {
        Layout.fillWidth: true

        Button
        {
            text: qsTr("Clear")
            onClicked:
            {
                root.model.filter = "[\"AND\", []]";
                root.model.refresh();
            }
        }
        Button
        {
            text: qsTr("Apply")
            onClicked:
            {
                root.model.filter = advancedFilterJsonEditor.text;
                root.model.refresh();
            }
        }
        Button
        {
            text: qsTr("Save")
        }
    }
}
