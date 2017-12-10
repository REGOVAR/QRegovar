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

    property var model

    Column
    {
        x:10
        y:5
        width: root.width
        spacing: 10

        // Pubmed resources
        Rectangle
        {
            width: root.width - 20
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Pubmed")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Repeater
        {
            model: root.model ? root.model["pubmed_id"] : []

            RowLayout
            {
                x: 10
                width: root.width - 30
                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: "Y"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                TextEdit
                {
                    Layout.fillWidth: true
                    text: formatPubMed(modelData)
                    textFormat: TextEdit.RichText
                    font.pixelSize: Regovar.theme.font.size.normal + 2
                    color: Regovar.theme.frontColor.normal
                    readOnly: true
                    selectByMouse: true
                    selectByKeyboard: true
                    wrapMode: TextEdit.Wrap
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }

    function formatPubMed(data)
    {
        var text = "";
        text += "<b>" + data["title"] + "</b><br>";
        text += data["firstauthor"] + ", ..., " + data["lastauthor"] + ".<br>";
        text += data["source"] + " - " + data["pubdate"] + "<br>";
        text += "<a href=\"https://www.ncbi.nlm.nih.gov/pubmed/" + data["uid"] + "\">PMID: " + data["uid"] + "</a>";

        return text;
    }
}
