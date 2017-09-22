import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model

    property bool isEmpty: true
    property bool isLoading: false


    Connections
    {
        target: regovar
        onSearchResultChanged:
        {
            console.log("search result : " + regovar.searchResult["total_result"]);
            isEmpty = regovar.searchResult["total_result"] === 0;
            displayresults(regovar.searchResult);
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

        TextField
        {
            property var formerSearch: ""
            anchors.fill: header
            anchors.margins: 10
            text: regovar.searchRequest
            placeholderText: qsTr("Search projects, subjects, samples, analyses, panels...")
            onEditingFinished:
            {
                if (formerSearch != text)
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
        mainColor: Regovar.theme.frontColor.success
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
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 10 : 10
        color: "transparent"

        Text
        {
            anchors.centerIn: parent
            text: "No result"
            font.pixelSize: Regovar.theme.font.size.title
            color: Regovar.theme.primaryColor.back.light
        }
    }


    Rectangle
    {
        id: resultsList
        visible: !isEmpty
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10


        color: "transparent"

        Text
        {
            anchors.top: parent.top
            text: regovar.searchResult["total_result"] + " " + ( (regovar.searchResult["total_result"] > 1 ) ? qsTr("results found") : qsTr("result found"))
            font.pixelSize: Regovar.theme.font.size.header
            height: Regovar.theme.font.boxSize.header
            color: Regovar.theme.primaryColor.back.dark
        }


        ScrollView
        {
            id: scrollarea
            anchors.fill: parent
            anchors.topMargin: Regovar.theme.font.boxSize.title + 5
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                anchors.left: parent.left
                anchors.right: parent.right

                // Projects
                Column
                {
                    id: projectsResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: "" + projectsResult.count + " " + (projectsResult.count > 1 ? qsTr("Projects") : qsTr("Project"))
                        font.pixelSize: Regovar.theme.font.size.control
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.control
                    }


                    Repeater
                    {
                        model: projectsResult.model
                        onModelChanged: projectsResult.count = projectsResult.model.length

                        SearchResultProject
                        {
                            width: scrollarea.viewport.width
                            date: model.modelData.update_date
                            name: model.modelData.name

                            onClicked:
                            {
                                regovar.loadProject(model.modelData.id);
                                Regovar.reloadProjectsOpenEntries();
                                buildPages(menuModel.model[2]["sublevel"]);
                                // select currentEntry
                                Regovar.menuModel.selectedIndex=[2, regovar.projectsOpen.length,0];
                            }
                        }
                    }
                }

                // Analyses
                Column
                {
                    id: analysessResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: "" + analysessResult.count + " " + (analysessResult.count > 1 ? qsTr("Analyses") : qsTr("Analysis"))
                        font.pixelSize: Regovar.theme.font.size.control
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.control
                    }

                    Repeater
                    {
                        model: analysessResult.model
                        onModelChanged: analysessResult.count = analysessResult.model.length
                        SearchResultAnalysis
                        {
                            width: scrollarea.viewport.width
                            date: model.modelData.update_date
                            name: model.modelData.name
                            projectName: model.modelData.project.name

                            onClicked: regovar.loadAnalysis(model.modelData.id)
                        }
                    }
                }

                // Subjects
                Column
                {
                    id: subjectsResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        width: scrollarea.viewport.width
                        text: "" + subjectsResult.count + " " + subjectsResult.count > 1 ? qsTr("Subjects") : qsTr("Subject")
                        font.pixelSize: Regovar.theme.font.size.control
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.control
                    }
                    Repeater
                    {
                        model: subjectsResult.model
                        Row
                        {
                            Row
                            {
                                Text
                                {
                                    width: Regovar.theme.font.boxSize.control
                                    font.pixelSize: Regovar.theme.font.size.control
                                    font.family: Regovar.theme.icons.name
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    text: "b"
                                }
                                Text
                                {
                                    font.pixelSize: Regovar.theme.font.size.control
                                    font.family: Regovar.theme.font.familly
                                    color: Regovar.theme.frontColor.normal
                                    verticalAlignment: Text.AlignVCenter
                                    text: firstname + " " + lastname + "(" + identifiant + ")"
                                }
                            }
                        }
                    }
                }

                // Samples
                Column
                {
                    id: samplesResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: "" + samplesResult.count + " " + (samplesResult.count > 1 ? qsTr("Samples") : qsTr("Sample"))
                        font.pixelSize: Regovar.theme.font.size.control
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.control
                    }

                    Repeater
                    {
                        model: samplesResult.model
                        onModelChanged: samplesResult.count = samplesResult.model.length
                        SearchResultSample
                        {
                            width: scrollarea.viewport.width
                            date: model.modelData.update_date
                            name: model.modelData.name
                            onClicked: console.log("open sample " + model.modelData.id) // regovar.loadAnalysis(model.modelData.id)
                        }
                    }
                }

                // Phenotype
                Column
                {
                    id: phenotypesResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: qsTr("Phenotypes") + " (" + phenotypesResult.count + ")"
                    }

                    Repeater
                    {
                        model: phenotypesResult.model
                        Row
                        {
                            Text
                            {
                                width: Regovar.theme.font.boxSize.control
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.icons.name
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: "K"
                            }
                            Text
                            {
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.font.familly
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: model.modelData.name
                            }
                        }
                    }
                }

                // Gene
                Column
                {
                    id: genesResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: qsTr("Genes") + " (" + genesResult.count + ")"
                    }

                    Repeater
                    {
                        model: genesResult.model
                        Row
                        {
                            Text
                            {
                                width: Regovar.theme.font.boxSize.control
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.icons.name
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: "j"
                            }
                            Text
                            {
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.font.familly
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: model.modelData.name
                            }
                        }
                    }
                }

                // Variant
                Column
                {
                    id: variantsResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: qsTr("Variants") + " (" + variantsResult.count + ")"
                    }

                    Repeater
                    {
                        model: variantsResult.model
                        Row
                        {
                            Text
                            {
                                width: Regovar.theme.font.boxSize.control
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.icons.name
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: "j"
                            }
                            Text
                            {
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.font.familly
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: model.modelData.name
                            }
                        }
                    }
                }

                // Pipeline
                Column
                {
                    id: pipelinesResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: qsTr("Pipelines") + " (" + pipelinesResult.count + ")"
                    }

                    Repeater
                    {
                        model: pipelinesResult.model
                        Row
                        {
                            Text
                            {
                                width: Regovar.theme.font.boxSize.control
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.icons.name
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: "j"
                            }
                            Text
                            {
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.font.familly
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: model.modelData.name
                            }
                        }
                    }
                }

                // Panel
                Column
                {
                    id: panelsResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: qsTr("Panels") + " (" + panelsResult.count + ")"
                    }

                    Repeater
                    {
                        model: panelsResult.model
                        Row
                        {
                            Text
                            {
                                width: Regovar.theme.font.boxSize.control
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.icons.name
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: "q"
                            }
                            Text
                            {
                                font.pixelSize: Regovar.theme.font.size.control
                                font.family: Regovar.theme.font.familly
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: model.modelData.name
                            }
                        }
                    }
                }
            }
        }

        Rectangle
        {
            anchors.left: resultsList.left
            anchors.right: resultsList.right
            anchors.bottom: scrollarea.top
            height: 1
            color: Regovar.theme.primaryColor.back.normal
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
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 10 : 10

        color: Regovar.theme.backgroundColor.main

        BusyIndicator
        {
            anchors.centerIn: parent
        }
    }

    function displayresults(results)
    {
        projectsResult.visible = results["project"].length > 0;
        analysessResult.visible = results["analysis"].length > 0;
        subjectsResult.visible = results["subject"].length > 0;
        samplesResult.visible = results["sample"].length > 0;
        phenotypesResult.visible = results["phenotype"].length > 0;
        genesResult.visible = results["gene"].length > 0;
        variantsResult.visible = results["variant"].length > 0;
        pipelinesResult.visible = results["pipeline"].length > 0;
        panelsResult.visible = results["panel"].length > 0;

        if (projectsResult.visible)
        {
            projectsResult.model = results["project"];
            projectsResult.count = results["project"].length;
        }
        if (analysessResult.visible)
        {
            analysessResult.model = results["analysis"];
            analysessResult.count = results["analysis"].length;
        }
        if (subjectsResult.visible)
        {
            subjectsResult.model = results["subject"];
            analysessResult.count = results["subject"].length;
        }
        if (samplesResult.visible)
        {
            samplesResult.model = results["sample"];
            analysessResult.count = results["sample"].length;
        }
        if (phenotypesResult.visible)
        {
            phenotypesResult.model = results["phenotype"];
            analysessResult.count = results["phenotype"].length;
        }
        if (genesResult.visible)
        {
            genesResult.model = results["gene"];
            analysessResult.count = results["gene"].length;
        }
        if (variantsResult.visible)
        {
            variantsResult.model = results["variant"];
            analysessResult.count = results["variant"].length;
        }
        if (pipelinesResult.visible)
        {
            pipelinesResult.model = results["pipeline"];
            analysessResult.count = results["pipeline"].length;
        }
        if (panelsResult.visible)
        {
            panelsResult.model = results["panel"];
            analysessResult.count = results["panel"].length;
        }
    }
}
