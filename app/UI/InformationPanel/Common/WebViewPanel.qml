import QtQuick 2.9
import QtWebView 1.0


import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property url model

    WebView
    {
        id: webview
        anchors.fill: parent
        url: root.model
    }
}
