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


            TreeView
            {
                id: filesTreeView
                anchors.fill: parent
                anchors.rightMargin: 10

                onCurrentIndexChanged:
                {
                    if (model)
                    {
                        var id = model.data(currentIndex, Qt.UserRole+1);
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
                                if (styleData.value.icon === "/") // = Loading
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

        FileViewer
        {
            id: viewer
            Layout.minimumWidth: 350
        }
    }
}
