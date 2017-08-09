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
    title : qsTr("Type")
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
            text: qsTr("Missense")
            onCheckedChanged: regovar.currentFilteringAnalysis.quickfilters.transmissionFilter.setFilter(0, checked)

        }
        CheckBox
        {
            text: qsTr("Stop (Nonsense)")
            onCheckedChanged: regovar.currentFilteringAnalysis.quickfilters.transmissionFilter.setFilter(1, checked)

        }
        CheckBox
        {
            text: qsTr("Splicing")
            onCheckedChanged: regovar.currentFilteringAnalysis.quickfilters.transmissionFilter.setFilter(2, checked)
        }
    }
}
