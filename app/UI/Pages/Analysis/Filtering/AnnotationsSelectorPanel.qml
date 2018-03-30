import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        console.log("===> AnnotationPanel model set up")
        annotationsSelector.model = root.model.annotationsTree.proxy
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

            ColumnLayout
            {
                anchors.fill: parent
                anchors.margins: 10
                anchors.topMargin: 5
                spacing: 10


                TextField
                {
                    id: searchBox
                    iconLeft: "z"
                    displayClearButton: true
                    Layout.fillWidth: true
                    placeholder: qsTr("Search annotation...")
                    onTextEdited: root.model.annotationsTree.proxy.setFilterString(text);
                    onTextChanged: root.model.annotationsTree.proxy.setFilterString(text);
                }

                TreeView
                {
                    id: annotationsSelector
                    Layout.fillHeight: true
                    Layout.fillWidth: true

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
                                    var idx = root.model.annotationsTree.proxy.mapToSource(styleData.index);
                                    var annot = root.model.annotationsTree.getAnnotation(idx);
                                    if (annot)
                                    {
                                        root.model.setDisplayedAnnotationTemp(annot.uid, checked);
                                        applyButton.enabled = true;
                                    }
                                    else
                                    {
                                        console.log("TODO: checking annotation database: need to check/uncheck all fields");
                                    }
                                }

                                onVisibleChanged:
                                {
                                    if (visible)
                                    {
                                        var idx = root.model.annotationsTree.proxy.mapToSource(styleData.index);
                                        if (idx.valid)
                                        {
                                            var annot = root.model.annotationsTree.getAnnotation(idx)
                                            if (annot)
                                            {
                                                checked = annot.isDisplayedTemp;
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
                iconTxt: "n"
                enabled: false
                onClicked: { root.model.applyChangeForDisplayedAnnotations(); applyButton.enabled = false; }
            }
        }
    }
}
