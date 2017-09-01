import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "AdvancedFilter"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        if (root.model != null)
        {
            advancedFilterTextEditor.text = root.model.filter
            advancedFilterEditor.model = root.model.filterJson
        }
    }

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
                text: qsTr("Advanced filter")
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

            LogicalBlock
            {
                id:advancedFilterEditor
            }
        }

//        TextArea
//        {
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            id: advancedFilterTextEditor
//            // text: root.model.filter
//        }

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

            Rectangle
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                color: Regovar.theme.boxColor.back
                border.width: 1
                border.color: Regovar.theme.boxColor.border

                ListView
                {
                    id: filterList
                    anchors.fill: parent
                    anchors.margins: 1
                    clip:true
                    ScrollBar.vertical: ScrollBar { }

                    delegate: Rectangle
                    {
                        id: filterItemRoot
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 25
                        color: (filterList.currentIndex == index) ? Regovar.theme.secondaryColor.back.light : currentColor

                        property var currentColor : (index % 2 == 0) ? "transparent" : Regovar.theme.backgroundColor.main


                        Text
                        {
                            id: filterItemName
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: filterItemCount.left
                            text: model.modelData.name
                        }
                        Text
                        {
                            id: filterItemCount
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            text: model.modelData.count
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: filterItemRoot.currentColor = Regovar.theme.secondaryColor.back.normal
                            onExited: filterItemRoot.currentColor = (index % 2 == 0) ? "transparent" : Regovar.theme.backgroundColor.main
                            cursorShape: Qt.PointingHandCursor

                            onClicked: filterList.currentIndex = index

                            onDoubleClicked: loadFilterPanel.loadFilter(model.modelData)
                        }
                    }
                }
            }

            Row
            {
                anchors.right: parent.right
                spacing: 10

                Button
                {
                    text: qsTr("Cancel")
                    onClicked: loadFilterPanel.visible = false
                }

                Button
                {
                    text: qsTr("Load")
                    onClicked: loadFilterPanel.loadFilter(filterList.model[filterList.currentIndex])
                }
            }
        }
        function loadFilter(filter)
        {
            console.log("Load filter " + filter.name + "(" + filter.id + ")");
            root.model.loadFilter(filter);
            loadFilterPanel.visible = false;
        }
    }
}
