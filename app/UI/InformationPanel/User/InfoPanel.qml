import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"


Item
{
    id: root

    property var model

    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        columns: 2
        columnSpacing: 10
        rowSpacing: 5

        Rectangle
        {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            radius: 2

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 5


                Text
                {
                    text: qsTr("Is active") + ":"
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    text: model.isActive ? qsTr("Yes") : qsTr("No")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Item
                {
                    height: 10
                    width: 100
                }

                Text
                {
                    text: qsTr("Is admin") + ":"
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    text: model.isAdmin ? qsTr("Yes") : qsTr("No")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Item
                {
                    height: 10
                    Layout.fillWidth: true
                }

            }
        }


        Text
        {
            text: qsTr("Lastname")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        Text
        {
            text: model.lastname
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }


        Text
        {
            text: qsTr("Firstname")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        Text
        {
            text: model.firstname
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }


        Text
        {
            text: qsTr("Email")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        Text
        {
            text: model.email
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }


        Text
        {
            text: qsTr("Location")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        Text
        {
            text: model.location
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }


        Text
        {
            text: qsTr("Function")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        Text
        {
            text: model.function
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }

        Item
        {
            Layout.columnSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
