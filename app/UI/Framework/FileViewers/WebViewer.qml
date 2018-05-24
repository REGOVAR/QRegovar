import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtWebView 1.0
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"

Item
{
    id: root
    anchors.fill: parent

    property bool hovered: false
    property File model
    onModelChanged:
    {
        webview.url = model.url;
        fileName.text = model.name;
    }

    ColumnLayout
    {
        anchors.fill: parent

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
                        Layout.minimumWidth: Regovar.theme.font.boxSize.header
                        Layout.fillHeight: true
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Regovar.theme.font.size.header
                        font.family: Regovar.theme.icons.name
                        color: root.hovered ? Regovar.theme.secondaryColor.back.light : Regovar.theme.primaryColor.back.dark
                        text: webview.loadProgress != 100 ? "/" : "è"

                        onTextChanged:
                        {
                            if (webview.loadProgress != 100)
                            {
                                loadingIconAnimation.start();
                            }
                            else
                            {
                                loadingIconAnimation.stop();
                                rotation = 0;
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
                        color: root.hovered ? Regovar.theme.secondaryColor.back.light : Regovar.theme.primaryColor.back.dark
                        elide: Text.ElideRight
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: root.hovered = true
                        onExited: root.hovered = false
                        onClicked: webview.url = model.url;

                        ToolTip.text: qsTr("Reload page.")
                        ToolTip.visible: root.hovered
                        ToolTip.delay: 250
                        cursorShape: Qt.PointingHandCursor
                    }
                }



                ButtonIcon
                {
                    iconTxt: "_"
                    text: qsTr("Open externaly")
                    onClicked: Qt.openUrlExternally(model.localFilePath);
                }
            }
        }

        Rectangle
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: Regovar.theme.backgroundColor.alt
            border.width: 1
            border.color: Regovar.theme.boxColor.border

            WebView
            {
                id: webview
                anchors.fill: parent
                anchors.margins: 1
            }
        }

    }
}
