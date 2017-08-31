import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "Quickfilter"

Rectangle
{
    id: root
    property FilteringAnalysis model

    color: Regovar.theme.backgroundColor.main

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        RowLayout
        {
            id: header
            Layout.fillWidth: true
            anchors.top: parent.top
            anchors.topMargin: 5

            Text
            {
                text: qsTr("Quick filter")
                height: Regovar.theme.font.boxSize.header
                Layout.fillWidth: true
                anchors.left: parent.left
                anchors.leftMargin: 5
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                elide: Text.ElideRight
            }

            Rectangle
            {
                id: loadFilterButton
                height: Regovar.theme.font.boxSize.header
                width: loadFilterButtonLayout.width
                property bool mouseHover: false

                color: "transparent"

                Row
                {
                    id: loadFilterButtonLayout

                    Text
                    {
                        text: "D"
                        height: Regovar.theme.font.boxSize.header
                        width: Regovar.theme.font.boxSize.header
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.header
                        color: loadFilterButton.mouseHover ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.normal
                        font.family: Regovar.theme.icons.name
                    }
                    Text
                    {
                        text: loadFilterPanel.visible ? "|" : "["
                        height: Regovar.theme.font.boxSize.header
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.header
                        color: loadFilterButton.mouseHover ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.normal
                        font.family: Regovar.theme.icons.name
                    }
                }

                MouseArea
                {
                    anchors.fill: loadFilterButton
                    hoverEnabled: true
                    onEntered: loadFilterButton.mouseHover = true
                    onExited: loadFilterButton.mouseHover = false
                    onClicked: loadFilterPanel.visible = !loadFilterPanel.visible
                    cursorShape: loadFilterButton.mouseHover ? Qt.PointingHandCursor : Qt.ArrowCursor;
                }
            }
        }
        Rectangle
        {
            Layout.fillWidth: true
            anchors.topMargin: 5
            height: 1
            color: Regovar.theme.primaryColor.back.light
        }


        ScrollView
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                Rectangle { width: root.width; height: 5; color: "transparent" }
                TransmissionQuickForm { width: root.width; model: root.model; }
                QualityQuickForm { width: root.width; model: root.model; }
                PositionQuickFilter { width: root.width; model: root.model; }
                TypeQuickFilter { width: root.width; model: root.model; }
                FrequenceQuickFilter { width: root.width; model: root.model; }
                SilicoPredQuickFilter { width: root.width; model: root.model; }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: Regovar.theme.primaryColor.back.light
        }


        ButtonWelcom
        {
            Layout.fillWidth: true
            text: qsTr("Apply current filter")
            iconText: "x"
            onClicked:
            {
                model.setFilter(model.quickfilters.getFilter());
                model.results.reset();
            }
        }
        ButtonWelcom
        {
            Layout.fillWidth: true
            text: qsTr("Save current filter")
            iconText: "5"
            onClicked:
            {
                model.emitDisplayFilterSavingFormPopup();
            }
        }
    }



    Rectangle
    {
        id: loadFilterPanel
        visible: false
        anchors.fill: parent
        anchors.topMargin: header.height + 1
        color: Regovar.theme.backgroundColor.main

        MouseArea { anchors.fill: parent }


        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 10

            Text
            {
                text: qsTr("Load saved filter")
                height: Regovar.theme.font.boxSize.header
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                elide: Text.ElideRight
            }

            ListView
            {
                list.model: 10
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Button
            {
                anchors.right: parent.right
                text: qsTr("Cancel")
                onClicked: loadFilterPanel.visible = false
            }
        }
    }
}
