import QtQuick 2.7
import QtQml 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtCharts 2.0
import "../../Regovar"
import "../../Framework"
import "../../Charts"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model

    property var serverData: regovar.admin.serverStatus
    onServerDataChanged: updateStatus();

    onVisibleChanged:
    {
        if (visible)
        {
            regovar.admin.getServerStatus();
        }
        else
        {
            autoRefreshCheckbox.checked = false;
        }
    }

    Timer
    {
        id: autoRefreshTimer
        interval: 1000 // 1s
        repeat: true
        running: false

        onTriggered: regovar.admin.getServerStatus(); // TODO replace by regovar.admin.refreshServerStatus();
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
            text: qsTr("Regovar server status")
            font.pixelSize: 20
            font.weight: Font.Black
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
        text: qsTr("Check database size. Allow you to clean \"working\" tables if you need to save disk space on the server.")
    }


    ColumnLayout
    {
        id: contentLayout
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        spacing: 5


        // ===== Monitoring Section =====

        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title
            color: "transparent"

            Text
            {
                width: Regovar.theme.font.boxSize.header
                height: Regovar.theme.font.boxSize.header
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: ":"

                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.title
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.primaryColor.back.normal
            }
            Text
            {
                anchors.left: parent.left
                anchors.leftMargin: Regovar.theme.font.boxSize.header
                anchors.verticalCenter: parent.verticalCenter
                height: Regovar.theme.font.boxSize.header

                elide: Text.ElideRight
                text: qsTr("Server status")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }


            CheckBox
            {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                id: autoRefreshCheckbox
                checked: autoRefreshTimer.running
                onCheckedChanged: autoRefreshTimer.running = checked
                text: ""
            }
            Text
            {
                anchors.right: autoRefreshCheckbox.left
                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("Auto refresh status")
            }

        }

        Row
        {
            width: contentLayout.width
            height: 200
            spacing: 10

            onWidthChanged:
            {
                colwidth = Math.max((contentLayout.width-20)/3, 400);
                cpuCol.width = colwidth;
                ramCol.width = colwidth;
                dskCol.width = colwidth;
            }
            property real colwidth: 400

            // ===== CPU
            Rectangle
            {
                id: cpuCol
                height: parent.height
                width: parent.colwidth
                border.width: 1
                border.color: Regovar.theme.boxColor.border
                color: Regovar.theme.boxColor.back

                CircularGauge
                {
                    id: cpuGauge
                    x: 10
                    y: 30
                    width: 180
                    height: 180

                    Behavior on value
                    {
                        NumberAnimation
                        {
                            duration : 100
                        }
                    }
                }

                GridLayout
                {
                    x: 200
                    y: 5
                    width: parent.width - 205
                    columns: 2
                    rows: 5
                    rowSpacing: 5
                    columnSpacing: 5

                    Text
                    {
                        Layout.columnSpan: 2
                        elide: Text.ElideRight
                        text: qsTr("CPU")
                        font.bold: true
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.normal
                    }

                    Text
                    {
                        text: qsTr("Core")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: cpuCore
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Virtual")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: cpuVirtual
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Frequence")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: cpuFreq
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // ===== RAM
            Rectangle
            {
                id: ramCol
                height: parent.height
                width: parent.colwidth
                border.width: 1
                border.color: Regovar.theme.boxColor.border
                color: Regovar.theme.boxColor.back

                CircularGauge
                {
                    id: ramGauge
                    x: 10
                    y: 30
                    width: 180
                    height: 180

                    Behavior on value
                    {
                        NumberAnimation
                        {
                            duration : 500
                        }
                    }
                }

                GridLayout
                {
                    x: 200
                    y: 5
                    width: parent.width - 205
                    columns: 2
                    rows: 8
                    rowSpacing: 5
                    columnSpacing: 5

                    Text
                    {
                        Layout.columnSpan: 2
                        elide: Text.ElideRight
                        text: qsTr("RAM")
                        font.bold: true
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.normal
                    }

                    Text
                    {
                        text: qsTr("Total")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: ramTotal
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Used")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: ramUsed
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Buffer")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: ramBuffer
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Cached")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: ramCached
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Rectangle
                    {
                        Layout.columnSpan: 2
                        height: 1
                        width: parent.width
                        color: Regovar.theme.primaryColor.back.normal
                    }

                    Text
                    {
                        Layout.columnSpan: 2
                        elide: Text.ElideRight
                        text: qsTr("SWAP")
                        font.bold: true
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.normal
                    }
                    Text
                    {
                        text: qsTr("Total")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: swpTotal
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Used")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: swpUsed
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // ===== DISK
            Rectangle
            {
                id: dskCol
                height: parent.height
                width: parent.colwidth
                border.width: 1
                border.color: Regovar.theme.boxColor.border
                color: Regovar.theme.boxColor.back

                CircularGauge
                {
                    id: dskGauge
                    x: 10
                    y: 30
                    width: 180
                    height: 180
                    danger: 85

                    Behavior on value
                    {
                        NumberAnimation
                        {
                            duration : 500
                        }
                    }
                }

                GridLayout
                {
                    x: 200
                    y: 5
                    width: parent.width - 205
                    columns: 2
                    rows: 5
                    rowSpacing: 5
                    columnSpacing: 5

                    Text
                    {
                        Layout.columnSpan: 2
                        elide: Text.ElideRight
                        text: qsTr("STORAGE")
                        font.bold: true
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.normal
                    }

                    Text
                    {
                        text: qsTr("Total")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: dskTotal
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Used")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: dskUsed
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Rectangle
                    {
                        Layout.columnSpan: 2
                        height: 1
                        width: parent.width
                        color: Regovar.theme.primaryColor.back.normal
                    }

                    Text
                    {
                        text: qsTr("regovar/file/")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: dskFile
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text
                    {
                        text: qsTr("regovar/temps/")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: dskTmp
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text
                    {
                        text: qsTr("regovar/cache/")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: dskCache
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text
                    {
                        text: qsTr("regovar/ext_db/")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: dskDB
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text
                    {
                        text: qsTr("regovar/pipelines/")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: dskPipe
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text
                    {
                        text: qsTr("regovar/jobs/")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: dskJobs
                        Layout.alignment: Qt.AlignRight
                        text: "-"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }


        // ===== Database Section =====
        Row
        {
            height: Regovar.theme.font.boxSize.Title

            Text
            {
                width: Regovar.theme.font.boxSize.header
                height: Regovar.theme.font.boxSize.header
                text: "B"

                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.title
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.primaryColor.back.normal
            }
            Text
            {
                height: Regovar.theme.font.boxSize.header

                elide: Text.ElideRight
                text: qsTr("Database overview")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10


            // ===== Database overview
            Column
            {
                spacing: 10
                width: 300
                Layout.fillHeight: true




                ChartView
                {
                    height: 200
                    width: parent.width
                    antialiasing: true
                    animationOptions: ChartView.AllAnimations
                    backgroundColor: Regovar.theme.backgroundColor.main // Regovar.theme.boxColor.back
                    legend.visible: false
                    margins.top: 0
                    margins.bottom: 0
                    margins.left: 0
                    margins.right: 0


                    PieSeries
                    {

                        id: pieSeries
                        PieSlice { label: "3%"; value: 8.45; labelVisible: true; id: slice1; }
                        PieSlice { label: "7%"; value: 218.77; labelVisible: true; id: slice2; }
                        PieSlice { label: "37%"; value: 402.24; labelVisible: true; id: slice3; }
                        PieSlice { label: "53%"; value: 681; labelVisible: true; id: slice4; }
                    }
                }


                Rectangle
                {
                    width: 300
                    height: databaseResumeLayout.height + 10
                    border.width: 1
                    border.color: Regovar.theme.boxColor.border
                    color: Regovar.theme.boxColor.back

                    Column
                    {
                        id: databaseResumeLayout
                        x: 5
                        y: 5
                        width: parent.width - 10


                        Rectangle
                        {
                            width: databaseResumeLayout.width
                            height: Regovar.theme.font.boxSize.normal
                            Text
                            {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Total size")
                                font.pixelSize: Regovar.theme.font.size.normal
                                color: Regovar.theme.primaryColor.back.normal
                                height: Regovar.theme.font.boxSize.normal
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }
                            Text
                            {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                id: databaseResumeTotalSize
                                Layout.alignment: Qt.AlignRight
                                text: "-"
                                font.pixelSize: Regovar.theme.font.size.normal
                                color: Regovar.theme.primaryColor.back.normal
                                height: Regovar.theme.font.boxSize.normal
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }
                        }



                        Repeater
                        {
                            id: databaseResumeRepeater


                            Rectangle
                            {
                                width: databaseResumeLayout.width
                                height: Regovar.theme.font.boxSize.normal
                                Text
                                {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: " - " + modelData.section
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    color: Regovar.theme.primaryColor.back.normal
                                    height: Regovar.theme.font.boxSize.normal
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text
                                {
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text:  modelData.size
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    color: Regovar.theme.primaryColor.back.normal
                                    height: Regovar.theme.font.boxSize.normal
                                    verticalAlignment: Text.AlignVCenter
                                }
                                MouseArea
                                {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: highlightChart(index, true)
                                    onExited: highlightChart(index, false)
                                }

                                property var slices: [slice1, slice2, slice3, slice4]
                                function highlightChart(index, hover)
                                {
                                    var slice = slices[index];
                                    slice.exploded = hover;
                                }
                            }

                        }
                    }
                }

                ComboBox
                {
                    id: databaseWorkingTables
                    width: 300

                    model: [qsTr("Clear working table:")]
                }
                Row
                {
                    spacing: 10
                    Button
                    {
                        text: qsTr("Clear")
                        enabled:  databaseWorkingTables.currentIndex > 0
                    }
                    Text
                    {
                        Layout.columnSpan: 2
                        text: databaseWorkingTables.currentIndex > 0 ? qsTr("Clear will free : 768.9 Mo") : ""
                        font.pixelSize: Regovar.theme.font.size.small
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter

                    }
                }
            }


            TableView
            {
                id: tablesTableView
                Layout.fillWidth: true
                Layout.fillHeight: true
                sortIndicatorVisible: true

                TableViewColumn
                {
                    role: "section"
                    title: qsTr("Section")
                    width: 100
                }
                TableViewColumn
                {
                    role: "table"
                    title: qsTr("Table")
                }
                TableViewColumn
                {
                    role: "count"
                    title: qsTr("Rows estimation")
                    width: 150
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Regovar.theme.font.size.normal
                            elide: Text.ElideRight
                            font.family: "monospace"
                            horizontalAlignment: Text.AlignRight
                            text: styleData.value ? Regovar.formatBigNumber(styleData.value) : "-"
                        }
                    }
                }
                TableViewColumn
                {
                    role: "size"
                    title: qsTr("Data Size")
                    width: 100
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Regovar.theme.font.size.normal
                            elide: Text.ElideRight
                            font.family: "monospace"
                            horizontalAlignment: Text.AlignRight
                            text: styleData.value ? regovar.sizeToHumanReadable(styleData.value) : "-"
                        }
                    }
                }
                TableViewColumn
                {
                    role: "realSize"
                    title: qsTr("Real Size")
                    width: 100
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Regovar.theme.font.size.normal
                            elide: Text.ElideRight
                            font.family: "monospace"
                            horizontalAlignment: Text.AlignRight
                            text: styleData.value ? regovar.sizeToHumanReadable(styleData.value) : "-"
                        }
                    }
                }
                TableViewColumn
                {
                    role: "description"
                    title: qsTr("Description")
                }
            }
        }
    }


    function updateStatus()
    {
        cpuGauge.value = serverData["cpu"]["usage"];
        cpuCore.text = serverData["cpu"]["count"];
        cpuVirtual.text = serverData["cpu"]["virtual"];
        cpuFreq.text = Regovar.round(serverData["cpu"]["freq"]/1000,1) + " GHz";

        ramGauge.value = serverData["ram"]["percent"];
        ramTotal.text  = regovar.sizeToHumanReadable(serverData["ram"]["total"]);
        ramBuffer.text = regovar.sizeToHumanReadable(serverData["ram"]["buffers"]);
        ramCached.text = regovar.sizeToHumanReadable(serverData["ram"]["cached"]);
        ramUsed.text   = regovar.sizeToHumanReadable(serverData["ram"]["used"]);
        swpTotal.text  = regovar.sizeToHumanReadable(serverData["swap"]["total"]);
        swpUsed.text   = regovar.sizeToHumanReadable(serverData["swap"]["used"]);

        dskGauge.value = serverData["disk"]["overall"]["percent"];
        dskTotal.text  = regovar.sizeToHumanReadable(serverData["disk"]["overall"]["total"]);
        dskUsed.text   = regovar.sizeToHumanReadable(serverData["disk"]["overall"]["used"]);
        dskFile.text   = regovar.sizeToHumanReadable(serverData["disk"]["files"]);
        dskTmp.text    = regovar.sizeToHumanReadable(serverData["disk"]["temp"]);
        dskCache.text  = regovar.sizeToHumanReadable(serverData["disk"]["cache"]);
        dskDB.text     = regovar.sizeToHumanReadable(serverData["disk"]["ext_db"]);
        dskPipe.text   = regovar.sizeToHumanReadable(serverData["disk"]["pipelines"]);
        dskJobs.text   = regovar.sizeToHumanReadable(serverData["disk"]["jobs"]);

        tablesTableView.model = regovar.admin.tables;
        databaseResumeTotalSize.text = regovar.sizeToHumanReadable(regovar.admin.tablesTotalSize);
        databaseResumeRepeater.model = regovar.admin.tablesSizes;
        databaseWorkingTables.model = regovar.admin.wtTables;
    }
}
