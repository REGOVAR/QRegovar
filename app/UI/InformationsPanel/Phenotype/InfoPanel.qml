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
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    property var diseases
    property var phenotypes
    property var model
    onModelChanged:  if (model) { updateFromModel(model); }

    function updateFromModel(data)
    {
        if (data)
        {
            diseases = data["diseases"];
            phenotypes = data["phenotypes"];
        }
    }


    Column
    {
        x:0
        y:0
        width: root.width

        Rectangle
        {
            id: diseaseHeader
            width: root.width - 2
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
                    text: qsTr("Related diseases")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Repeater
        {
            model: diseases

            OnlineToolAction
            {
                url: root.formatUrl(modelData.id)
                icon: "_"
                label: modelData.id
                width: root.width - 2
            }
        }

        Rectangle
        {
            id: phenotypeHeader
            width: root.width - 2
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
                    text: qsTr("Related phenotypes")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Repeater
        {
            model: phenotypes

            OnlineToolAction
            {
                url: "http://compbio.charite.de/hpoweb/showterm?id=" + modelData.id
                icon: "_"
                label: modelData.label
                width: root.width - 2
            }
        }
    }

    function formatUrl(id)
    {
        var data = id.split(":");
        var urls = {
            "OMIM" : "https://www.omim.org/entry/{0}",
            "ORPHA": "http://www.orpha.net/consor4.01/www/cgi-bin/Disease_Search.php?lng=EN&data_id=2010&Disease_Disease_Search_diseaseGroup={0}&Disease_Disease_Search_diseaseType=ORPHA"}

        return urls[data[0]].replace("{0}", data[1]);
    }
}
