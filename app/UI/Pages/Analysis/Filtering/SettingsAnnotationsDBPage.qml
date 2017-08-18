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
    onModelChanged:
    {
        console.log("===> AnnotationPanel model set up")
        annotationsSelector.model = root.model.annotations
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
            text: qsTr("Analysis annotations databases settings")
            font.pixelSize: 20
            font.weight: Font.Black
        }
    }



    ColumnLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        spacing: 10

        TextField
        {
            Layout.fillWidth: true
            placeholderText: qsTr("Search annotation...")
        }


        TreeView
        {
            id: annotationsSelector
            // model: root.model.annotations
            Layout.fillWidth: true
            Layout.fillHeight: true


            signal checked(string uid, bool isChecked)
            onChecked: root.model.setField(uid, isChecked);

            // Default delegate for all column
            itemDelegate: Item
            {
                Text
                {
                    anchors.leftMargin: 5
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.control
                    text: (styleData.value == undefined || styleData.value.value == null) ? "-"  : styleData.value.value
                    elide: Text.ElideRight
                }
            }

            TableViewColumn
            {
                role: "name"
                title: "Name"

                delegate: Item
                {
                    CheckBox
                    {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        checked: styleData.value.checked
                        text: (styleData.value == undefined || styleData.value.value == undefined) ? "-"  : styleData.value.value
                        onClicked:
                        {
                            var test = styleData.value
                            annotationsSelector.checked(styleData.value.uid, checked);
                        }
                    }
                }
            }

            TableViewColumn {
                role: "description"
                title: "Description"
                width: 250
            }
        }

    }
}
