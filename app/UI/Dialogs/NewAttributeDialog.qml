import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: attributePopup
    modality: Qt.WindowModal

    title: qsTr("Create a new attribute")

    width: 500
    height: 300

    onVisibleChanged: { nameField.text = ""; checkSave(); }

    property real labelColumnWidth: 0

    contentItem: Rectangle
    {
        id: root
        color: Regovar.theme.backgroundColor.main


        Rectangle
        {
            id: header
            anchors.top : root.top
            anchors.left: root.left
            anchors.right: root.right
            height: 100

            color: Regovar.theme.primaryColor.back.normal


            Text
            {
                id: headerIcon
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.margins: 10
                width: 80
                height: 80

                text: ";"
                color: Regovar.theme.primaryColor.front.dark
                font.family: Regovar.theme.icons.name
                font.weight: Font.Black
                font.pixelSize: 80
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:  Text.AlignHCenter
            }


            Text
            {
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 10
                anchors.leftMargin: 100


                text: qsTr("New samples attribute")
                font.pixelSize: Regovar.theme.font.size.title
                font.bold: true
                color: Regovar.theme.primaryColor.front.normal
                elide: Text.ElideRight
            }
            Text
            {
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                anchors.topMargin: 15 + Regovar.theme.font.size.title
                anchors.leftMargin: 100
                wrapMode: "WordWrap"
                elide: Text.ElideRight

                text: qsTr("Give a name to the attribute and set its value for each sample.\nTo be valid, the attribute must have a name, and at least one sample must have a value. Name and values must not exceed 250 characters.")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.front.normal
            }
        }


        ScrollView
        {
            id: scrollView
            anchors.top: header.bottom
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: okButton.top
            anchors.margins: 10

            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                id: rootLayout
                spacing: 10

                RowLayout
                {
                    width: scrollView.width
                    spacing: 30
                    Text
                    {
                        Layout.minimumWidth: attributePopup.labelColumnWidth
                        onWidthChanged: attributePopup.labelColumnWidth = Math.max(width, attributePopup.labelColumnWidth)
                        text: qsTr("Name*")
                        font.weight: Font.Black
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.font.familly
                        verticalAlignment: Text.AlignVCenter
                        height:  Regovar.theme.font.boxSize.normal
                    }
                    TextField
                    {
                        id: nameField
                        Layout.fillWidth: true
                        placeholderText: qsTr("Name of the attribute (mandatory)")
                        onTextEdited: checkSave()
                    }
                }

                Text
                {
                    Layout.columnSpan: 2
                    text: qsTr("Values by samples : ")
                    font.weight: Font.Black
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }

                Repeater
                {
                    model: regovar.newFilteringAnalysis.samples

                    RowLayout
                    {
                        width: scrollView.width
                        spacing: 30
                        Text
                        {
                            Layout.minimumWidth: attributePopup.labelColumnWidth
                            onWidthChanged: attributePopup.labelColumnWidth = Math.max(width, attributePopup.labelColumnWidth)
                            text: modelData.name
                            color: Regovar.theme.primaryColor.back.dark
                            font.pixelSize: Regovar.theme.font.size.normal
                            font.family: Regovar.theme.font.familly
                            verticalAlignment: Text.AlignVCenter
                            height:  Regovar.theme.font.boxSize.normal
                        }
                        TextField
                        {
                            Layout.fillWidth: true
                            placeholderText: ""
                            objectName: "sampleValueField"
                            onTextEdited: checkSave()
                        }
                    }
                }
            }
        }

        Button
        {
            id: okButton
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10

            text: qsTr("Save")
            onClicked:
            {
                var values = [];
                for (var i; i<scrollView.children.length; i++)
                {
                    var comp = scrollView.children[i];
                    if (comp.objectName === "sampleValueField")
                    {
                        values = values.concat(comp.text);
                    }
                }

                regovar.newFilteringAnalysis.saveAttribute(nameField.text, values);
                attributePopup.close();
            }
        }
        Button
        {
            id: cancelButton
            anchors.right: okButton.left
            anchors.bottom: parent.bottom
            anchors.margins: 10

            text: qsTr("Cancel")
            onClicked:
            {
                attributePopup.close();
            }
        }
    }

    function checkSave()
    {
        var okName = nameField.text.trim() !== "";
        var okVal = false;
        for (var i=0; i<rootLayout.children.length; i++)
        {
            var row = rootLayout.children[i];
            for (var j=0; j<row.children.length; j++)
            {
                var comp = row.children[j];
                if (comp.objectName === "sampleValueField")
                {
                    okVal = okVal || comp.text.trim() !== "";
                }
            }
        }
        okButton.enabled = okName && okVal;
    }
}
