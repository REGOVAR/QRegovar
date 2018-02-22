import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"

ScrollView
{
    id: root
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

            Text
            {
                text: projectsResult.count + " " + (projectsResult.count > 1 ? qsTr("Projects") : qsTr("Project"))
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }

            Repeater
            {
                model: projectsResult.model

                SearchResultProject
                {
                    width: root.viewport.width
                    date: model.modelData.update_date
                    name: model.modelData.name
                    onClicked: regovar.projectsManager.openProject(model.modelData.id);
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

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
                SearchResultAnalysis
                {
                    width: root.viewport.width
                    date: model.modelData.update_date
                    name: model.modelData.name
                    projectName: model.modelData.project.name
                    onClicked: regovar.analysesManager.openAnalysis("analysis", model.modelData.id)
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

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
                SearchResultFile
                {
                    width: root.viewport.width
                    fileId: model.modelData.id
                    date: model.modelData.update_date
                    filename: model.modelData.name
                    icon: fileInstance.extensionToIco(model.modelData.name.split(".").slice(-1).pop())
                    status: model.modelData.status
                    onClicked: regovar.getFileInfo(model.modelData.id)
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

            Text
            {
                width: root.viewport.width
                text: subjectsResult.count + " " + (subjectsResult.count > 1 ? qsTr("Subjects") : qsTr("Subject"))
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
            Repeater
            {
                model: subjectsResult.model
                SearchResultSubject
                {
                    width: root.viewport.width
                    date: model.modelData.update_date
                    subjectId: model.modelData.id
                    identifier: model.modelData.identifier
                    firstname: model.modelData.firstname
                    lastname: model.modelData.lastname
                    sex: model.modelData.sex
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

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
                SearchResultSample
                {
                    width: root.viewport.width
                    date: model.modelData.update_date
                    name: model.modelData.name
                    refid: model.modelData.reference_id
                    subject: model.modelData.subject_id > 0 ? regovar.subjectsManager.getOrCreateSubject(model.modelData.subject_id).subjectUI : null

                    onClicked: regovar.getSampleInfo(model.modelData.reference_id, model.modelData.id)
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

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
                SearchResultPhenotype
                {
                    width: root.viewport.width
                    phenotypeId: model.modelData.id
                    label: model.modelData.label
                    onClicked: regovar.getPhenotypeInfo(phenotypeId)
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

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
                SearchResultGene
                {
                    width: root.viewport.width
                    geneId: model.modelData.id
                    symbol: model.modelData.symbol
                    onClicked: regovar.getGeneInfo(model.modelData.symbol)
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

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
                SearchResultVariant
                {
                    width: root.viewport.width
                    variantId: model.modelData.id
                    label: model.modelData.label
                    referenceId: model.modelData.ref_id
                    reference: model.modelData.ref_name
                    samples_count: model.modelData.sample_list.length
                    regovar_score: model.modelData.regovar_score
                    onClicked: regovar.getVariantInfo(referenceId, variantId)
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

            Text
            {
                text: usersResult.count + " " + (pipelinesResult.count > 1 ? qsTr("Pipelines") : qsTr("Pipeline"))
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }

            Repeater
            {
                model: pipelinesResult.model
                SearchResultPipeline
                {
                    width: root.viewport.width
                    pipelineId: model.modelData.id
                    name: model.modelData.name
                    date: model.modelData.update_date
                    onClicked: regovar.getPipelineInfo(model.modelData.id)
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
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }

            Text
            {
                text: panelsResult.count + " " + (panelsResult.count > 1 ? qsTr("Panels") : qsTr("Panel"))
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }

            Repeater
            {
                model: panelsResult.model
                SearchResultPanel
                {
                    width: root.viewport.width
                    panelId: model.modelData.id
                    name: model.modelData.name
                    owner: model.modelData.owner
                    date: model.modelData.update_date
                    onClicked: regovar.getPanelInfo(panelId)
                }
            }
        }

        // User
        Column
        {
            id: usersResult
            visible: false
            property int count: 0
            property var model
            onModelChanged:
            {
                count = model.length;
                visible = count > 0;
            }
            Text
            {
                text: usersResult.count + " " + (usersResult.count > 1 ? qsTr("Users") : qsTr("User"))
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }

            Repeater
            {
                model: usersResult.model
                SearchResultUser
                {
                    width: root.viewport.width
                    userId: model.modelData.id
                    fullname: model.modelData.fullname
                    date: model.modelData.update_date
                    onClicked: regovar.getUserInfo(model.modelData.id)
                }
            }
        }
    }


    function displayresults(results)
    {
        projectsResult.visible = "project" in results && results["project"];
        analysessResult.visible = "analysis" in results && results["analysis"];
        filesResult.visible = "file" in results && results["file"];
        subjectsResult.visible = "subject" in results && results["subject"];
        samplesResult.visible = "sample" in results && results["sample"];
        phenotypesResult.visible = "phenotype" in results && results["phenotype"];
        genesResult.visible = "gene" in results && results["gene"];
        variantsResult.visible = "variant" in results && results["variant"];
        pipelinesResult.visible = "pipeline" in results && results["pipeline"];
        panelsResult.visible = "panel" in results && results["panel"];
        usersResult.visible = "user" in results && results["user"];

        if (projectsResult.visible)
        {
            projectsResult.model = results["project"];
            projectsResult.count = results["project"].length;
        }
        if (analysessResult.visible)
        {
            analysessResult.model = results["analysis"];
        }
        if (filesResult.visible)
        {
            filesResult.model = results["file"];
        }
        if (subjectsResult.visible)
        {
            subjectsResult.model = results["subject"];
        }
        if (samplesResult.visible)
        {
            samplesResult.model = results["sample"];
        }
        if (phenotypesResult.visible)
        {
            phenotypesResult.model = results["phenotype"];
        }
        if (genesResult.visible)
        {
            genesResult.model = results["gene"];
        }
        if (variantsResult.visible)
        {
            variantsResult.model = results["variant"];
        }
        if (pipelinesResult.visible)
        {
            pipelinesResult.model = results["pipeline"];
        }
        if (panelsResult.visible)
        {
            panelsResult.model = results["panel"];
        }
        if (usersResult.visible)
        {
            usersResult.model = results["panel"];
        }
    }
}
