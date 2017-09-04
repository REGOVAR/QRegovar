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

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10

        Text
        {
            text: qsTr("Displayed columns")
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.dark
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

            TableViewColumn
            {
                role: "description"
                title: "Description"
                width: 250
                delegate: Text
                {
                    text: (styleData.value == undefined || styleData.value.value == undefined) ? "-"  : styleData.value.value
                    elide: Text.ElideRight
                }
            }
        }

        TextField
        {
            Layout.fillWidth: true
            placeholderText: qsTr("Search annotation...")
        }
    }
}
