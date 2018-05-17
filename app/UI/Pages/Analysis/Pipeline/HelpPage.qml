import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtWebView 1.0
import Regovar.Core 1.0
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property PipelineAnalysis model
    onModelChanged:
    {
        if (model)
        {
            root.model.dataChanged.connect(updateViewFromModel);
        }
        updateViewFromModel();
    }

    function updateViewFromModel()
    {
        if (model.pipeline.helpPage)
        {
            webview.url = model.pipeline.helpPage;
        }
        else
        {
            webview.url = "http://regovar.readthedocs.io/fr/latest/user/pipeline/";
        }
    }

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            text: model.pipeline.name + " " + qsTr("pipeline help")
        }
        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }
    }


    WebView
    {
        id: webview
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 0
    }






}
