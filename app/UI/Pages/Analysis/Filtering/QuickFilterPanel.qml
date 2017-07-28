import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "Quickfilter"

ColumnLayout
{
    id: root
    spacing: 10

    Text
    {
        text: qsTr("Transmission")
        font.pixelSize: Regovar.theme.font.size.header
        color: Regovar.theme.primaryColor.back.dark
    }

    TransmissionQuickForm
    {

    }

    RowLayout
    {
        Layout.fillWidth: true

        Button
        {
            text: qsTr("Clear")
            onClicked:
            {
                regovar.currentQuickFilters.clear();
                regovar.currentFilteringAnalysis.setFilter(regovar.currentQuickFilters.getFilter());
                regovar.currentFilteringAnalysis.refresh();
            }
        }
        Button
        {
            text: qsTr("Apply")
            onClicked:
            {
                regovar.currentFilteringAnalysis.setFilter(regovar.currentQuickFilters.getFilter());
                regovar.currentFilteringAnalysis.refresh();
            }
        }
        Button
        {
            text: qsTr("Save")
        }
    }
}
