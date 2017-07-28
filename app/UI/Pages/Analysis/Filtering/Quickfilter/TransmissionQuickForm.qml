import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


Rectangle
{
    id: root
    color: "lightgrey"

    Rectangle
    {
        id: header
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right

        height: 30
        color: "grey"


        Text
        {
            text: "Transmission"
        }
    }

    Column
    {

        anchors.top: header.bottom
        anchors.left: root.left
        anchors.right: root.right

        CheckBox
        {
            text: "Dominant"
            onCheckedChanged: regovar.currentQuickFilters.transmissionFilter.setFilter(0, checked)
        }
        CheckBox
        {
            text: "Recessif"
            onCheckedChanged: regovar.currentQuickFilters.transmissionFilter.setFilter(1, checked)
        }
        CheckBox
        {
            text: "Composite"
            onCheckedChanged: regovar.currentQuickFilters.transmissionFilter.setFilter(2, checked)
        }
    }
}
