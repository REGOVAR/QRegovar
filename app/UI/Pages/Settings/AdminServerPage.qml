import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"
import "../../Charts"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model

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

        spacing: 20


        // ===== Monitoring Section =====
        Row
        {
            height: Regovar.theme.font.boxSize.header

            Text
            {
                width: Regovar.theme.font.boxSize.header
                height: Regovar.theme.font.boxSize.header
                text: ":"

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
                text: qsTr("Server status")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
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
                    x: 10
                    y: 30
                    width: 180
                    height: 180

                    value: 42.5
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
                        Layout.alignment: Qt.AlignRight
                        text: "8"
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
                        Layout.alignment: Qt.AlignRight
                        text: "8"
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
                        Layout.alignment: Qt.AlignRight
                        text: "8"
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
                    x: 10
                    y: 30
                    width: 180
                    height: 180

                    value: 100

                   // needleColor: Regovar.theme.primaryColor.back.normal
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
                        Layout.alignment: Qt.AlignRight
                        text: "32 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "(62%) 28.5 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "(12%) 7.8 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "(5.5%) 5.1 Go"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
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
                        Layout.alignment: Qt.AlignRight
                        text: "32 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "(62%) 28.5 Go"
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
                    x: 10
                    y: 30
                    width: 180
                    height: 180

                    danger: 85
                    value: 89.4
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
                        text: qsTr("DISK")
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
                        Layout.alignment: Qt.AlignRight
                        text: "8 To"
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
                        Layout.alignment: Qt.AlignRight
                        text: "(55%) 4.2 To"
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
                        Layout.alignment: Qt.AlignRight
                        text: "46 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "46 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "46 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "46 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "46 Go"
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
                        Layout.alignment: Qt.AlignRight
                        text: "46 Go"
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
            height: Regovar.theme.font.boxSize.header

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
            Rectangle
            {
                Layout.minimumWidth: 300
                Layout.fillHeight: true
                border.width: 1
                border.color: Regovar.theme.boxColor.border
                color: Regovar.theme.boxColor.back

                GridLayout
                {
                    x: 5
                    y: 5
                    width: parent.width - 10
                    columns: 2
                    rows: 5
                    rowSpacing: 5
                    columnSpacing: 5

                    Text
                    {
                        text: qsTr("Total size")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        Layout.alignment: Qt.AlignRight
                        text: "8 Go"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Hg19 size")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        Layout.alignment: Qt.AlignRight
                        text: "4 Go"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Hg38 size")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        Layout.alignment: Qt.AlignRight
                        text: "1 Go"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Regovar")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        Layout.alignment: Qt.AlignRight
                        text: "675 Mo"
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
                    }

                    Text
                    {
                        Layout.columnSpan: 2
                        text: qsTr("Clear working table:")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    ComboBox
                    {
                        Layout.fillWidth: true
                        model: ["wt_1 : Trio BIL_L-2017.09.29", "wt_1 : Trio BIL_L-2017.09.29", "wt_1 : Trio BIL_L-2017.09.29"]
                    }
                    Button
                    {
                        text: qsTr("Clear")
                    }
                    Text
                    {
                        Layout.columnSpan: 2
                        text: qsTr("Clear will free : 768.9 Mo")
                        font.pixelSize: Regovar.theme.font.size.small
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            TreeView
            {
                Layout.fillWidth: true
                Layout.fillHeight: true

                TableViewColumn
                {
                    role: "section"
                    title: "Section"
                }
                TableViewColumn
                {
                    role: "name"
                    title: "Table"
                }
                TableViewColumn
                {
                    role: "rowscount"
                    title: "Rows estimation"
                }
                TableViewColumn
                {
                    role: "size"
                    title: "Data Size"
                }
                TableViewColumn
                {
                    role: "ext_size"
                    title: "Real Size"
                }
            }
        }




        // ===== Process Section =====
        Row
        {
            height: Regovar.theme.font.boxSize.header

            Text
            {
                width: Regovar.theme.font.boxSize.header
                height: Regovar.theme.font.boxSize.header
                text: "7"

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
                text: qsTr("Process")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }
    }
}
