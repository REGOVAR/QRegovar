import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtWebView 1.0
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Item
{
    id: root
    property File model
    onModelChanged:
    {
        if (model)
        {
            fileViewer.visible = true;
            fileViewer.url = model.viewerUrl;
            fileName.text = model.name;
        }
        else
        {
            fileViewer.visible = false;
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 10

        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title
            color: Regovar.theme.backgroundColor.alt
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            radius: 2

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 10


                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text
                    {
                        id: fileIcon
                        Layout.minimumWidth: Regovar.theme.font.boxSize.header
                        Layout.fillHeight: true
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Regovar.theme.font.size.header
                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.primaryColor.back.dark
                        text: model && !model.downloading ? "Y" : "/"

                        onTextChanged:
                        {
                            if (model && !model.downloading)
                            {
                                loadingIconAnimation.stop();
                                rotation = 0;
                            }
                            else
                            {
                                loadingIconAnimation.start();
                            }
                        }
                        NumberAnimation on rotation
                        {
                            id: loadingIconAnimation
                            duration: 1500
                            loops: Animation.Infinite
                            from: 0
                            to: 360
                        }
                    }
                    Text
                    {
                        id: fileName
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.dark
                        elide: Text.ElideRight
                    }
                }


                ButtonIcon
                {
                    iconTxt: "é"
                    text: qsTr("Download")
                    onClicked: Qt.openUrlExternally(model.url);
                }
            }
        }



        Rectangle
        {
            id: emptyPanel
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: Regovar.theme.backgroundColor.main



            Text
            {
                anchors.centerIn: parent
                text: qsTr("No document selected.")
                font.pixelSize: Regovar.theme.font.size.title
                color: Regovar.theme.primaryColor.back.light
            }

            WebView
            {
                id: fileViewer
                anchors.fill: parent
            }
        }
    }
}
