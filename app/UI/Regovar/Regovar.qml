pragma Singleton
import QtQuick 2.7
import Qt.labs.settings 1.0
import org.regovar 1.0


import "../MainMenu"
import "../Pages"

QtObject 
{
    id: uiModel
    /*! This QML model is the global "view model" of the application
     *  It manage only data use for  the UI (like the selected entry in the main menu and so on
     *  The "True" model of the application is done in C++, see /Model/Regovar singleton
     *  accessible in the QML by the id "regovar"
     */


    //! Collection of sub windows
    property var openAnalysisWindows;

    //! The theme applied to the UI
    property Style theme: Style {}

    //! Indicates if need to display help information's box in the UI
    property bool helpInfoBoxDisplayed: true
    
    //! Main menu model
    property MenuModel menuModel: MenuModel
    {
        model:  [
            { "icon": "a", "label": qsTr("Welcome"),      "page": "WelcomPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "z", "label": qsTr("Search"),       "page": "Browse/SearchPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "c", "label": qsTr("Projects"),      "page": "", "sublevel": [
                { "icon": "c", "label": qsTr("Browser"),   "page": "Browse/ProjectsPage.qml", "sublevel": [], "subindex": -1, "projectId": -1}
                ], "subindex": 0},
            { "icon": "b", "label": qsTr("Subjects"),    "page": "", "sublevel": [
                { "icon": "z", "label": qsTr("Browser"), "page": "Browse/SubjectsPage.qml", "sublevel": [], "subindex": -1, "subjectId": -1},
                { "icon": "b", "label": "Michel Dupont","page": "", "sublevel": [
                    { "label": qsTr("Summary"),    "page": "Subject/SummaryPage.qml", "sublevel": []},
                    { "label": qsTr("Phenotype"),  "page": "Subject/PhenotypesPage.qml", "sublevel": []},
                    { "label": qsTr("Samples"),    "page": "Subject/SamplesPage.qml", "sublevel": []},
                    { "label": qsTr("Analyses"),   "page": "Subject/AnalysesPage.qml", "sublevel": []},
                    { "label": qsTr("Files"),      "page": "Subject/FilesPage.qml", "sublevel": []},
                ], "subindex": 0},
            ], "subindex": 0},
            { "icon": "d", "label": qsTr("Settings"),      "page": "",   "sublevel": [
                { "icon": "b", "label": qsTr("My profile"),    "page": "Settings/ProfilePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "I", "label": qsTr("Application"),   "page": "Settings/ApplicationPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "q", "label": qsTr("Panels"),     "page": "Settings/PanelsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "d", "label": qsTr("Administration"), "page": "", "sublevel": [
                    { "icon": "^", "label": qsTr("Statistics"), "page": "Settings/AdminStatisticsPage.qml", "sublevel": [], "subindex": -1},
                    { "icon": "@", "label": qsTr("Users"),      "page": "Settings/AdminUsersPage.qml", "sublevel": [], "subindex": -1},
                    { "icon": "L", "label": qsTr("Pipelines"),   "page": "Settings/AdminPipesPage.qml", "sublevel": [], "subindex": -1},
                    { "icon": "B", "label": qsTr("Databases"),  "page": "Settings/AdminServerPage.qml", "sublevel": [], "subindex": -1},
                    ], "subindex": 0},
                ], "subindex": 0},
            { "icon": "e", "label": qsTr("Help"),           "page": "", "sublevel": [
                { "icon": "e", "label": qsTr("User guide"), "page": "Help/UserGuidePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "f", "label": qsTr("About"),      "page": "Help/AboutPage.qml", "sublevel": [], "subindex": -1}
                ], "subindex": 0},
            { "icon": "h", "label": qsTr("Close"),        "page": "@close",      "sublevel": [], "subindex": -1}
        ]
    }

    // This variable is used temporary during the creation of the project menu to share the model between the menu component and the qml pages
    property QtObject currentopeningProject

    function reloadProjectsOpenEntries()
    {
        // TODO : remove project that are no more open

        // Add new open project
        for (var i=0; i<regovar.projectsOpen.length; i++)
        {
            var itemFound = false;
            for (var j=0; j<menuModel.model[2]["sublevel"].length; j++)
            {

                if ( regovar.projectsOpen[i].id == menuModel.model[2]["sublevel"][j].projectId )
                {
                    itemFound = menuModel.model[2]["sublevel"][j];
                }
            }

            if (itemFound === false)
            {
                // Add project to the menu
                currentopeningProject = regovar.projectsOpen[i];
                menuModel.model[2]["sublevel"] = menuModel.model[2]["sublevel"].concat({ "icon": "6", "label": currentopeningProject.name, "projectId": currentopeningProject.id, "page": "", "sublevel": [
                  { "label": qsTr("Summary"),       "page": "Project/SummaryPage.qml", "sublevel": []},
                  { "label": qsTr("Analyses"),      "page": "Project/AnalysesPage.qml", "sublevel": []},
                  { "label": qsTr("Subjects"),      "page": "Project/SubjectsPage.qml", "sublevel": []},
                  { "label": qsTr("Files"),         "page": "Project/FilesPage.qml", "sublevel": []},
                   ], "subindex": 0});
            }
        }
    }

    // TOOLS
    function formatBigNumber(value)
    {
        var n = value.toString();
        var p = n.indexOf('.');
        n = n.replace(/\d(?=(?:\d{3})+(?:\.|$))/g, function($0, i)
        {
            return p<0 || i<p ? ($0+' ') : $0;
        });
        return n;
    }


    property var seqColorMapCss : ({
        'A':'<span style="color:'+ theme.filtering.seqA +'">A</span>',
        'C':'<span style="color:'+ theme.filtering.seqC +'">C</span>',
        'G':'<span style="color:'+ theme.filtering.seqG +'">G</span>',
        'T':'<span style="color:'+ theme.filtering.seqT +'">T</span>'})

    function formatSequence(seq)
    {
        var html = "";
        for (var i=0; i<seq.length; i++)
        {
            html += seqColorMapCss[seq[i]];
        }
        return html;
    }
} 
