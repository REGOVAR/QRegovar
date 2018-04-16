import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/InformationPanel/Common"


ScrollView
{
    id: root
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    property var model
    onModelChanged: updateFromModel(model)
    Component.onCompleted: updateFromModel(model)

    Column
    {
        x: 10
        y: 10
        width: root.width - 30

        TextEdit
        {
            id: infoText
            clip: true
            width: root.width - 30
            textFormat: TextEdit.RichText
            font.pixelSize: Regovar.theme.font.size.normal + 2
            color: Regovar.theme.frontColor.normal
            readOnly: true
            selectByMouse: true
            selectByKeyboard: true
            wrapMode: TextEdit.Wrap
            onLinkActivated: Qt.openUrlExternally(link)
        }
        Item
        {
            width: 1
            height: 10
        }
    }

    function updateFromModel(data)
    {
        if (!data) return "";

        infoText.text = data.type === "phenotypic" ? phenotypeData(data) : diseaseData(data);
    }

    function phenotypeData(data)
    {
        var text = "<table><tr><td><b>Id: </b></td><td> " + data.id + "</td></tr>";
        text += "<tr><td><b>Category: </b></td><td> -</td></tr>";
        text += "<tr><td><b>Genes frequence: </b></td><td " + data.genesFreq["label"] + "</td></tr>";
        text += "<tr><td><b>Diseases frequence: </b></td><td> " + data.diseasesFreq["label"]  + "</td></tr>";
        text += "</table><br/><br/>";

        // Parents
        if (data.parents.rowCount()>0)
        {
            text += "<b>Up classes:</b><ul>";
            for (var idx=0; idx<data.parents.rowCount(); idx++)
            {
                text += "<li>" + data.parents.getAt(idx).label + " (" + data.parents.getAt(idx).id + ")</li>";
            }
            text += "</ul>";
        }
        // Childs
        if (data.childs.rowCount()>0)
        {
            text += "<b>Sub classes:</b><ul>";
            for (var idx=0; idx<data.childs.rowCount(); idx++)
            {
                text += "<li>" + data.childs.getAt(idx).label + " (" + data.childs.getAt(idx).id + ")</li>";
            }
            text += "</ul>";
        }
        // Sources
        if (data.sources.length>0)
        {
            text += "<b>Sources:</b><ul>";
            for (var idx=0; idx<data.sources.length; idx++)
            {
                text += "<li>" + data.sources[idx] + "</li>";
            }
            text += "</ul>";
        }
        return text;
    }

    function diseaseData(data)
    {
        var text = "<table><tr><td><b>Id: </b></td><td> " + data.id + "</td></tr>";
        text += "<tr><td><b>Genes frequence: </b></td><td " + data.genesFreq["label"] + "</td></tr>";
        text += "</table><br/><br/>";

        // Sources
        if (data.sources.length>0)
        {
            text += "<b>Sources:</b><ul>";
            for (var idx=0; idx<data.sources.length; idx++)
            {
                text += "<li>" + data.sources[idx] + "</li>";
            }
            text += "</ul>";
        }
        return text;
    }
}
