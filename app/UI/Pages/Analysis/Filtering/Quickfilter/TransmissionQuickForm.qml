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
    title : qsTr("Inheritance mode")
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
            text: qsTr("All")
            checked: true
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)

        }
        CheckBox
        {
            text: qsTr("Heterozygous")
            checked: false
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(1, checked)

        }
        CheckBox
        {
            text: qsTr("Homozygous")
            checked: false
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(2, checked)
        }
        CheckBox
        {
            text: qsTr("Composite heterozygous")
            checked: false
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(3, checked)
        }

        CheckBox
        {
            text: qsTr("De novo")
            checked: false
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(4, checked)
        }
        CheckBox
        {
            text: qsTr("X-linked")
            checked: false
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(5, checked)
        }
    }
}
