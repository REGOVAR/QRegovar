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

        ColumnLayout
        {
            x:10
            y:10
            width: parent.width-30


            StatsOverview { id: statsOverview; model: root.model; Layout.fillWidth: true}
            StatsVariantClasses { id: statsVariantClasses; model: root.model; Layout.fillWidth: true }
            StatsVepConsequences { id: statsVepConsequences; model: root.model; Layout.fillWidth: true }
            StatsVepImpacts { id: statsVepImpacts; model: root.model; Layout.fillWidth: true }
            QualityFilter { id: qualFilter; model: root.model; Layout.fillWidth: true }
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
