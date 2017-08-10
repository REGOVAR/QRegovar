import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"

QuickFilterBox
{
    title : qsTr("Position")
    isEnabled : false
    isExpanded: false

    content: Column
    {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        CheckBox
        {
            Layout.fillWidth: true
            text: qsTr("Exonic")
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)

        }
        CheckBox
        {
            Layout.fillWidth: true
            text: qsTr("Intronic")
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(1, checked)

        }
        CheckBox
        {
            Layout.fillWidth: true
            text: qsTr("UTR")
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(2, checked)
        }
        CheckBox
        {
            Layout.fillWidth: true
            text: qsTr("Intergenenic")
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(3, checked)
        }
    }
}
