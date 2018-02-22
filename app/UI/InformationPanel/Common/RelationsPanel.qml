import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"
import "../../Pages/Browse"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var model
    onModelChanged:
    {
        if(model)
        {
            searchResults.displayresults(model);
            empty.visible = false;
            searchResults.visible = true;
        }
        else
        {
            empty.visible = true;
            searchResults.visible = false;
        }
    }

    SearchResultsList
    {
        id: searchResults
        anchors.fill: parent
        anchors.topMargin: 10
    }

    Rectangle
    {
        id: empty
        anchors.fill: parent
        anchors.margins: 10
        color: "transparent"

        Text
        {
            anchors.centerIn: parent
            text: qsTr("Not yet implemented")
            font.pixelSize: Regovar.theme.font.size.title
            color: Regovar.theme.primaryColor.back.light
        }
    }
}
