import QtQuick 2.9
import Qt.labs.settings 1.0
import QtQuick.Window 2.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Dialogs"
import "qrc:/qml/InformationPanel/File"
import "qrc:/qml/InformationPanel/Gene"
import "qrc:/qml/InformationPanel/Panel"
import "qrc:/qml/InformationPanel/Phenotype"
import "qrc:/qml/InformationPanel/Pipeline"
import "qrc:/qml/InformationPanel/Sample"
import "qrc:/qml/InformationPanel/User"
import "qrc:/qml/InformationPanel/Variant"

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
            onNewProjectWizardOpen: { newProjectDialog.reset(); newProjectDialog.show(); }
        }
    }

    NewAnalysisDialog
    {
        id: newAnalysisDialog

        Connections
        {
            target: regovar
            onNewAnalysisWizardOpen: { newAnalysisDialog.reset(); newAnalysisDialog.show(); }
        }
    }

    NewSubjectDialog
    {
        id: newSubjectDialog

        Connections
        {
            target: regovar
            onNewSubjectWizardOpen: { newSubjectDialog.reset(); newSubjectDialog.show(); }
        }
    }


    //
    // Info panels
    //

    // File info dialog
    Window
    {
        id: fileInfoDialog
        title: qsTr("File Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        FileInformation
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
        title: qsTr("Gene Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        GeneInformation
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
        title: qsTr("Panel Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        PanelInformation
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
        title: qsTr("Phenotype Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        PhenotypeInformation
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
    Window
    {
        id: diseaseInfoDialog
        title: qsTr("Disease Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        DiseaseInformation
        {
            id: diseaseInfoPanel
            anchors.fill: parent
        }

        Connections
        {
            target: regovar
            onDiseaseInformationSearching: { diseaseInfoPanel.reset(); diseaseInfoDialog.show(); }
        }
    }

    // Pipeline info dialog
    Window
    {
        id: pipelineInfoDialog
        title: qsTr("Pipeline Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        PipelineInformation
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
        title: qsTr("Sample Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        SampleInformation
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
        title: qsTr("User Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        UserInformation
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
        title: qsTr("Variant Information")
        visible: false
        modality: Qt.NonModal
        width: 700
        height: 500
        minimumHeight : 300
        minimumWidth : 300

        VariantInformation
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
