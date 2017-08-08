import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../Framework"
import "../Regovar"

Rectangle
{
    id: root

    color: Regovar.theme.backgroundColor.main

    FontLoader { id: iconsFont; source: "../Icons.ttf" }

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
            font.family: iconsFont.name
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

            text: "Olivier Dedolo"
        }

        Text
        {
            id: serverIcon
            anchors.top: header.top
            anchors.right: serverLabel.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: iconsFont.name
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
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 100
        anchors.topMargin: 50

        Component.onCompleted: text = regovar.searchRequest

        onEditingFinished:
        {
            regovar.searchRequest = text;
            // Regovar.mainMenu.selectedIndex=[1,0,-1];
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
        anchors.bottomMargin: 10


        RowLayout
        {
            spacing: 30

            anchors.fill: panel
            property real columnWidth
            onWidthChanged: columnWidth = (width - 290) / 4
            Component.onCompleted: columnWidth = (width - 290) / 4

            // Project
            ColumnLayout
            {
                spacing: 10
                Layout.fillHeight: true
                width: panel.columnWidth


                Text
                {
                    font.pixelSize: 22
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.verticalCenter
                    height: 30
                    text: qsTr("+ New project")
                }

                Text
                {
                    font.pixelSize: 22
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.verticalCenter
                    height: 30
                    text: qsTr("Last projects")
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
                                ListElement { name: "Project 1" }
                                ListElement { name: "Project 2" }
                                ListElement { name: "Project 3" }
                            }

                            Row
                            {
                                Text
                                {
                                    width: 30
                                    font.pixelSize: 12
                                    font.family: iconsFont.name
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    text: "c"
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
                width: panel.columnWidth


                Text
                {
                    font.pixelSize: 22
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.verticalCenter
                    height: 30
                    text: qsTr("+ New analysis")
                }

                Text
                {
                    font.pixelSize: 22
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.verticalCenter
                    height: 30
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
                        anchors.margins: 5
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
                                    width: 30
                                    font.pixelSize: 12
                                    font.family: iconsFont.name
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    text: "I"
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

            // Subject
            ColumnLayout
            {
                spacing: 10
                Layout.fillHeight: true
                width: panel.columnWidth


                Text
                {
                    font.pixelSize: 22
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.verticalCenter
                    height: 30
                    text: qsTr("+ New subject")
                }

                Text
                {
                    font.pixelSize: 22
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.verticalCenter
                    height: 30
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
                        anchors.margins: 5
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
                                    width: 30
                                    font.pixelSize: 12
                                    font.family: iconsFont.name
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    text: "b"
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

            // Events
            ColumnLayout
            {
                spacing: 10
                Layout.fillHeight: true
                width: panel.columnWidth


                Text
                {
                    height: 30
                }
                Text
                {
                    font.pixelSize: 22
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.verticalCenter
                    height: 30
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
                                ListElement { date: "2017-06-25 14h56"; name: "Pause analysis \"Hugodims\""; icon:"m"; color:"orange" }
                                ListElement { date: "2017-06-25 14h56"; name: "Project 2"; icon:""; color:"" }
                            }

                            Row
                            {
                                Text
                                {
                                    width: 50
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
                                    font.family: iconsFont.name
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
        }
    }
}
