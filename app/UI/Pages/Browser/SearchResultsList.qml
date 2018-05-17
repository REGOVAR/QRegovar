import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Pages/Browser/Items"

Rectangle
{
    id: root
    color: Regovar.theme.boxColor.back
    border.width: 1
    border.color: Regovar.theme.boxColor.border
    radius: 2

    Flickable
    {
        id: imageContainer
        anchors.fill: parent
        anchors.margins: 5
        contentWidth: content.width
        contentHeight: content.height
        clip: true
        onContentYChanged: vbar.position = contentY / content.height;

        Behavior on contentY
        {
            NumberAnimation
            {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        Column
        {
            id: content
            width: root.width - 10

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
                    text: projectsResult.count + (projectsResult.count >= 100 ? "+" : "") + " " + (projectsResult.count > 1 ? qsTr("Folders") : qsTr("Folder"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: projectsResult.model

                    BrowserItemProject
                    {
                        width: root.width - 10
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
                    text: analysessResult.count + (analysessResult.count >= 100 ? "+" : "") + " " + (analysessResult.count > 1 ? qsTr("Analyses") : qsTr("Analysis"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: analysessResult.model
                    BrowserItemAnalysis
                    {
                        width: root.width - 10
                        date: model.modelData.update_date
                        name: model.modelData.name
                        status: model.modelData.status
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
                    text: filesResult.count + (filesResult.count >= 100 ? "+" : "") + " " + (filesResult.count > 1 ? qsTr("Files") : qsTr("File"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: filesResult.model
                    BrowserItemFile
                    {
                        width: root.width - 10
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
                    width: root.width - 10
                    text: subjectsResult.count + (subjectsResult.count >= 100 ? "+" : "") + " " + (subjectsResult.count > 1 ? qsTr("Subjects") : qsTr("Subject"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Repeater
                {
                    model: subjectsResult.model
                    BrowserItemSubject
                    {
                        width: root.width - 10
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
                    text: samplesResult.count + (samplesResult.count >= 100 ? "+" : "") + " " + (samplesResult.count > 1 ? qsTr("Samples") : qsTr("Sample"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: samplesResult.model
                    BrowserItemSample
                    {
                        width: root.width - 10
                        date: model.modelData.update_date
                        name: model.modelData.name
                        refid: model.modelData.reference_id
                        subject: model.modelData.subject_id > 0 ? regovar.subjectsManager.getOrCreateSubject(model.modelData.subject_id).subjectUI : null

                        onClicked: regovar.getSampleInfo(model.modelData.id)
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
                    text: phenotypesResult.count + (phenotypesResult.count >= 100 ? "+" : "") + " " + (phenotypesResult.count > 1 ? qsTr("Phenotypes") : qsTr("Phenotype"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: phenotypesResult.model
                    BrowserItemPhenotype
                    {
                        width: root.width - 10
                        phenotypeId: model.modelData.id
                        label: model.modelData.label
                        onClicked: regovar.getPhenotypeInfo(phenotypeId)
                    }
                }
            }
            // Disease
            Column
            {
                id: diseasesResult
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
                    text: diseasesResult.count + (diseasesResult.count >= 100 ? "+" : "") + " " + (diseasesResult.count > 1 ? qsTr("Diseases") : qsTr("Disease"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: diseasesResult.model
                    BrowserItemPhenotype
                    {
                        width: root.width - 10
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
                    text: genesResult.count + (genesResult.count >= 100 ? "+" : "") + " " + (genesResult.count > 1 ? qsTr("Genes") : qsTr("Gene"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: genesResult.model
                    BrowserItemGene
                    {
                        width: root.width - 10
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
                    text: variantsResult.count + (variantsResult.count >= 100 ? "+" : "") + " " + (variantsResult.count > 1 ? qsTr("Variants") : qsTr("Variant"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: variantsResult.model
                    BrowserItemVariant
                    {
                        width: root.width - 10
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
                    text: usersResult.count + (usersResult.count >= 100 ? "+" : "") + " " + (pipelinesResult.count > 1 ? qsTr("Pipelines") : qsTr("Pipeline"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: pipelinesResult.model
                    BrowserItemPipeline
                    {
                        width: root.width - 10
                        pipelineId: model.modelData.id
                        name: model.modelData.name
                        date: regovar.formatDate(model.modelData.installation_date)
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
                    text: panelsResult.count + (panelsResult.count >= 100 ? "+" : "") + " " + (panelsResult.count > 1 ? qsTr("Panels") : qsTr("Panel"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: panelsResult.model
                    BrowserItemPanel
                    {
                        width: root.width - 10
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
                    text: usersResult.count + (usersResult.count >= 100 ? "+" : "") + " " + (usersResult.count > 1 ? qsTr("Users") : qsTr("User"))
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater
                {
                    model: usersResult.model
                    BrowserItemUser
                    {
                        width: root.width - 10
                        userId: model.modelData.id
                        fullname: model.modelData.firstname + " " + model.modelData.lastname
                        date: model.modelData.update_date
                        onClicked: regovar.getUserInfo(model.modelData.id)
                    }
                }
            }
        }

    }


    ScrollBar
    {
        id: vbar
        hoverEnabled: true
        orientation: Qt.Vertical
        size: root.height / content.height
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        policy: ScrollBar.AlwaysOn
        onPositionChanged: if (pressed)
        {
            imageContainer.contentY = vbar.position * content.height;
        }
    }

    function scrollTo(newY)
    {
        imageContainer.contentY = newY * content.height;
    }

    function displayresults(results)
    {
        projectsResult.visible = "project" in results && results["project"];
        analysessResult.visible = "analysis" in results && results["analysis"];
        filesResult.visible = "file" in results && results["file"];
        subjectsResult.visible = "subject" in results && results["subject"];
        samplesResult.visible = "sample" in results && results["sample"];
        phenotypesResult.visible = "phenotype" in results && results["phenotype"];
        diseasesResult.visible = "disease" in results && results["disease"];
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
        if (diseasesResult.visible)
        {
            diseasesResult.model = results["disease"];
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
            usersResult.model = results["user"];
        }
    }
}
