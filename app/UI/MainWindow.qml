import QtQuick 2.9
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.2

import "Regovar"
import "InformationsPanel/File"
import "InformationsPanel/Gene"
import "InformationsPanel/Panel"
import "InformationsPanel/Phenotype"
import "InformationsPanel/Pipeline"
import "InformationsPanel/Sample"
import "InformationsPanel/User"
import "InformationsPanel/Variant"

GenericWindow
{
    id: root
    width: 800
    height: 600

    property QtObject model

    onClosing: regovar.close()

    menuModel: Regovar.menuModel
    title: "Regovar - " + menuModel.mainTitle

    Settings
    {
        id: settings
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }
    Component.onCompleted:
    {
        Regovar.theme.themeId = regovar.settings.themeId
        Regovar.theme.fontSizeCoeff = regovar.settings.fontSize
        Regovar.helpInfoBoxDisplayed = regovar.settings.displayHelp
    }
    Component.onDestruction:
    {
        regovar.settings.themeId = Regovar.theme.themeId
        regovar.settings.fontSize = Regovar.theme.fontSizeCoeff
        regovar.settings.displayHelp = Regovar.helpInfoBoxDisplayed
        regovar.settings.save()
    }


    Connections
    {
        target: regovar.projectsManager
        onProjectsOpenListChanged:
        {
            console.log ("MainMenu: Reload projects open list");
            Regovar.reloadProjectsOpenEntries();
            buildPages(menuModel.model[2]["sublevel"], Regovar.currentopeningProject);
            // select currentEntry
            Regovar.menuModel.selectedIndex=[2, regovar.projectsManager.projectsOpenList.length, 0];
        }
    }

    Connections
    {
        target: regovar.subjectsManager
        onSubjectsOpenListChanged:
        {
            console.log ("RefreshMenu (subjects)");
            // Step 1 : update main menu entries
            var entryModel = Regovar.refreshSubjectsEntries();
            // Step 2 : Build pages for the new entry
            if (entryModel)
            {
                buildPages(menuModel.model[3]["sublevel"], entryModel);
            }
        }
    }
    Connections
    {
        target: regovar.subjectsManager
        onSubjectOpenChanged:
        {
            Regovar.menuModel.selectedIndex=[3, idx+1, 0];
        }
    }




//    Connections
//    {
//        target: regovar.subjectsManager
//        onSubjectCreationDone:
//        {
//            if (success)
//            {
//                console.log ("ReloadMenu (subjects)");
//                // Step 1 : update main menu entries
//                Regovar.refreshSubjectsMenu();
//                // Step 2 : Build page for the entry
//                buildPages(menuModel.model[3]["sublevel"], regovar.subjectsManager.subjectOpen);
//                // Step 3 : Select currentEntry
//                Regovar.menuModel.selectedIndex=[3, 0, 0]; // 0 because new entry always insert at first place in open list
//            }
//        }
//    }

    Connections
    {
        target: regovar.networkManager
        onWebsocketMessageReceived:
        {
            //console.log ("WS [" + action + "] " + data);
        }
    }

    function openSubject(subjectId)
    {
        // ask main model to add subject model into open entries

    }







    //
    // Info panels
    //

    // File info dialog
    Dialog
    {
        id: fileInfoDialog
        title: qsTr("File Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400

        contentItem: FileInformations
        {
            id: fileInfoPanel

        }

        Connections
        {
            target: regovar
            onFileInformationSearching: { if (analysisId == -1) { fileInfoPanel.reset(); fileInfoDialog.open(); }}
        }
    }

    // Gene info dialog
    Dialog
    {
        id: geneInfoDialog
        title: qsTr("Gene Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400

        contentItem: GeneInformations
        {
            id: geneInfoPanel
        }

        Connections
        {
            target: regovar
            onGeneInformationSearching: { if (analysisId == -1) { geneInfoPanel.reset(); geneInfoDialog.open(); }}
        }
    }

    // Panel info dialog
    Dialog
    {
        id: panelInfoDialog
        title: qsTr("Panel Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400

        contentItem: PanelInformations
        {
            id: panelInfoPanel
        }

        Connections
        {
            target: regovar
            onPanelInformationSearching: { if (analysisId == -1) { panelInfoPanel.reset(); panelInfoDialog.open(); }}
        }
    }

    // Phenotype info dialog
    Dialog
    {
        id: phenotypeInfoDialog
        title: qsTr("Phenotype Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400

        contentItem: PhenotypeInformations
        {
            id: phenotypeInfoPanel
        }

        Connections
        {
            target: regovar
            onPhenotypeInformationSearvhing: { if (analysisId == -1) { phenotypeInfoPanel.reset(); phenotypeInfoDialog.open(); }}
        }
    }

    // Pipeline info dialog
    Dialog
    {
        id: pipelineInfoDialog
        title: qsTr("Pipeline Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400

        contentItem: PipelineInformations
        {
            id: pipelineInfoPanel
        }

        Connections
        {
            target: regovar
            onPipelineInformationSearching: { if (analysisId == -1) { pipelineInfoPanel.reset(); pipelineInfoDialog.open(); }}
        }
    }

    // Sample info dialog
    Dialog
    {
        id: sampleInfoDialog
        title: qsTr("Sample Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400

        contentItem: SampleInformations
        {
            id: sampleInfoPanel
        }

        Connections
        {
            target: regovar
            onSampleInformationSearching: { if (analysisId == -1) { sampleInfoPanel.reset(); sampleInfoDialog.open(); }}
        }
    }

    // User info dialog
    Dialog
    {
        id: userInfoDialog
        title: qsTr("User Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        contentItem: UserInformations
        {
            id: userInfoPanel
        }

        Connections
        {
            target: regovar
            onUserInformationSearching: { if (analysisId == -1) { userInfoPanel.reset(); userInfoDialog.open(); }}
        }
    }

    // Variant info panel
    Dialog
    {
        id: variantInfoDialog
        title: qsTr("Variant Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400

        contentItem: VariantInformations
        {
            id: variantInfoPanel
        }

        Connections
        {
            target: regovar
            onVariantInformationSearching: { if (analysisId == -1) { variantInfoPanel.reset(); variantInfoDialog.open(); }}
        }
    }
}
