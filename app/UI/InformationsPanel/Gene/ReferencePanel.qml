import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0


import "../../Regovar"
import "../../Framework"
import "../Common"


ScrollView
{
    id: root
    anchors.fill: parent
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff


    property var pubmedData
    property var model
    onModelChanged: updateFromModel(model)

    function updateFromModel(data)
    {
        if (data && "pubmed" in data)
        {
            data = data["pubmed"];
            var txt = "<ol>";
            for (var idx=0; idx<data.length; idx++)
            {
                var d = data[idx];
                txt += "<li><b>" + d["title"] + "</b><br>";
                txt += d["authors"] + ".<br>";
                txt += d["source"] + "<br>";
                txt += "<a href=\"https://www.ncbi.nlm.nih.gov/pubmed/" + d["id"] + "\">PMID: " + d["id"] + "</a><br></li>";
            }
            txt += "</ol>";
            pubmedData = txt;
        }
        else
        {
            pubmedData = "";
        }
    }

    Column
    {
        x: 10
        y: 10

        TextEdit
        {
            width: root.width - 30
            text: pubmedData
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
}
