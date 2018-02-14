import QtQuick 2.9
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
    isExpanded: false

    function reset()
    {
        depth.checked = false;
    }

    onModelChanged:
    {
        if (model)
        {
            model.quickfilters.filterChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }

    function updateViewFromModel()
    {
        if (model && model.quickfilters && model.quickfilters.qualityFilter)
        {
            depth.model = model.quickfilters.qualityFilter.depth;
            root.enabled = model.quickfilters.qualityFilter.isVisible();
        }
    }

    content: QuickFilterFieldControl
    {
        id: depth
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
