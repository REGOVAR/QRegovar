import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "../Framework"
import "../Regovar"
import "../Dialogs"
import "Browse"

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





        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }
    }


    Item
    {
        id: logo
        anchors.top: header.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: header.horizontalCenter
        height: logoImage.height
        width: logoImage.width

        Image
        {
            id: logoImage
            source: "qrc:/regovar.png"
            sourceSize.height: 125
        }

        LinearGradient
        {
            anchors.fill: parent
            start: Qt.point(0, logo.height / 3)
            end: Qt.point(0, logo.height)
            gradient: Gradient
            {
                GradientStop { position: 0.0; color: regovar.networkManager.status == 0 ? Regovar.theme.logo.color1 : Regovar.theme.frontColor.disable }
                GradientStop { position: 1.0; color: regovar.networkManager.status == 0 ? Regovar.theme.logo.color2 : Regovar.theme.frontColor.disable }
            }
            source: logoImage
        }
    }





    TextField
    {
        id: searchBar
        anchors.top: logo.bottom
        anchors.horizontalCenter: root.horizontalCenter
        anchors.margins: 10
        width: 600
        anchors.topMargin: 50
        enabled: regovar.networkManager.status == 0

        Component.onCompleted: text = regovar.searchRequest


        onEditingFinished:
        {
            if (text != "" && root.visible)
            {
                regovar.search(text);
                regovar.mainMenu.goTo(1,-1,-1);
            }
        }

        placeholder: regovar.networkManager.status == 0 ? qsTr("Search anything, sample, phenotype, analysis, variant, report...") : ""
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
                text: qsTr("New analysis")
                onClicked: regovar.openNewAnalysisWizard()
                enabled: regovar.networkManager.status == 0
            }
            ButtonWelcom
            {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("New subject")
                onClicked: regovar.openNewSubjectWizard()
                enabled: regovar.networkManager.status == 0
            }
        }


        ColumnLayout
        {
            visible: regovar.welcomIsLoading
            anchors.top: newButtonsRow.bottom
            anchors.topMargin: 10
            anchors.left: panel.left
            anchors.right: panel.right
            anchors.bottom: panel.bottom
            spacing: 30


            SplitView
            {
                id: row
                property real maxHeight: Regovar.theme.font.boxSize.header
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: maxHeight
                Layout.minimumHeight: maxHeight


                Rectangle
                {
                    id: analysesScrollArea
                    color: "transparent"
                    width: 500
                    height: parent.height
                    clip: true

                    Text
                    {
                        id: analysesHeader
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.header
                        text: qsTr("Last analyses")
                    }

                    Rectangle
                    {
                        anchors.top: analysesHeader.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        height: 1
                        color: Regovar.theme.primaryColor.back.normal
                    }



                    ScrollView
                    {
                        id: analysesColumn
                        anchors.fill: parent
                        anchors.topMargin: Regovar.theme.font.boxSize.header + 5
                        anchors.rightMargin: 10
                        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                        Column
                        {
                            onHeightChanged: row.maxHeight = Math.max(row.maxHeight, height + Regovar.theme.font.boxSize.header + 5)
                            Repeater
                            {
                                model: regovar.lastAnalyses
                                SearchResultAnalysis
                                {
                                    indent: 0
                                    width: analysesColumn.width - 10
                                    date: model.modelData.updateDate
                                    name: model.modelData.name
                                    fullpath: model.modelData.fullpath
                                    status: model.modelData.status
                                    onClicked: regovar.analysesManager.openAnalysis(model.modelData.type, model.modelData.id)
                                }
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: subjectScrollArea
                    color: "transparent"
                    height: parent.height
                    clip: true

                    ScrollBar
                    {
                        hoverEnabled: true
                        active: hovered || pressed
                        orientation: Qt.Vertical
                        size: subjectScrollArea.height / subjectsColumn.height
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                    }

                    Text
                    {
                        id: subjectsHeader
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.header
                        text: qsTr("Last subjects")
                    }

                    Rectangle
                    {
                        anchors.top: subjectsHeader.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 10
                        height: 1
                        color: Regovar.theme.primaryColor.back.normal
                    }


                    ScrollView
                    {
                        id: subjectsColumn
                        anchors.fill: parent
                        anchors.topMargin: Regovar.theme.font.boxSize.header + 5
                        anchors.rightMargin: 10
                        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff


                        Column
                        {
                            onHeightChanged: row.maxHeight = Math.max(row.maxHeight, height + Regovar.theme.font.boxSize.header + 5)
                            Repeater
                            {
                                model: regovar.lastSubjects
                                SearchResultSubject
                                {
                                    width: subjectsColumn.width - 10
                                    indent: 1
                                    date: model.modelData.updateDate
                                    identifier: model.modelData.identifier
                                    firstname: model.modelData.firstname
                                    lastname: model.modelData.lastname
                                    sex: model.modelData.sex
                                    onClicked: regovar.subjectsManager.openSubject(model.modelData.id)
                                }
                            }
                        }
                    }
                }
            }


            Rectangle
            {
                id: eventsScrollArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                clip: true

                Text
                {
                    id: eventsHeader
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.header
                    text: qsTr("Last events")
                }

                Rectangle
                {
                    anchors.top: eventsHeader.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: Regovar.theme.primaryColor.back.normal
                }

                ScrollView
                {
                    anchors.fill: parent
                    anchors.topMargin: Regovar.theme.font.boxSize.header + 5
                    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                    Column
                    {
                        id: eventsColumn
                        Repeater
                        {
                            model: regovar.eventsManager.lastEvents
                            SearchResultEvent
                            {
                                indent: 0
                                width: eventsScrollArea.width - 10 // 10 ScrollBar width
                                eventId: model.id
                                date: model.date
                                message: model.message
                            }
                        }
                    }
                }
            }
        }

        Rectangle
        {
            anchors.topMargin: newButtonsRow.height
            anchors.fill: parent
            color: Regovar.theme.backgroundColor.main
            visible: regovar.networkManager.status != 0



            Text
            {
                id: connectionLostText
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 20
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                text: qsTr("You are not connected to the Regovar server.\nIs Regovar server online ?")
                color: Regovar.theme.primaryColor.back.normal
                font.pixelSize: Regovar.theme.font.size.header
                horizontalAlignment: Text.AlignHCenter
            }
            ButtonIcon
            {
                anchors.top: connectionLostText.bottom
                anchors.horizontalCenter: connectionLostText.horizontalCenter
                anchors.margins: 20
                visible: !regovar.welcomIsLoading || regovar.networkManager.status != 0
                iconTxt: "d"
                text: qsTr("Check local settings")
                onClicked: regovar.mainMenu.goTo(5,1,2)
            }
        }
    }
}

