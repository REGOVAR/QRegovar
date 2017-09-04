import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../Framework"
import "../Regovar"

Rectangle
{
    id: root
    property QtObject model

    color: Regovar.theme.backgroundColor.main


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
            id: userIcon
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.icons.name
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter

            text: "b"
        }
        Text
        {
            id: userLabel
            anchors.top: header.top
            anchors.left: userIcon.right
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter

            text: "Aurélie BECKER"
        }

        Text
        {
            id: serverIcon
            anchors.top: header.top
            anchors.right: serverLabel.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.icons.name
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter

            text: "F"
        }
        Text
        {
            id: serverLabel
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter

            text: "https://regovar.chu-nancy.fr"
        }
    }


    Image
    {
        id: logo
        source: "qrc:/regovar.png"
        sourceSize.height: 125
        anchors.top: header.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: header.horizontalCenter
    }

    TextField
    {
        id: searchBar
        anchors.top: logo.bottom
        anchors.horizontalCenter: root.horizontalCenter
        anchors.margins: 10
        width: 600
        anchors.topMargin: 50


        Component.onCompleted: text = regovar.searchRequest

        onEditingFinished:
        {
            if (text != "" && root.visible)
            {
                regovar.search(text);
                Regovar.menuModel.selectedIndex=[1,-1,-1];
            }
        }

        placeholderText: qsTr("Search anything, project, sample, phenotype, analysis, variant, report, ..")
        focus: true
    }

    Rectangle
    {
        id: panel
        color: "transparent"

        anchors.top: searchBar.bottom
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 100
        anchors.topMargin: 10
        anchors.bottomMargin: 10


        property real columnsAvailableWidth
        onWidthChanged: columnsAvailableWidth = width - 260 // 260 = 2*100 + 2*30 = margin + columns spacing
        Component.onCompleted: columnsAvailableWidth = width - 260 // 260 = 2*100 + 2*30 = margin + columns spacing

        RowLayout
        {
            id: newButtonsRow
            anchors.horizontalCenter: panel.horizontalCenter
            anchors.top: panel.top
            height: 100
            spacing: 30

            ButtonWelcom
            {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("New project")
            }
            ButtonWelcom
            {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("New analysis")
            }
            ButtonWelcom
            {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("New subject")
            }
        }



        Row
        {
            spacing: 30

            anchors.top: newButtonsRow.bottom
            anchors.left: panel.left
            anchors.right: panel.right
            anchors.bottom: panel.bottom

            // Events
            ColumnLayout
            {
                spacing: 10
                Layout.fillHeight: true
                width: panel.columnsAvailableWidth / 2


                Text
                {
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.header
                    text: qsTr("Last events")
                }

                Rectangle
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"

                    ColumnLayout
                    {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 10

                        Repeater
                        {
                            model : ListModel
                            {
                                ListElement { date: "2017-06-25 14h56"; name: "Article published"; icon:""; color:"" }
                                ListElement { date: "2017-06-25 14h56"; name: "Start new analysis \"Hugodims\""; icon:""; color:"" }
                                ListElement { date: "2017-06-25 14h56"; name: "Pause analysis \"Hugodims\""; icon:"m"; color:"red" }
                                ListElement { date: "2017-06-25 14h56"; name: "Project 2 creation"; icon:""; color:"" }
                            }

                            Row
                            {
                                Text
                                {
                                    width: 120
                                    font.pixelSize: 12
                                    font.family: Regovar.theme.font.familly
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.left
                                    text: date
                                    color: Regovar.theme.frontColor.disable
                                }
                                Text
                                {
                                    width: 30
                                    font.pixelSize: 12
                                    font.family: Regovar.theme.icons.name
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    text: icon
                                    color: color
                                }
                                Text
                                {
                                    font.pixelSize: 12
                                    font.family: Regovar.theme.font.familly
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    text: name
                                }
                            }
                        }

                        Rectangle
                        {
                            color: "transparent"
                            Layout.fillHeight: true
                        }
                    }
                }
            }

            // Analysis
            ColumnLayout
            {
                spacing: 10
                Layout.fillHeight: true
                width: panel.columnsAvailableWidth/4
                Layout.alignment: Qt.AlignLeft


                Text
                {
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.header
                    text: qsTr("Last analysis")
                }

                Rectangle
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"

                    ColumnLayout
                    {
                        anchors.fill: parent
                        spacing: 10

                        Repeater
                        {
                            model : ListModel
                            {
                                ListElement { name: "Analysis 1" }
                                ListElement { name: "Analysis 2" }
                                ListElement { name: "Analysis 3" }
                                ListElement { name: "Analysis 4" }
                                ListElement { name: "Analysis 5" }
                            }

                            Row
                            {
                                Text
                                {
                                    width: Regovar.theme.font.boxSize.control
                                    font.pixelSize: Regovar.theme.font.size.control
                                    font.family: Regovar.theme.icons.name
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    text: "I"
                                }
                                Text
                                {
                                    font.pixelSize: Regovar.theme.font.size.control
                                    font.family: Regovar.theme.font.familly
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    text: name
                                }
                            }
                        }

                        Rectangle
                        {
                            color: "transparent"
                            Layout.fillHeight: true
                        }
                    }
                }
            }

            // Subject
            ColumnLayout
            {
                spacing: 10
                Layout.fillHeight: true
                width: panel.columnsAvailableWidth/4
                Layout.alignment: Qt.AlignLeft


                Text
                {
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.header
                    text: qsTr("Last subjects")
                }

                Rectangle
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"

                    ColumnLayout
                    {
                        anchors.fill: parent
                        spacing: 10

                        Repeater
                        {
                            model : ListModel
                            {
                                ListElement { name: "Michel Dupont (MD-45-77)" }
                                ListElement { name: "Jeannette Pignon (JP-02-45)" }
                                ListElement { name: "François Jacquet (FJ-55-63)" }
                            }

                            Row
                            {
                                Text
                                {
                                    width: Regovar.theme.font.boxSize.control
                                    font.pixelSize: Regovar.theme.font.size.control
                                    font.family: Regovar.theme.icons.name
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    text: "b"
                                }
                                Text
                                {
                                    font.pixelSize: Regovar.theme.font.size.control
                                    font.family: Regovar.theme.font.familly
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    text: name
                                }
                            }
                        }

                        Rectangle
                        {
                            color: "transparent"
                            Layout.fillHeight: true
                        }
                    }
                }
            }


        }
    }
}
