import QtQuick 2.9
import Qt.labs.settings 1.0
import QtQuick.Window 2.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Dialogs"
import "qrc:/qml/Windows"

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



//    NewSubjectDialog
//    {
//        id: newSubjectDialog

//        Connections
//        {
//            target: regovar
//            onNewSubjectWizardOpen: { newSubjectDialog.reset(); newSubjectDialog.show(); }
//        }
//    }

//    openNewFileWizardOpen
}
