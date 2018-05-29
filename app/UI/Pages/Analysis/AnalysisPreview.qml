import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Item
{
    id: root
    property Analysis model

    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        columns: 3
        rowSpacing: 10
        columnSpacing: 10

        Text
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
            text: model ? model.name : ""
        }

        Text
        {
            height: Regovar.theme.font.boxSize.header
            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
            font.family: Regovar.theme.icons.name
            text: model ? "H" : ""
        }
        Text
        {
            height: Regovar.theme.font.boxSize.header
            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
            text: model ? regovar.formatDate(model.updateDate) : ""
        }

        Rectangle
        {
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: 3
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            Text
            {
                anchors.centerIn: parent
                text: qsTr("Not yet implemented")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.disable
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
