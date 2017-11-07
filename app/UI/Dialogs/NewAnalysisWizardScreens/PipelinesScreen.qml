import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Choose which pipeline to use to do your analysis among the list below.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }

    Text
    {
        id: title
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        text: qsTr("Pipelines availables")
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.frontColor.normal
    }

    SplitView
    {
        anchors.top: title.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Rectangle
        {
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            color: "transparent"

            Rectangle
            {
                anchors.fill: parent
                anchors.rightMargin: 5
                color: Regovar.theme.boxColor.back
                border.width: 1
                border.color: Regovar.theme.boxColor.border

                ListView
                {
                    id: inputsList
                    clip: true
                    anchors.fill: parent
                    anchors.margins: 1
                    model: [{"title": "Hugodims (v1)"}, {"title": "Niourk (v2.7)"}, {"title": "Dpni (v3)"}, {"title": "Niourk (v1.9)"}, {"title": "Niourk (v1.8)"}]
                    delegate: Rectangle
                    {
                        width: inputsList.width
                        height: Regovar.theme.font.boxSize.normal
                        color: index % 2 == 0 ? Regovar.theme.backgroundColor.main : "transparent"

                        Row
                        {
                            Text
                            {
                                height: Regovar.theme.font.boxSize.normal
                                width: Regovar.theme.font.boxSize.small
                                text: index < 2 ? "D" : ""
                                font.family: Regovar.theme.icons.name
                                font.pixelSize: Regovar.theme.font.size.small
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text
                            {
                                text: modelData.title
                                height: Regovar.theme.font.boxSize.normal
                                font.pixelSize: Regovar.theme.font.size.small
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
        }

        Rectangle
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            color: "transparent"

            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 5

                color: Regovar.theme.boxColor.back
                border.width: 1
                border.color: Regovar.theme.boxColor.border

                Rectangle
                {
                    id: descriptionHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 1
                    height: Regovar.theme.font.boxSize.title
                    color:  Regovar.theme.backgroundColor.main


                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 10

                        Text
                        {
                            Layout.minimumWidth: Regovar.theme.font.boxSize.title
                            Layout.maximumWidth: Regovar.theme.font.boxSize.title
                            height: Regovar.theme.font.boxSize.title
                            text: "J"
                            font.family: Regovar.theme.icons.name
                            font.pixelSize: Regovar.theme.font.size.title
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: Regovar.theme.primaryColor.front.light
                        }
                        Text
                        {
                            height: Regovar.theme.font.boxSize.title
                            text: "Hugodims (v1.0)"
                            elide: Text.ElideRight
                            font.pixelSize: Regovar.theme.font.size.header
                            verticalAlignment: Text.AlignVCenter
                            color: Regovar.theme.primaryColor.front.light
                        }

                        Text
                        {
                            Layout.alignment: Qt.AlignRight
                            height: Regovar.theme.font.boxSize.title
                            text: "D"
                            font.family: Regovar.theme.icons.name
                            font.pixelSize: Regovar.theme.font.size.title
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: Regovar.theme.primaryColor.front.light
                        }
                    }
                }


                Text
                {
                    anchors.top: descriptionHeader.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    text: "No description available"
                    font.pixelSize: Regovar.theme.font.size.small
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.disable
                }
            }
        }
    }
}
