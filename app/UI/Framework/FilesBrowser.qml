import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Item
{
    id: root
    property alias model: filesTreeView.model

    SplitView
    {
        id: row
        anchors.fill: parent

        Rectangle
        {
            id: leftPanel
            width: 300
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

//                        ButtonInline
//                        {
//                            text: qsTr("Download all")
//                            iconTxt: "é"
//                        }
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
                    id: filesTreeView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    width: 300

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
