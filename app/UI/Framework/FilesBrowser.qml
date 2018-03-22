import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0
import "../Regovar"

Item
{
    id: root
    property alias modelTree: filesTreeView.model
    property alias modelList: filesListView.model
    onModelTreeChanged:
    {
        if (modelTree)
        {
            filesTreeView.visible = true;
            leftPanel.width = 300;
        }
    }
    onModelListChanged:
    {
        if (modelList)
        {
            filesListView.visible = true;
            leftPanel.width = modelList.rowCount() > 1 ? 300 : 0;
        }
    }

    SplitView
    {
        id: row
        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10
        visible: root.model ? root.model.loaded : false


        Rectangle
        {
            id: leftPanel
            width: 0
            color: "transparent"
            clip: true

            ColumnLayout
            {
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
                            iconTxt: "é"
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

                TableView
                {
                    id: filesListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: false

                    onCurrentRowChanged:
                    {
                        if (model)
                        {
                            var file = model.getAt(currentRow);
                            viewer.openFile(file.id);
                        }
                    }

                    TableViewColumn
                    {
                        width: 100
                        role: "name"
                        title: "Name"
                        delegate: Item
                        {

                            Text
                            {
                                anchors.leftMargin: 5
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: styleData.textAlignment
                                font.pixelSize: Regovar.theme.font.size.normal
                                font.family: Regovar.theme.icons.name
                                text: styleData.value.icon
                                onTextChanged:
                                {
                                    if (styleData.value.icon == "/") // = Loading
                                    {
                                        statusIconAnimation.start();
                                    }
                                    else
                                    {
                                        statusIconAnimation.stop();
                                        rotation = 0;
                                    }
                                }
                                NumberAnimation on rotation
                                {
                                    id: statusIconAnimation
                                    duration: 1500
                                    loops: Animation.Infinite
                                    from: 0
                                    to: 360
                                }
                            }
                            Text
                            {
                                anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                                anchors.rightMargin: 5
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: styleData.textAlignment
                                font.pixelSize: Regovar.theme.font.size.normal
                                text: styleData.value.filename
                                elide: Text.ElideRight
                            }
                        }
                    }
                    TableViewColumn
                    {
                        width: 100
                        role: "size"
                        title: "Size"
                    }
                    TableViewColumn
                    {
                        role: "date"
                        title: "Date"
                    }
                    TableViewColumn
                    {
                        role: "comment"
                        title: "Comment"
                    }
                }

                TreeView
                {
                    id: filesTreeView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: false

                    onCurrentIndexChanged:
                    {
                        if (model)
                        {
                            var id = model.data(currentIndex, Qt.UserRole+1);
                            console.log(id);
                            viewer.openFile(id);
                        }
                    }


                    TableViewColumn
                    {
                        width: 100
                        role: "name"
                        title: "Name"
                        delegate: Item
                        {

                            Text
                            {
                                anchors.leftMargin: 5
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: styleData.textAlignment
                                font.pixelSize: Regovar.theme.font.size.normal
                                font.family: Regovar.theme.icons.name
                                text: styleData.value.icon
                                onTextChanged:
                                {
                                    if (styleData.value.icon == "/") // = Loading
                                    {
                                        statusIconAnimation.start();
                                    }
                                    else
                                    {
                                        statusIconAnimation.stop();
                                        rotation = 0;
                                    }
                                }
                                NumberAnimation on rotation
                                {
                                    id: statusIconAnimation
                                    duration: 1500
                                    loops: Animation.Infinite
                                    from: 0
                                    to: 360
                                }
                            }
                            Text
                            {
                                anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                                anchors.rightMargin: 5
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: styleData.textAlignment
                                font.pixelSize: Regovar.theme.font.size.normal
                                text: styleData.value.filename
                                elide: Text.ElideRight
                            }
                        }
                    }
                    TableViewColumn
                    {
                        width: 100
                        role: "size"
                        title: "Size"
                    }
                    TableViewColumn
                    {
                        role: "date"
                        title: "Date"
                    }
                    TableViewColumn
                    {
                        role: "comment"
                        title: "Comment"
                    }
                }
            }
        }

        FileViewer
        {
            id: viewer
            Layout.minimumWidth: 350
        }
    }
}
