import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    property bool editionMode: false


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
            text: qsTr("Analysis Resume Page")
            font.pixelSize: 20
            font.weight: Font.Black
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
        text: qsTr("This page give you an overview of the analysis.")
    }


    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        rows: 10
        columns: 3
        columnSpacing: 10
        rowSpacing: 10


        Text
        {
            text: qsTr("Name*")
            font.bold: true
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: nameField
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Name of the analysis")
            text: "Série B12"
        }

        Column
        {
            Layout.rowSpan: 9
            Layout.alignment: Qt.AlignTop
            spacing: 10


            Button
            {
                text: editionMode ? qsTr("Save") : qsTr("Edit")
                onClicked:  editionMode = !editionMode
            }

            Button
            {
                visible: editionMode
                text: qsTr("Cancel")
            }
        }

        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Comment")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextArea
        {
            id: commentField
            Layout.fillWidth: true
            enabled: editionMode
            height: 3 * Regovar.theme.font.size.control
            text: "Comment about the subject"
        }


        Text
        {
            text: qsTr("Priority")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        ComboBox
        {
            enabled: editionMode
            model: ["Emergency", "Hight", "Normal", "Low", "None"]
            currentIndex: 1
        }



        Rectangle
        {
            Layout.columnSpan: 2
            height: 1
            color: Regovar.theme.primaryColor.back.dark
            Layout.fillWidth: true
        }



        Text
        {
            text: qsTr("Type")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            text: "Filtering Trio"
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
        }


        Text
        {
            text: qsTr("Referencial")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            text: "Hg19"
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
        }



        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Samples")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Column
        {
            Row
            {

                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "9"
                }

                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    font.family: "monospace"
                    text: "MD-02-75"+ " - "
                }
                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "DUPONT Michel (64y)"
                }
                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "{"
                }
                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    font.family: "monospace"
                    text: "Hp-A7-5663"
                }
            }
            Row
            {

                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "<"
                }

                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    font.family: "monospace"
                    text: "MD-02-76"+ " - "
                }
                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "DUPONT Micheline (60y)"
                }
                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "{"
                }
                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    font.family: "monospace"
                    text: "Gtk-8999112"
                }
            }
            Row
            {

                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "9"
                }

                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    font.family: "monospace"
                    text: "MM-11-86"+ " - "
                }
                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "DUPONT Michou (11y)"
                }
                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "{"
                }
                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    font.family: "monospace"
                    text: "GHJ-446"
                }
            }
        }

        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Annotations")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Column
        {
            Row
            {
                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "B"
                }

                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "VEP (v76)"
                }
            }
            Row
            {
                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "B"
                }

                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "SnpEff (v4.2)"
                }
            }
            Row
            {
                Text
                {
                    width: Regovar.theme.font.boxSize.control
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "B"
                }

                Text
                {
                    font.pixelSize: Regovar.theme.font.size.control
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: "dbNSFP (v3.3)"
                }
            }

        }



        Rectangle
        {
            Layout.columnSpan: 2
            height: 1
            color: Regovar.theme.primaryColor.back.dark
            Layout.fillWidth: true
        }


        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Events")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TreeView
        {
            Layout.fillWidth: true
            Layout.fillHeight: true


            TableViewColumn
            {
                title: "Date"
                role: "filenameUI"
            }
            TableViewColumn
            {
                title: "Event"
                role: "filenameUI"
            }
        }
        Column
        {
            Layout.alignment: Qt.AlignTop
            spacing: 10


            Button
            {
                id: addFile
                text: qsTr("Add event")
            }

            Button
            {
                id: editFile
                text: qsTr("Edit event")
            }
        }

    }
}



