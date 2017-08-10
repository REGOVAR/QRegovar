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
    title : qsTr("In silico prediction")
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
            text: qsTr("SIFT")
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)

        }
        CheckBox
        {
            text: qsTr("Polyphen")
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(1, checked)

        }
        CheckBox
        {
            text: qsTr("CADD")
            onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(2, checked)
        }
    }
}
