import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model

    property bool isEmpty: true
    property bool isLoading: false

    File { id: fileInstance }

    Connections
    {
        target: regovar
        onSearchResultChanged:
        {
            console.log("search result : " + regovar.searchResult["total_result"]);
            isEmpty = regovar.searchResult["total_result"] === 0;
            var m = regovar.searchResult;
            var resume = [
                {"active": m.hasOwnProperty("project") && m["project"].length > 0, "key": "project",
                 "label": m["project"].length + " " + (m["project"].length > 1 ? qsTr("Folders") : qsTr("Folder"))},
                {"active": m.hasOwnProperty("analysis") && m["analysis"].length > 0, "key": "analysis",
                 "label": m["analysis"].length + " " + (m["analysis"].length > 1 ? qsTr("Analyses") : qsTr("Analysis"))},
                {"active": m.hasOwnProperty("file") && m["file"].length > 0, "key": "file",
                 "label": m["file"].length + " " + (m["file"].length > 1 ?  qsTr("Files") : qsTr("File"))},
                {"active": m.hasOwnProperty("subject") && m["subject"].length > 0, "key": "subject",
                 "label": m["subject"].length + " " + (m["subject"].length > 1 ? qsTr("Subjects") : qsTr("Subject"))},
                {"active": m.hasOwnProperty("sample") && m["sample"].length > 0, "key": "sample",
                 "label": m["sample"].length + " " + (m["sample"].length > 1 ? qsTr("Samples") : qsTr("Sample"))},
                {"active": m.hasOwnProperty("phenotype") && m["phenotype"].length > 0, "key": "phenotype",
                 "label": m["phenotype"].length + " " + (m["phenotype"].length > 1 ? qsTr("Phenotypes") : qsTr("Phenotype"))},
                {"active": m.hasOwnProperty("disease") && m["disease"].length > 0, "key": "disease",
                 "label": m["disease"].length + " " + (m["disease"].length > 1 ? qsTr("Diseases") : qsTr("Disease"))},
                {"active": m.hasOwnProperty("gene") && m["gene"].length > 0, "key": "gene",
                 "label": m["gene"].length + " " + (m["gene"].length > 1 ? qsTr("Genes") : qsTr("Gene"))},
                {"active": m.hasOwnProperty("variant") && m["variant"].length > 0, "key": "variant",
                 "label": m["variant"].length + " " + (m["variant"].length > 1 ? qsTr("Variants") : qsTr("Variant"))},
                {"active": m.hasOwnProperty("pipeline") && m["pipeline"].length > 0, "key": "pipeline",
                 "label": m["pipeline"].length + " " + (m["pipeline"].length > 1 ?qsTr("Pipelines") : qsTr("Pipeline"))},
                {"active": m.hasOwnProperty("panel") && m["panel"].length > 0, "key": "panel",
                 "label": m["panel"].length + " " + (m["panel"].length > 1 ? qsTr("Panels") : qsTr("Panel"))},
                {"active": m.hasOwnProperty("user") && m["user"].length > 0, "key": "user",
                 "label": m["user"].length + " " + (m["user"].length > 1 ? qsTr("Users") : qsTr("User"))}
            ];

            var t = 0;
            for (var r in resume)
            {
                if (resume[r]["active"])
                {
                    resume[r]["position"] = t;
                    t += 1 + m[resume[r]["key"]].length;
                }
            }
            for (var r in resume)
            {
                if (resume[r]["active"])
                {
                    resume[r]["position"] = resume[r]["position"] / t;
                }
            }

            resumeRepeater.model = resume;

            searchResults.displayresults(regovar.searchResult);
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

        ConnectionStatus
        {
            id: connectionStatus
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }

        TextField
        {
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.right: connectionStatus.left
            anchors.margins: 10

            property string formerSearch: ""
            iconLeft: "z"
            displayClearButton: true
            text: regovar.searchRequest
            placeholder: qsTr("Search subjects, samples, analyses, panels...")
            onEditingFinished:
            {
                if (formerSearch != text && text != "")
                {
                    regovar.search(text);
                    formerSearch = text;
                }
            }
        }
    }

    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("Use the field above to search everything in Regovar. Then double click on the result below to open it and see details.")
    }

    Rectangle
    {
        id: empty
        visible: isEmpty
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10
        color: "transparent"

        Text
        {
            anchors.centerIn: parent
            text: "No result"
            font.pixelSize: Regovar.theme.font.size.title
            color: Regovar.theme.primaryColor.back.light
        }
    }


    ColumnLayout
    {
        id: resultsList
        visible: !isEmpty
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10
        spacing: 10

        Text
        {
            text: regovar.searchResult["total_result"] + " " + ( (regovar.searchResult["total_result"] > 1 ) ? qsTr("results found") : qsTr("result found"))
            font.pixelSize: Regovar.theme.font.size.header
            height: Regovar.theme.font.boxSize.header
            color: Regovar.theme.primaryColor.back.dark
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 3 * Regovar.theme.font.boxSize.normal + 10
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            radius: 2

            GridLayout
            {
                anchors.fill: parent
                anchors.margins: 5
                columns: 4

                Repeater
                {
                    id: resumeRepeater
                    Text
                    {
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: modelData.active ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
                        verticalAlignment: Text.AlignVCenter
                        text: modelData.label

                        MouseArea
                        {
                            anchors.fill: parent
                            enabled: modelData.active
                            hoverEnabled: modelData.active
                            onEntered: parent.color = Regovar.theme.secondaryColor.back.normal
                            onExited: parent.color = modelData.active ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
                            onClicked: searchResults.scrollTo(modelData.position)
                        }
                    }
                }
            }
        }

        SearchResultsList
        {
            id: searchResults
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }



    Rectangle
    {
        id: loading
        visible: regovar.searchInProgress
        z: 100
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        color: Regovar.theme.backgroundColor.main

        BusyIndicator
        {
            anchors.centerIn: parent
        }
    }
}
