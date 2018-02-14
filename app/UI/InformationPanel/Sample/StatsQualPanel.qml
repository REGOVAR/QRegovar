import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var model
    onModelChanged:
    {
        if (model && model.stats != null)
        {
            content.visible = true;
            content.enabled = true;
            empty.visible = false;
        }
        else
        {
            content.visible = false;
            content.enabled = false;
            empty.visible = true;
        }
    }

    ScrollView
    {
        id: content
        anchors.fill: parent

        Column
        {
            x:10
            y:10

            StatsOverview { id: statsOverview; model: root.model; width: statsVariantClasses.width }
            StatsVariantClasses { id: statsVariantClasses; model: root.model; }
            StatsVepConsequences { id: statsVepConsequences; model: root.model; }
            //StatsVepImpacts { id: statsVepImpacts; model: root.model; }
            QualityFilter { id: qualFilter; model: root.model; }
        }
    }

    Rectangle
    {
        id: empty
        anchors.fill: parent
        color: Regovar.theme.boxColor.back
        border.width: 1
        Text
        {
            anchors.centerIn: parent
            text: qsTr("Statistics not available.")
            font.pixelSize: Regovar.theme.font.size.title
            color: Regovar.theme.primaryColor.back.light
        }
    }
}
