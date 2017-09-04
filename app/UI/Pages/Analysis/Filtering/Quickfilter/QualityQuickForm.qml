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
    id: root
    title : qsTr("Quality")
    isEnabled : false
    isExpanded: false

    onModelChanged:
    {
        depth.model = model.quickfilters.qualityFilter.depth;
    }

    content: QuickFilterFieldControl
    {
        id: depth

        anchors.left: parent.left
        anchors.right: parent.right
    }
}
