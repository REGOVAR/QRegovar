import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Item
{
    id: root
    property bool readOnly: false
    property File currentFile
    property QtObject model
    onModelChanged:
    {
        if(model)
        {
            model.dataChanged.connect(updateViewFromModel);
        }
        updateViewFromModel();
    }
    Component.onDestruction:
    {
        model.dataChanged.disconnect(updateViewFromModel);
    }


    SplitView
    {
        id: row
        anchors.fill: parent

        Item
        {
            id: leftPanel
            width: 300

            ColumnLayout
            {
                anchors.fill: parent
                anchors.rightMargin: 10
                spacing: 10

                RowLayout
                {
                    spacing: 10
                    ButtonIcon
                    {
                        iconTxt: "à"
                        text: "Add file"
                        onClicked: fileSelector.open()
                        visible: !root.readOnly
                    }
                    TextField
                    {
                        id: browserSearch

                        Layout.fillWidth: true
                        iconLeft: "z"
                        displayClearButton: true
                        placeholder: qsTr("Search file...")
                        onTextChanged: browser.model.setFilterString(text)
                    }
                }


                TreeView
                {
                    id: browser
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onCurrentIndexChanged: displayCurrentFile()

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
        }

        FileViewer
        {
            id: viewer
            Layout.minimumWidth: 350
        }
    }

    SelectFilesDialog
    {
        id: fileSelector
        onFileSelected:
        {
            for(var idx in files)
            {
                var file = files[idx];
                root.model.add(file);
            }
        }
    }

    function updateViewFromModel()
    {
        if (root.model)
        {
            browser.model = root.model.proxy;
        }
    }

    function displayCurrentFile()
    {
        var idx = root.model.proxy.mapToSource(browser.currentIndex);
        var id = root.model.data(idx, 257); // 257 = Qt::UserRole+1

        root.currentFile = regovar.filesManager.getOrCreateFile(id);
        viewer.openFile(id);
    }
}
