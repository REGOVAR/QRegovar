import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "Quickfilter"

ColumnLayout
{
    id: root


    Text
    {
        text: qsTr("Quick filters")
        elide: Text.ElideRight
        font.pixelSize: Regovar.theme.font.size.header
        color: Regovar.theme.primaryColor.back.dark
        Layout.fillWidth: true
    }

    TransmissionQuickForm
    {
        Layout.fillWidth: true

    }
    TransmissionQuickForm
    {
        Layout.fillWidth: true

    }
    TransmissionQuickForm
    {
        Layout.fillWidth: true

    }



    RowLayout
    {
        Layout.fillWidth: true

        Button
        {
            text: qsTr("Clear")
            onClicked:
            {
                regovar.currentFilteringAnalysis.quickfilters.clear();
                regovar.currentFilteringAnalysis.setFilter(regovar.currentFilteringAnalysis.quickfilters.getFilter());
                regovar.currentFilteringAnalysis.results.refresh();
            }
        }
        Button
        {
            text: qsTr("Apply")
            onClicked:
            {
                regovar.currentFilteringAnalysis.setFilter(regovar.currentFilteringAnalysis.quickfilters.getFilter());
                regovar.currentFilteringAnalysis.results.refresh();
            }
        }
        Button
        {
            text: qsTr("Save")
        }
    }
}
