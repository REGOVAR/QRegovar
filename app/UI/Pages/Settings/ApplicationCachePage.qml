import QtQuick 2.9
import QtQuick.Layouts 1.3


import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model
    property bool componentReady: false


    Component.onCompleted:
    {
        cacheDir.text = regovar.filesManager.cacheDir;
        cacheMaxSize.value = regovar.filesManager.cacheMaxSize;
        cacheMaxSizeLabel.text = value + " Go";
        root.refreshCacheStats();
        componentReady = true;
    }

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            text: qsTr("Local cache settings")
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
        }
        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }
    }

    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("Regovar application settings. Note that your settings are saved on this computer only. You will need to restart the application to apply your settings.")
    }

    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        rowSpacing: 10
        columns:2

        // Cache location
        Text
        {
            Layout.fillWidth: true
            Layout.row: 0
            Layout.column: 0
            Layout.columnSpan: 2
            height: Regovar.theme.font.boxSize.title
            elide: Text.ElideRight
            text: qsTr("Cache directory")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Rectangle
        {
            Layout.row: 1
            Layout.column: 0
            color: "transparent"
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        Text
        {
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("Set the folder of this computer where files will be downloaded. Let empty to use default OS application cache directory.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }

        TextField
        {
            id: cacheDir
            Layout.row: 2
            Layout.column: 1
            Layout.fillWidth: true
            width: parent.width
            placeholderText: qsTr("Let empty to use default OS application cache directory")
        }

        Rectangle
        {
            Layout.row: 3
            Layout.column: 0
            color: "transparent"
            width: 10
            height: 10
        }


        // Cache limit
        Text
        {
            Layout.row: 4
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title
            elide: Text.ElideRight
            text: qsTr("Cache size limit")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Text
        {
            Layout.row: 5
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("Set the maximum size allowed for the cache folder (Older cached files will be automatically deleted when folder size limit is reach.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }

        Row
        {
            Layout.row: 6
            Layout.column: 1
            Layout.fillWidth: true
            Layout.minimumHeight: Regovar.theme.font.boxSize.normal
            spacing: 10

            Rectangle
            {
                color: "transparent"
                width: 400
                height: Regovar.theme.font.boxSize.normal

                Rectangle
                {
                    color: Regovar.theme.primaryColor.back.normal
                    width: 2
                    height: parent.height
                    x: Math.round(100 * (parent.width / cacheMaxSize.maximumValue)) + 5
                }

                Slider
                {
                    id: cacheMaxSize
                    maximumValue: 1000
                    minimumValue: 1
                    stepSize: 1
                    onValueChanged:
                    {
                        if (componentReady)
                        {
                            cacheMaxSizeLabel.text = value + " Go";
                            regovar.filesManager.cacheMaxSize = value;
                        }
                    }
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text
            {
                id: cacheMaxSizeLabel
                text: ""
            }
        }


        Row
        {
            Layout.row: 7
            Layout.column: 1
            spacing: 10
            ButtonIcon
            {
                Layout.rowSpan: 2
                Layout.alignment: Qt.AlignTop
                text: qsTr("Clear cache !")
                icon: "h"
                onClicked:
                {
                    regovar.filesManager.clearCache();
                    root.refreshCacheStats();
                }
            }
            Text
            {
                id: cacheCurrentSize
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }


        Rectangle
        {
            Layout.row: 8
            Layout.column: 1
            color: "transparent"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }


    function refreshCacheStats()
    {
        var current = regovar.filesManager.cacheSize;
        if (current > 0)
            cacheCurrentSize.text = qsTr("Total size") + ": " + regovar.sizeToHumanReadable(current, current);
        else
            cacheCurrentSize.text = qsTr("Empty");
    }
}
