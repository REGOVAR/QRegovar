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
                Regovar.menuModel.selectedIndex=[1,-1,-1];
            }
        }

        placeholder: regovar.networkManager.status == 0 ? qsTr("Search anything, project, sample, phenotype, analysis, variant, report...") : ""
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
                text: qsTr("New project")
                onClicked: regovar.openNewProjectWizard()
                enabled: regovar.networkManager.status == 0
            }
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

        ScrollView
        {
            id: scrollViewArea
            visible: regovar.welcomIsLoading
            anchors.top: newButtonsRow.bottom
            anchors.topMargin: 70
            anchors.left: panel.left
            anchors.right: panel.right
            anchors.bottom: panel.bottom


            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                spacing: 30

                Rectangle
                {
                    color: "transparent"
                    // Layout.minimumHeight: 3*Regovar.theme.font.boxSize.normal
                    width: panel.width

                    SplitView
                    {
                        id: row
                        width: parent.width
                        onHeightChanged: parent.height = height




                        Rectangle
                        {
                            id: analysesScrollArea
                            color: "transparent"
                            width: 500
                            // height is sized by colomn content
                            onHeightChanged: row.height = Math.max(height, row.height)
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
                                anchors.rightMargin: Regovar.theme.font.boxSize.normal
                                height: 1
                                color: Regovar.theme.primaryColor.back.normal
                            }

                            Column
                            {
                                id: analysesColumn
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.topMargin: Regovar.theme.font.boxSize.header + 5
                                anchors.rightMargin: Regovar.theme.font.boxSize.normal
                                onHeightChanged: analysesScrollArea.height = Math.max(height + Regovar.theme.font.boxSize.header + 5, analysesScrollArea.height)

                                Repeater
                                {
                                    model: regovar.lastAnalyses
                                    SearchResultAnalysis
                                    {
                                        indent: 0
                                        width: analysesScrollArea.width - 30 // 15 right margin + 15 ScrollBar width
                                        date: model.modelData.update_date
                                        name: model.modelData.name
                                        fullpath: model.modelData.fullpath

                                        onClicked: regovar.analysesManager.openAnalysis("Filtering", model.modelData.id)
                                        anchors.left: analysesColumn.left
                                        anchors.right: analysesColumn.right
                                    }
                                }
                            }
                        }

                        Rectangle
                        {
                            id: subjectScrollArea
                            color: "transparent"
                            // height is sized by colomn content
                            onHeightChanged: row.height = Math.max(height, row.height)
                            clip: true

                            Text
                            {
                                id: subjectsHeader
                                anchors.left: parent.left
                                anchors.leftMargin: Regovar.theme.font.boxSize.normal
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
                                anchors.leftMargin: Regovar.theme.font.boxSize.normal
                                height: 1
                                color: Regovar.theme.primaryColor.back.normal
                            }

                            Column
                            {
                                anchors.fill: parent
                                anchors.topMargin: Regovar.theme.font.boxSize.header + 5
                                anchors.rightMargin: 15
                                onHeightChanged: subjectScrollArea.height = Math.max(height + Regovar.theme.font.boxSize.header + 5, subjectScrollArea.height)

                                Repeater
                                {
                                    model: regovar.lastSubjects
                                    SearchResultSubject
                                    {
                                        width: 500
                                        indent: 1
                                        date: model.modelData.update_date
                                        identifier: model.modelData.identifier
                                        firstname: model.modelData.firstname
                                        lastname: model.modelData.lastname
                                        sex: model.modelData.sex
                                        // age: model.modelData.age

                                        onClicked: regovar.subjectsManager.openSubject(model.modelData.id)
                                    }
                                }
                            }
                        }
                    }
                }

                Column
                {
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
                        width: panel.width
                        height: 1
                        color: Regovar.theme.primaryColor.back.normal
                    }




                    Repeater
                    {
                        model : ListModel
                        {
                            ListElement { date: "2017-06-25 14:56"; name: "Article published"; icon:"j"; color:"" }
                            ListElement { date: "2017-06-25 14:56"; name: "Pause analysis \"Hugodims\""; icon:"m"; color:"red" }
                            ListElement { date: "2017-06-25 14:56"; name: "Start new analysis \"Hugodims\""; icon:""; color:"" }
                            ListElement { date: "2017-06-25 14:56"; name: "Creation of the project : DPNI"; icon:""; color:"" }
                        }

                        RowLayout
                        {
                            spacing: 0
                            height: Regovar.theme.font.boxSize.normal

                            Text
                            {
                                width: 150
                                font.pixelSize: 12
                                font.family: "monospace"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                text: date
                                color: Regovar.theme.frontColor.disable
                            }

                            Rectangle
                            {
                                width: Regovar.theme.font.boxSize.normal
                                height: Regovar.theme.font.boxSize.normal
                                color: "transparent"
                            }
                            Text
                            {
                                Layout.minimumWidth: Regovar.theme.font.boxSize.normal
                                font.pixelSize: 12
                                font.family: Regovar.theme.icons.name
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
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
                icon: "d"
                text: qsTr("Check local settings")
                onClicked: Regovar.menuModel.selectedIndex = [4, 1, -1]
            }
        }
    }
}

