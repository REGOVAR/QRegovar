import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/InformationPanel/Phenotype"

Dialog
{
    id: root

    title: qsTr("Add phenotype entry")

    signal addPhenotype(var hpo_id)

    // modality: Qt.NonModal
    width: 600
    height: 400
    onVisibleChanged:
    {
        if (visible)
        {
            searchField.text = "";
            formerSearch = "";
            resultsModel.clear();
        }
    }

    property string formerSearch: ""
    function search()
    {
        if (formerSearch != searchField.text)
        {
            regovar.phenotypesManager.search(searchField.text);
        }
    }


    Connections
    {
        target: regovar.phenotypesManager
        onPhenotypeSearchDone:
        {
            if (success)
            {
                resultsModel.clear();
                for(var idx in result)
                {
                    resultsModel.append(result[idx]);
                }
            }
        }
    }

    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.alt



        DialogHeader
        {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            iconText: "à"
            title: qsTr("Add Phenotype entry")
            text: qsTr("Search a phenotype or a disease (OMIM/ORPHANET) and add it your list.")
        }



        GridLayout
        {
            id: tabView
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
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
                displayClearButton: true
                placeholder: qsTr("Search gene, phenotype or disease...")
                onEditingFinished: search()
            }

            Button
            {
                text: qsTr("Search")
                onClicked: search()
            }

            Rectangle
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.columnSpan: 2
                radius: 2
                color: Regovar.theme.boxColor.back

                ListView
                {
                    id: results
                    anchors.fill: parent
                    anchors.margins: 1
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}

                    model: ListModel
                    {
                        id: resultsModel
                    }

                    delegate: PhenotypeSearchEntry
                    {
                        width: 100// scrollarea.viewport.width
                        height: 20
                        label: model.label
                        onAdded:
                        {
                            addPhenotype(model.id);
                            enabled = false;
                        }
                        onShowDetails:
                        {
                            regovar.getPhenotypeInfo(model.id);
                        }
                    }
                }
            }


        }

        Row
        {
            id: footer
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10

            height: Regovar.theme.font.boxSize.normal
            spacing: 10

            Button
            {
                text: qsTr("Close")
                onClicked: close()
            }
        }

        Rectangle
        {
            id: loadingIndicator
            anchors.fill : parent
            color: Regovar.theme.backgroundColor.alt
            visible: false

            BusyIndicator
            {
                anchors.centerIn: parent
            }
        }
    }

}
