import QtQuick 2.9
import Qt.labs.settings 1.0
import QtQuick.Window 2.3

import "Regovar"
import "Dialogs"
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

    menuModel: regovar.mainMenu
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


//    Connections
//    {
//        target: regovar.projectsManager
//        onProjectsOpenListChanged:
//        {
//            console.log ("MainMenu: Reload projects open list");
//            Regovar.reloadProjectsOpenEntries();
//            buildPages(menuModel.model[2]["sublevel"], Regovar.currentopeningProject);
//            // select currentEntry
//            Regovar.menuModel.selectedIndex=[2, regovar.projectsManager.projectsOpenList.length, 0];
//        }
//    }

//    Connections
//    {
//        target: regovar.subjectsManager
//        onSubjectsOpenListChanged:
//        {
//            console.log ("RefreshMenu (subjects)");
//            // Step 1 : update main menu entries
//            var entryModel = Regovar.refreshSubjectsEntries();
//            // Step 2 : Build pages for the new entry
//            if (entryModel)
//            {
//                buildPages(menuModel.model[3]["sublevel"], entryModel);
//            }
//        }
//    }
//    Connections
//    {
//        target: regovar.subjectsManager
//        onSubjectOpenChanged:
//        {
//            Regovar.menuModel.selectedIndex=[3, idx+1, 0];
//        }
//    }




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
    // Creation wizards
    //

    NewProjectDialog
    {
        id: newProjectDialog

        Connections
        {
            target: regovar
            onNewProjectWizardOpen: { newProjectDialog.reset(); newProjectDialog.open(); }
        }
    }

    NewAnalysisDialog
    {
        id: newAnalysisDialog

        Connections
        {
            target: regovar
            onNewAnalysisWizardOpen: { newAnalysisDialog.reset(); newAnalysisDialog.open(); }
        }
    }

    NewSubjectDialog
    {
        id: newSubjectDialog

        Connections
        {
            target: regovar
            onNewSubjectWizardOpen: { newSubjectDialog.reset(); newSubjectDialog.open(); }
        }
    }


    //
    // Info panels
    //

    // File info dialog
    Window
    {
        id: fileInfoDialog
        title: qsTr("File Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        minimumHeight : 300
        minimumWidth : 300

        FileInformations
        {
            id: fileInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onFileInformationSearching: { fileInfoPanel.reset(); fileInfoDialog.show(); }
        }
    }

    // Gene info dialog
    Window
    {
        id: geneInfoDialog
        title: qsTr("Gene Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        minimumHeight : 300
        minimumWidth : 300

        GeneInformations
        {
            id: geneInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onGeneInformationSearching: { geneInfoPanel.reset(); geneInfoDialog.show(); }
        }
    }

    // Panel info dialog
    Window
    {
        id: panelInfoDialog
        title: qsTr("Panel Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        minimumHeight : 300
        minimumWidth : 300

        PanelInformations
        {
            id: panelInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onPanelInformationSearching: { panelInfoPanel.reset(); panelInfoDialog.show(); }
        }
    }

    // Phenotype info dialog
    Window
    {
        id: phenotypeInfoDialog
        title: qsTr("Phenotype Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        minimumHeight : 300
        minimumWidth : 300

        PhenotypeInformations
        {
            id: phenotypeInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onPhenotypeInformationSearching: { phenotypeInfoPanel.reset(); phenotypeInfoDialog.show(); }
        }
    }

    // Pipeline info dialog
    Window
    {
        id: pipelineInfoDialog
        title: qsTr("Pipeline Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        minimumHeight : 300
        minimumWidth : 300

        PipelineInformations
        {
            id: pipelineInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onPipelineInformationSearching: { pipelineInfoPanel.reset(); pipelineInfoDialog.show(); }
        }
    }

    // Sample info dialog
    Window
    {
        id: sampleInfoDialog
        title: qsTr("Sample Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        minimumHeight : 300
        minimumWidth : 300

        SampleInformations
        {
            id: sampleInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onSampleInformationSearching: { sampleInfoPanel.reset(); sampleInfoDialog.show(); }
        }
    }

    // User info dialog
    Window
    {
        id: userInfoDialog
        title: qsTr("User Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        minimumHeight : 300
        minimumWidth : 300

        UserInformations
        {
            id: userInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onUserInformationSearching: { userInfoPanel.reset(); userInfoDialog.show(); }
        }
    }

    // Variant info panel
    Window
    {
        id: variantInfoDialog
        title: qsTr("Variant Informations")
        visible: false
        modality: Qt.NonModal
        width: 500
        height: 400
        minimumHeight : 300
        minimumWidth : 300

        VariantInformations
        {
            id: variantInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onVariantInformationSearching: { variantInfoPanel.reset(); variantInfoDialog.show(); }
        }
    }
}
