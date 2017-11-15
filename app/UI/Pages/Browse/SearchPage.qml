import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"

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
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
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
                            onClicked: regovar.openProject(model.modelData.id);
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
                        text: analysessResult.count + " " + (analysessResult.count > 1 ? qsTr("Analyses") : qsTr("Analysis"))
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
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

                            onClicked: regovar.openAnalysis(model.modelData.id)
                        }
                    }
                }

                // Files
                Column
                {
                    id: filesResult
                    visible: false
                    property int count: 0
                    property var model

                    Text
                    {
                        text: filesResult.count + " " + (filesResult.count > 1 ? qsTr("Files") : qsTr("File"))
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Repeater
                    {
                        model: filesResult.model
                        onModelChanged: filesResult.count = filesResult.model.length
                        SearchResultFile
                        {
                            width: scrollarea.viewport.width
                            fileId: model.modelData.id
                            date: model.modelData.update_date
                            filename: model.modelData.name
                            icon: fileInstance.extensionToIco(model.modelData.name.split(".").slice(-1).pop())
                            status: model.modelData.status

                            onClicked: console.log("open file " + model.modelData.id)
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
                        text: subjectsResult.count + " " + (subjectsResult.count > 1 ? qsTr("Subjects") : qsTr("Subject"))
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Repeater
                    {
                        model: subjectsResult.model
                        onModelChanged: subjectsResult.count = subjectsResult.model.length
                        SearchResultSubject
                        {
                            width: scrollarea.viewport.width
                            date: model.modelData.update_date
                            subjectId: model.modelData.id
                            identifier: model.modelData.identifier
                            firstname: model.modelData.firstname
                            lastname: model.modelData.lastname
                            sex: model.modelData.sex
                            age: model.modelData.age

                            onClicked: regovar.subjectsManager.openSubject(subjectId)
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
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
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
                            onClicked: console.log("open sample " + model.modelData.id)
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
                        text: phenotypesResult.count + " " + (phenotypesResult.count > 1 ? qsTr("Phenotypes") : qsTr("Phenotype"))
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Repeater
                    {
                        model: phenotypesResult.model
                        onModelChanged: phenotypesResult.count = phenotypesResult.model.length
                        SearchResultPhenotype
                        {
                            width: scrollarea.viewport.width
                            phenotypeId: model.modelData.id
                            label: model.modelData.label

                            onClicked: console.log("open phenotype " + phenotypeId)
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
                        text: genesResult.count + " " + (genesResult.count > 1 ? qsTr("Genes") : qsTr("Gene"))
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Repeater
                    {
                        model: genesResult.model
                        onModelChanged: genesResult.count = genesResult.model.length
                        SearchResultGene
                        {
                            width: scrollarea.viewport.width
                            geneId: model.modelData.id
                            symbol: model.modelData.symbol

                            onClicked: console.log("open gene " + geneId)
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
                        text: variantsResult.count + " " + (variantsResult.count > 1 ? qsTr("Variants") : qsTr("Variant"))
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Repeater
                    {
                        model: variantsResult.model
                        onModelChanged: variantsResult.count = variantsResult.model.length
                        SearchResultVariant
                        {
                            width: scrollarea.viewport.width
                            variantId: model.modelData.id
                            label: model.modelData.label
                            referenceId: model.modelData.ref_id
                            reference: model.modelData.ref_name
                            samples_count: model.modelData.sample_list.length
                            regovar_score: model.modelData.regovar_score

                            onClicked: console.log("open variant " + variantId + " (" + referenceId + ")")
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
                                width: Regovar.theme.font.boxSize.normal
                                font.pixelSize: Regovar.theme.font.size.normal
                                font.family: Regovar.theme.icons.name
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: "j"
                            }
                            Text
                            {
                                font.pixelSize: Regovar.theme.font.size.normal
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
                                width: Regovar.theme.font.boxSize.normal
                                font.pixelSize: Regovar.theme.font.size.normal
                                font.family: Regovar.theme.icons.name
                                color: Regovar.theme.frontColor.normal
                                verticalAlignment: Text.AlignVCenter
                                text: "q"
                            }
                            Text
                            {
                                font.pixelSize: Regovar.theme.font.size.normal
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
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

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
        filesResult.visible = results["file"].length > 0;
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
        if (filesResult.visible)
        {
            filesResult.model = results["file"];
            filesResult.count = results["file"].length;
        }
        if (subjectsResult.visible)
        {
            subjectsResult.model = results["subject"];
            subjectsResult.count = results["subject"].length;
        }
        if (samplesResult.visible)
        {
            samplesResult.model = results["sample"];
            samplesResult.count = results["sample"].length;
        }
        if (phenotypesResult.visible)
        {
            phenotypesResult.model = results["phenotype"];
            phenotypesResult.count = results["phenotype"].length;
        }
        if (genesResult.visible)
        {
            genesResult.model = results["gene"];
            genesResult.count = results["gene"].length;
        }
        if (variantsResult.visible)
        {
            variantsResult.model = results["variant"];
            variantsResult.count = results["variant"].length;
        }
        if (pipelinesResult.visible)
        {
            pipelinesResult.model = results["pipeline"];
            pipelinesResult.count = results["pipeline"].length;
        }
        if (panelsResult.visible)
        {
            panelsResult.model = results["panel"];
            panelsResult.count = results["panel"].length;
        }
    }
}
