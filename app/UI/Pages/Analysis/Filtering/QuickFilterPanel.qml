import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "Quickfilter"

ColumnLayout
{
    id: root

    property FilteringAnalysis model

    Text
    {
        text: qsTr("Quick filters")
        elide: Text.ElideRight
        font.pixelSize: Regovar.theme.font.size.header
        color: Regovar.theme.primaryColor.back.dark
        Layout.fillWidth: true
    }

    ScrollView
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        Column
        {
            TransmissionQuickForm { width: root.width; model: root.model }
            QualityQuickForm { width: root.width; model: root.model }
            PositionQuickFilter { width: root.width; model: root.model }
            TypeQuickFilter { width: root.width; model: root.model }
            FrequenceQuickFilter { width: root.width; model: root.model }
            SilicoPredQuickFilter { width: root.width; model: root.model }
        }
    }


    RowLayout
    {
        Layout.fillWidth: true

        Button
        {
            text: qsTr("Clear")
            onClicked:
            {
                model.quickfilters.clear();
                model.setFilter(model.quickfilters.getFilter());
                model.results.reset();
            }
        }
        Button
        {
            text: qsTr("Apply")
            onClicked:
            {
                model.setFilter(model.quickfilters.getFilter());
                model.results.reset();
            }
        }
        Button
        {
            text: qsTr("Save")
        }
    }
}
