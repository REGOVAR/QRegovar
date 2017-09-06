import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2 as OLD

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
            text: qsTr("Simple condition on a specific variant's annotation field. Allowed operator may change according to the type of field.")
            wrapMode: Text.WordWrap
        }

        Text
        {
            text: qsTr("Field")
        }
        OLD.ComboBox
        {
            Layout.fillWidth: true
            editable: true
            model: ["Toto", "Tata", "Tota", "ToTu", "Tato", "Tutu", "Tuta", "tuto"]
        }

        Text
        {
            text: qsTr("Operator")
        }
        ComboBox
        {
            Layout.fillWidth: true
            model: ["<", ">", "=", "!="]
        }

        Text
        {
            text: qsTr("Value")
        }
        TextField
        {
            Layout.fillWidth: true
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
}
