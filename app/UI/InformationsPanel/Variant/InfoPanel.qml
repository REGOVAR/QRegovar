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
    onModelChanged:  if (model) { updateFromModel(model); }

    function updateFromModel(data)
    {
        if (data)
        {
            var text = "<h1>Salut</h1><table><tr><td>" + + "</td><td>" + + "</td></tr>";
            text += "<tr><td>" + qsTr("Synonyms:") + "</td><td>" + + "</td></tr>";
            text += "<tr><td>" + qsTr("Locus type:") + "</td><td>" + + "</td></tr>";
            text += "<tr><td>" + qsTr("Chromosomal&nbsp;location:") + "</td><td>" + + "</td></tr>";
            text += "<tr><td>" + qsTr("Gene family:")+ "</td><td>" + + "</td></tr></table><br/>";

            text += "<h1>Salut</h1><table><tr><td>" + + "</td><td>" + + "</td></tr>";
            text += "<tr><td>" + qsTr("Synonyms:") + "</td><td>" + + "</td></tr>";
            text += "<tr><td>" + qsTr("Locus type:") + "</td><td>" + + "</td></tr>";
            text += "<tr><td>" + qsTr("Chromosomal location:") + "</td><td>" + + "</td></tr>";
            text += "<tr><td>" + qsTr("Gene family:")+ "</td><td>" + + "</td></tr></table>";
            resume.text = text;
        }
    }


    TextEdit
    {
        id: resume
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        textFormat: TextEdit.RichText
        text: ""

        font.pixelSize: Regovar.theme.font.size.normal
        // color: Regovar.theme.primaryColor.front.normal
        readOnly: true
        selectByMouse: true
        selectByKeyboard: true
        wrapMode: TextEdit.Wrap
    }



}
