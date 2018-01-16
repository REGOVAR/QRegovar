import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var checkChanges: []
    property FilteringAnalysis model
    onModelChanged:
    {
        console.log("===> AnnotationPanel model set up")
        annotationsSelector.model = root.model.annotations
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 0

        Rectangle
        {
            height: Regovar.theme.font.size.header + 20 // 20 = 2*10 to add spacing top+bottom
            Layout.fillWidth: true
            color: Regovar.theme.backgroundColor.main

            Text
            {
                id: textHeader
                anchors.fill: parent
                anchors.margins: 10

                text: qsTr("Displayed columns")
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                elide: Text.ElideRight
            }

            Rectangle
            {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Regovar.theme.primaryColor.back.light
            }
        }

        Rectangle
        {
            color: "transparent"
            Layout.fillHeight: true
            Layout.fillWidth: true

            TreeView
            {
                id: annotationsSelector
                anchors.fill: parent
                anchors.margins: 10
                anchors.topMargin: 5

                // Default delegate for all column
                itemDelegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal
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
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: styleData.value ? styleData.value : "-"
                            onClicked:
                            {
                                var annot = annotationsSelector.model.getAnnotation(styleData.index);
                                if (annot)
                                {
                                    // add or remove annotation id to the list of changes
                                    if (root.checkChanges.indexOf(annot.uid) != -1)
                                    {
                                        root.checkChanges.pop(annot.uid);
                                    }
                                    else
                                    {
                                        root.checkChanges.push(annot.uid);
                                    }

                                    // Check if any change can be applyed
                                    applyButton.enabled = root.checkChanges.length > 0;
                                    //cancelButton.enabled = root.checkChanges.length > 0;
                                }
                                else
                                {
                                    console.log("TODO: checking annotation database: need to check/uncheck all fields");
                                }
                            }

                            Component.onCompleted:
                            {
                                var idx = styleData.index;
                                if (idx.valid)
                                {
                                    var data = annotationsSelector.model.data(idx, Qt.UserRole + 2)
                                    if (data)
                                    {
                                        checked = data;
                                    }
                                    else
                                    {
                                        checked = false;
                                    }
                                }
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
                        text: styleData.value ? styleData.value : "-"
                        elide: Text.ElideRight
                    }
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: Regovar.theme.primaryColor.back.light
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: applyButton.height + 20
            color: "transparent"


            ButtonIcon
            {
                id: applyButton
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                text: qsTr("Apply changes")
                icon: "n"
                enabled: false
                onClicked:
                {
                    root.model.switchFields(root.checkChanges);
                }
            }
        }
    }
}
