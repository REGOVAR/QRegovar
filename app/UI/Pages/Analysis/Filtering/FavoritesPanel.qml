import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"


Rectangle
{
    id: root
    anchors.fill: parent
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        filterList.model = model.filters;
    }

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
                        text: (model.modelData.total_variants == null) ? "?" : model.modelData.total_variants
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: filterItemRoot.currentColor = Regovar.theme.secondaryColor.back.normal
                        onExited: filterItemRoot.currentColor = (index % 2 == 0) ? "transparent" : Regovar.theme.backgroundColor.main
                        cursorShape: Qt.PointingHandCursor

                        onClicked: filterList.currentIndex = index

                        onDoubleClicked: root.loadFilter(model.modelData)
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
                text: qsTr("Load")
                onClicked: root.loadFilter(filterList.model[filterList.currentIndex])
            }
        }
    }
    function loadFilter(filter)
    {
        console.log("Load filter " + filter.name + "(" + filter.id + ")");
        root.model.loadFilter(filter);
    }
}
