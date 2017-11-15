import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"
import "VariantInformations"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        if (root.model != null)
        {
            selectionTree.model = root.model.results;
            selectionTree.rowHeight = (root.model.samples.length === 1) ? 25 : root.model.samples.length * 18;
        }
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
            text: model ? model.name : ""
            font.pixelSize: 20
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
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
        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tristique eu lorem sit amet viverra. Vivamus vitae fringilla nibh. Mauris tempor neque eu mauris tristique consequat. Curabitur dui enim, tempor ut quam vel, sagittis tempus diam. Praesent eu erat ante.")
    }


    SplitView
    {
        id: row
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10


        Rectangle
        {
            width: 300
            color: "transparent"
            clip: true

            ColumnLayout
            {
                id: leftPanel
                anchors.fill: parent
                anchors.rightMargin: 10
                spacing: 10

                Rectangle
                {
                    Layout.fillWidth: true
                    height: Regovar.theme.font.boxSize.header
                    color: "transparent"

                    RowLayout
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 10

                        Text
                        {
                            id: leftPanelHeader
                            Layout.fillWidth: true
                            font.pixelSize: Regovar.theme.font.size.header
                            color: Regovar.theme.primaryColor.back.dark
                            text: qsTr("Documents")
                            elide: Text.ElideRight
                        }


                        ButtonInline
                        {
                            text: qsTr("Download all")
                            icon: "é"
                        }
                    }



                    Rectangle
                    {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        width: parent.width
                        height: 1
                        color: Regovar.theme.primaryColor.back.normal
                    }
                }

                TreeView
                {
                    id: documentsTreeView
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    TableViewColumn
                    {
                        width: 100
                        title: "Name"
                    }
                    TableViewColumn
                    {
                        width: 100
                        title: "Size"
                    }
                    TableViewColumn
                    {
                        title: "Comment"
                    }
                }
            }
        }

        Rectangle
        {
            Layout.minimumWidth: 350
            color: "transparent"
            clip: true

            ColumnLayout
            {
                id: rightPanel
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 10

                Rectangle
                {
                    Layout.fillWidth: true
                    height: Regovar.theme.font.boxSize.header
                    color: "transparent"

                    RowLayout
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 10

                        Text
                        {
                            id: rightPanelHeader
                            Layout.fillWidth: true
                            font.pixelSize: Regovar.theme.font.size.header
                            color: Regovar.theme.primaryColor.back.dark
                            text: qsTr("Current document")
                            elide: Text.ElideRight
                        }

                        Row
                        {
                            spacing: 10

                            ButtonInline
                            {
                                text: ""
                                icon: "\""
                            }
                            ButtonInline
                            {
                                text: ""
                                icon: "é"
                            }
                        }
                    }



                    Rectangle
                    {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        width: parent.width
                        height: 1
                        color: Regovar.theme.primaryColor.back.normal
                    }
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"


                    Text
                    {
                        anchors.centerIn: parent
                        text: "Select a document"
                        font.pixelSize: Regovar.theme.font.size.title
                        color: Regovar.theme.primaryColor.back.light
                    }
                }
            }
        }
    }
}
