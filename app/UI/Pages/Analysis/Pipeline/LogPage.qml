import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../../../Regovar"
import "../../../Framework"

Rectangle
{
    id: root
    anchors.fill: parent
    color: Regovar.theme.backgroundColor.alt
    property RemoteLogModel model
    onModelChanged:
    {
        if (model)
        {
            root.model.dataChanged.connect(updateLog);
            root.model.searchChanged.connect(updateSearchSelection);
        }
        updateLog();
    }
    Component.onDestruction:
    {
        root.model.dataChanged.disconnect(updateLog);
        root.model.searchChanged.disconnect(updateSearchSelection);
    }

    Rectangle
    {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 1
        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 1
        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Regovar.theme.boxColor.border
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        RowLayout
        {
            Layout.fillWidth: true
            spacing: 10

            TextField
            {
                Layout.fillWidth: true

                property string formerSearch: ""
                iconLeft: "z"
                displayClearButton: true
                text: regovar.searchRequest
                placeholder: qsTr("Search in this log...")
                onEditingFinished:
                {
                    if (formerSearch != text && text != "")
                    {
                        root.model.search(text);
                        regovar.search(text);

                        formerSearch = text;
                        updateSearchSelection();
                    }
                }
            }

            IconButton
            {

                text: "u"
                tooltip: qsTr("Jump to the previous result")
                onClicked: jumpToNearestMatch(-1)
            }
            IconButton
            {
                text: "v"
                tooltip: qsTr("Jump to the next result")
                onClicked: jumpToNearestMatch(1)
            }
        }

        TextArea
        {
            id: logText
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: root.model.text
            cursorPosition: root.model.cursorPosition
            font.family: "monospace"
            font.pixelSize: Regovar.theme.font.size.normal
            colorText: "grey"
            colorBack: "black"
        }

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 10
            Text
            {
                id: logSize
                Layout.fillWidth: true
            }

            ButtonInline
            {
                text: "Refresh"
                enabled: !autoRefresh.checked
            }
            CheckBox
            {
                id: autoRefresh
                text: "Auto refresh (5s)"
            }
        }
    }

    function updateLog()
    {
        if (root.model)
        {
            logText.text = root.model.text;
            logSize.text = regovar.formatFileSize(root.model.size);
            logText.cursorPosition = root.model.cursorPosition;
        }
    }

    function jumpToNearestMatch(direction)
    {
        if (root.model.searchResult.length>0)
        {
            var nearestId = -1
            var previousDistance=-1;
            for (var idx=0; idx < root.model.searchResult.length; idx++)
            {
                var dist = Math.abs(logText.cursorPosition - root.model.searchResult.length[idx]);
                if (nearestId == -1)
                {
                    previousDistance = dist;
                }
                else if (previousDistance < dist)
                {
                    break;
                }
                nearestId = idx;
            }

            updateSearchSelection();
        }
    }


    function updateSearchSelection()
    {
        logText.cursorPosition = root.model.cursorPosition;
        logText.moveCursorSelection(logText.cursorPosition + root.model.searchPattern.length);
    }
}
