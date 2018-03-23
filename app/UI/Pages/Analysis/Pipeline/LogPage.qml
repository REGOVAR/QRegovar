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

                iconLeft: "z"
                displayClearButton: true
                text: regovar.searchRequest
                placeholder: qsTr("Search in this log...")
                onTextChanged:
                {
                    root.model.search(text);
                    updateSearchSelection();

                    if (root.model.searchResult.length > 0)
                    {
                        nextButton.enabled = true;
                        previousButton.enabled = true;
                    }
                    else
                    {
                        nextButton.enabled = false;
                        previousButton.enabled = false;
                    }
                }
                Keys.onPressed:
                {
                    if (event.key == Qt.Key_F3) jumpToNearestMatch(1);
                    if (event.key == Qt.Key_F3 && (event.modifiers == Qt.ShiftModifier))
                        jumpToNearestMatch(-1);
                }
            }

            IconButton
            {
                id: previousButton
                text: "v"
                tooltip: qsTr("(Shift+F3) Jump to the previous result")
                onClicked: jumpToNearestMatch(-1)
                enabled: false
            }
            IconButton
            {
                id: nextButton
                text: "u"
                tooltip: qsTr("(F3) Jump to the next result")
                onClicked: jumpToNearestMatch(1)
                enabled: false
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
            colorText: "lightgrey"
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
                enabled: false
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

            // Find the nearest matching position
            var nearestIdx = 0
            var currentPos = logText.selectionStart;
            var previousDistance = Math.abs(currentPos - root.model.searchResult[0]);
            var resultsCount = root.model.searchResult.length;

            if (root.model.searchResult.length>1)
            {
                for (var idx=1; idx<resultsCount; idx++)
                {
                    var dist = Math.abs(currentPos - root.model.searchResult[idx]);
                    if (previousDistance < dist)
                    {
                        break;
                    }
                    previousDistance = dist;
                    nearestIdx = idx;
                }
            }

            // Get new index according to the direction
            var newIdx;
            if (previousDistance == 0)
            {
                newIdx =  nearestIdx + direction;
            }
            else if (direction == -1)
            {
                if (root.model.searchResult[nearestIdx] < currentPos)
                {
                    newIdx = nearestIdx;
                }
                else
                {
                     newIdx = nearestIdx - 1;
                }
            }
            else if (direction == 1)
            {
                if (root.model.searchResult[nearestIdx] > currentPos)
                {
                    newIdx = nearestIdx;
                }
                else
                {
                     newIdx = nearestIdx + 1;
                }
            }

            // Update current position and selection
            newIdx = newIdx == -1 ? resultsCount - 1 : newIdx % resultsCount;
            root.model.cursorPosition = root.model.searchResult[newIdx];
            updateSearchSelection();
        }
    }


    function updateSearchSelection()
    {
        logText.cursorPosition = root.model.cursorPosition;
        logText.moveCursorSelection(logText.cursorPosition + root.model.searchPattern.length);

    }
}
