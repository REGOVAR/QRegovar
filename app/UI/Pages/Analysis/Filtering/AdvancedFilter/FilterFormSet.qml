import QtQuick 2.7
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text
        {
            Layout.fillWidth: true
            text: qsTr("Filter by variant (chr-pos-ref-alt) or by site (chr-pos) that are (or not) in a specific set. Sets can be samples, saved filters or panels.")
            wrapMode: Text.WordWrap
        }

        Text
        {
            text: qsTr("Test")
        }
        ComboBox
        {
            id: testSelector
            Layout.fillWidth: true
            model: [qsTr("Variant"), qsTr("Site")]
        }

        Text
        {
            text: qsTr("Operator")
        }
        ComboBox
        {
            id: operatorSelector
            Layout.fillWidth: true
            model: [qsTr("IN"), qsTr("NOT IN")]
        }

        Text
        {
            text: qsTr("Value")
        }
        ComboBox
        {
            id: valueSelector
            Layout.fillWidth: true
            editable: true
            model: ["Toto", "Tata", "Tota", "ToTu", "Tato", "Tutu", "Tuta", "tuto"]
        }

        Rectangle
        {
            color: "transparent"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }


    Rectangle
    {
        height: 1
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.right: root.right
        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        width: 1
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.top: root.top
        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        width: 1
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.top: root.top
        color: Regovar.theme.boxColor.border
    }

    function getFilter()
    {
        var field = fieldSelector.selectedItem;

        return [operatorSelector.model[operatorSelector.currentIndex], testSelector.model[testSelector.currentIndex], ["sample", 1]];
    }
}
