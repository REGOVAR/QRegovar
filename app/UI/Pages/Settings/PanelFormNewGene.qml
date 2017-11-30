import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property string formerSearch: ""
    function search()
    {
        if (formerSearch != searchField.text)
        {
            regovar.samplesManager.search(searchField.text);
            formerSearch = searchField.text;
        }
    }


    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 10

        rows: 2
        columns: 2
        rowSpacing: 10
        columnSpacing: 10


        TextField
        {
            id: searchField
            Layout.fillWidth: true
            iconLeft: "z"
            text: regovar.searchRequest
            placeholderText: qsTr("Search gene, phenotype or disease...")
            onEditingFinished: search()
        }

        Button
        {
            text: qsTr("Search")
            onClicked: search();
        }

        ScrollView
        {
            id: scrollarea
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 2
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {

            }
        }
    }

    // Borders
    Rectangle
    {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1

        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1

        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1

        color: Regovar.theme.boxColor.border
    }
}
