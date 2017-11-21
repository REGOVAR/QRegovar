import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"
import "../Quickfilter"


QuickFilterBox
{
    id: root
    title : qsTr("Export")
    isExpanded: false

    property bool internalUiUpdate: false
    property var parameters


    onModelChanged:
    {
        root.enabled = model.quickfilters.transmissionFilter.isVisible();
    }

    content: Column
    {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right



        Rectangle { width: root.width; height: 5; color: "transparent" }
        GridLayout
        {
            width: content.width - 50
            anchors.left: parent.left
            anchors.leftMargin: 30

            columnSpacing: 10
            rowSpacing: 5
            columns: 2
            rows: 2

            Text
            {

                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.dark
                text: qsTr("Type:")
            }

            ComboBox
            {
                id: modeAll
                Layout.fillWidth: true
                model: regovar.exporters
                textRole: "name"
                onCurrentIndexChanged: parameters = regovar.exporters[currentIndex].parameters
            }

            Text
            {
                Layout.row: 1
                Layout.column: 1
                Layout.fillWidth: true
                text: qsTr("Select the format in which you wants to export your data.")
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        Rectangle
        {
            visible: parameters
            width: root.width
            height: 20
            color: "transparent"
            Rectangle
            {
                width: content.width - 50
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 30
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }
        }

        Column
        {
            visible: parameters

            Repeater
            {
                model: root.parameters

                CheckBox
                {
                    text: modelData.key
                }
            }
        }



        Rectangle { width: root.width; height: 5; color: "transparent" }
    }
}
