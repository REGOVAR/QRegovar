import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Rectangle
{
    id: root

    Component.onCompleted:
    {
        // regovar.currentAnnotationsTreeView.refresh();
        regovar.currentFilteringAnalysis.refresh();
    }

    SplitView
    {
        anchors.fill: parent


        Rectangle
        {
            id: leftPanel
            color: Regovar.theme.backgroundColor.main
            Layout.maximumWidth: 500
            width: 300


            Rectangle
            {
                id: leftHeader
                anchors.left: leftPanel.left
                anchors.top: leftPanel.top
                anchors.right: leftPanel.right
                height: 50
                color: Regovar.theme.backgroundColor.alt
            }


            TreeView
            {
                id: columnsSelector
                anchors.fill: leftPanel
                anchors.margins: 10
                anchors.topMargin: 60
                model: regovar.currentAnnotations

                // Default delegate for all column
                itemDelegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.control
                        text: styleData.value.value
                        elide: Text.ElideRight
                    }
                }

                TableViewColumn
                {
                    role: "name"
                    title: "Name"
                }

                TableViewColumn
                {
                    role: "version"
                    title: "Version"
                }

                TableViewColumn {
                    role: "description"
                    title: "Description"
                }


            }
        }


        Rectangle
        {
            id: rightPanel
            color: Regovar.theme.backgroundColor.main


            Rectangle
            {
                id: rightHeader
                anchors.left: rightPanel.left
                anchors.top: rightPanel.top
                anchors.right: rightPanel.right
                height: 50
                color: Regovar.theme.backgroundColor.alt
            }

            TreeView
            {
                id: browser
                anchors.fill: rightPanel
                anchors.margins: 10
                anchors.topMargin: 60
                model: regovar.currentFilteringAnalysis

                signal checked(int row, bool isChecked)
                onChecked: console.log(row, isChecked);

                // Default delegate for all column
                itemDelegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.control
                        text: styleData.value.value
                        elide: Text.ElideRight
                    }
                }

                TableViewColumn
                {
                    role: "id"
                    title: "CheckboxSelection"



                    delegate: Item
                    {
                        CheckBox
                        {
                            anchors.centerIn: parent
                            checked: styleData.value
                            onClicked: {
                                browser.selection.select(styleData.row);
                                browser.currentRow = styleData.row;
                                browser.checked(styleData.row, checked);
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "816ce7a58b6918652399342e46143386"
                    title: "chr"
                }

                TableViewColumn {
                    role: "0ec9783c0c626c928005f05956cb3d7b"
                    title: "pos"
                }

                TableViewColumn {
                    role: "de2b02e8a7f3c77cf55efd18e0832f22"
                    title: "ref"
                }

                TableViewColumn {
                    role: "ab1e6b068bd1618d0422a462df93f28b"
                    title: "alt"
                }

                TableViewColumn
                {
                    role: "66b71b223a449d2369e7d58ec0c7cd5d"
                    title: "samples"

                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value["8"]
                            elide: Text.ElideRight
                        }
                    }
                }

                TableViewColumn {
                    role: "6cde5e77baebcc9d98c40a720f6c1b82"
                    title: "count"
                }

                TableViewColumn
                {
                    role: "b33e172643f14920cee93d25daaa3c7b"
                    title: "GT"

                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value["8"]
                            elide: Text.ElideRight
                        }
                    }
                }

                TableViewColumn
                {
                    role: "3ee42adc14f878158deeb74e16131cf5"
                    title: "DP"

                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value["8"]
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
