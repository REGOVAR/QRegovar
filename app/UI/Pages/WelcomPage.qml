import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "qrc:/qml/Framework"
import "qrc:/qml/Regovar"
import "qrc:/qml/Dialogs"
import "qrc:/qml/Pages/Browse"

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


    Logo
    {
        id: logo
        anchors.top: header.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: root.horizontalCenter
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

        property string previousResearch: ""

        onEditingFinished:
        {
            if (text != "" && text != previousResearch && root.visible)
            {
                regovar.search(text);
                regovar.mainMenu.goTo(1,-1,-1);
            }
            previousResearch = text;
        }

        placeholder: regovar.networkManager.status == 0 ? qsTr("Search anything, sample, phenotype, analysis, variant, report...") : ""
        focus: true
    }


    Item
    {
        id: panel

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


        GridLayout
        {
            visible: regovar.welcomIsLoading
            anchors.top: newButtonsRow.bottom
            anchors.topMargin: 10
            anchors.left: panel.left
            anchors.right: panel.right
            anchors.bottom: panel.bottom
            columns: 2
            rows:5
            columnSpacing: 30
            rowSpacing: 10



            Text
            {
                Layout.row: 0
                Layout.column: 0
                height: Regovar.theme.font.boxSize.header
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                text: qsTr("Last analyses")
            }
            Rectangle
            {
                Layout.row: 1
                Layout.column: 0
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: Regovar.theme.backgroundColor.alt
                radius: 2
                ListView
                {
                    anchors.fill: parent
                    anchors.margins: 5
                    model: regovar.lastAnalyses
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}
                    delegate: SearchResultAnalysis
                    {
                        width: parent.width - 10
                        indent: 0
                        date: model.updateDate
                        name: model.name
                        //fullpath: model.modelData.fullpath
                        status: model.status
                        onClicked: regovar.analysesManager.openAnalysis(model.type, model.id)
                    }
                }
            }



            Text
            {
                Layout.row: 0
                Layout.column: 1
                height: Regovar.theme.font.boxSize.header
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                text: qsTr("Last subjects")
            }
            Rectangle
            {
                Layout.row: 1
                Layout.column: 1
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: Regovar.theme.backgroundColor.alt
                radius: 2
                ListView
                {
                    anchors.fill: parent
                    anchors.margins: 5
                    model: regovar.lastSubjects
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}
                    delegate: SearchResultSubject
                    {
                        width: parent.width - 10
                        indent: 0
                        date: model.updateDate
                        identifier: model.identifier
                        firstname: model.firstname
                        lastname: model.lastname
                        sex: model.sex
                        onClicked: regovar.subjectsManager.openSubject(model.id)
                    }
                }
            }


            Item
            {
                Layout.row: 2
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.minimumHeight: 10
            }

            Text
            {
                Layout.row: 3
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                height: Regovar.theme.font.boxSize.header
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                text: qsTr("Last events")
            }

            Rectangle
            {
                Layout.row: 4
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: Regovar.theme.backgroundColor.alt
                radius: 2
                ListView
                {
                    anchors.fill: parent
                    anchors.margins: 5
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}
                    model: regovar.eventsManager.lastEvents
                    delegate: SearchResultEvent
                    {
                        width: parent.width - 10
                        indent: 0
                        eventId: model.id
                        date: model.date
                        message: model.message
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

