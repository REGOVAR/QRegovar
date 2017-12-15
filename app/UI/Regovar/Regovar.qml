pragma Singleton
import QtQuick 2.9
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
            { "icon": "a", "label": qsTr("Welcome"),     "page": "WelcomPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "z", "label": qsTr("Search"),      "page": "Browse/SearchPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "c", "label": qsTr("Projects"),    "page": "", "sublevel": [
                { "icon": "c", "label": qsTr("Browser"), "page": "Browse/ProjectsPage.qml", "sublevel": [], "subindex": -1, "projectId": -1}
                ], "subindex": 0},
            { "icon": "b", "label": qsTr("Subjects"),    "page": "", "sublevel": [
                { "icon": "z", "label": qsTr("Browser"), "page": "Browse/SubjectsPage.qml", "sublevel": [], "subindex": -1, "subjectId": -1},
                ], "subindex": 0},
            { "icon": "d", "label": qsTr("Settings"), "page": "", "sublevel": [
                { "icon": "b", "label": qsTr("My profile"), "page": "Settings/ProfilePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "I", "label": qsTr("Application"), "page": "", "sublevel": [
                            { "icon": "", "label": qsTr("Regovar"), "page": "Settings/ApplicationRegovarPage.qml", "sublevel": [], "subindex": -1},
                            { "icon": "", "label": qsTr("Interface"), "page": "Settings/ApplicationInterfacePage.qml", "sublevel": [], "subindex": -1},
                            { "icon": "", "label": qsTr("Connection"), "page": "Settings/ApplicationConnectionPage.qml", "sublevel": [], "subindex": -1},
                            { "icon": "", "label": qsTr("Cache"), "page": "Settings/ApplicationCachePage.qml", "sublevel": [], "subindex": -1},
                            ], "subindex": 0},
                { "icon": "q", "label": qsTr("Panels"),      "page": "Settings/PanelsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "^", "label": qsTr("Statistics"),  "page": "Settings/StatisticsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "d", "label": qsTr("Administration"), "page": "", "sublevel": [
                    { "icon": "", "label": qsTr("Server"),    "page": "Settings/AdminServerPage.qml", "sublevel": [], "subindex": -1},
                    { "icon": "", "label": qsTr("Users"),     "page": "Settings/AdminUsersPage.qml", "sublevel": [], "subindex": -1},
                    { "icon": "", "label": qsTr("Pipelines"), "page": "Settings/AdminPipesPage.qml", "sublevel": [], "subindex": -1},
                    { "icon": "", "label": qsTr("Annotations"), "page": "Settings/AdminAnnotationsPage.qml", "sublevel": [], "subindex": -1},
                    ], "subindex": 0},
                ], "subindex": 0},
            { "icon": "e", "label": qsTr("Help"),           "page": "", "sublevel": [
                { "icon": "e", "label": qsTr("User guide"), "page": "Help/UserGuidePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "f", "label": qsTr("About"),      "page": "Help/AboutPage.qml", "sublevel": [], "subindex": -1}
                ], "subindex": 0}
           // { "icon": "h", "label": qsTr("Close"),        "page": "@close",      "sublevel": [], "subindex": -1}
        ]
    }

    // This variable is used temporary during the creation of the project/subject menu to share the model between the menu component and the qml pages
    property QtObject currentopeningProject
    property QtObject currentopeningSubject

    function reloadProjectsOpenEntries()
    {
        // TODO : remove project that are no more open
//        for (var i=0; i<regovar.projectsOpen.length; i++)
//        {

//            menuModel.model[2]["sublevel"] = [];
//        }

        // Add new open project
        for (var i=0; i<regovar.projectsManager.projectsOpenList.length; i++)
        {
            var itemFound = false;
            for (var j=0; j<menuModel.model[2]["sublevel"].length; j++)
            {

                if (regovar.projectsManager.projectsOpenList[i].id == menuModel.model[2]["sublevel"][j].projectId )
                {
                    itemFound = menuModel.model[2]["sublevel"][j];
                }
            }

            if (itemFound === false)
            {
                // Add project to the menu
                currentopeningProject = regovar.projectsManager.projectsOpenList[i];
                menuModel.model[2]["sublevel"] = menuModel.model[2]["sublevel"].concat({
                  "icon": "6",
                  "label": currentopeningProject.name,
                  "projectId": currentopeningProject.id,
                  "page": "", "sublevel": [
                      { "label": qsTr("Summary"),  "page": "Project/SummaryPage.qml", "sublevel": []},
                      { "label": qsTr("Analyses"), "page": "Project/AnalysesPage.qml", "sublevel": []},
                      { "label": qsTr("Subjects"), "page": "Project/SubjectsPage.qml", "sublevel": []},
                  //{ "label": qsTr("Files"),    "page": "Project/FilesPage.qml", "sublevel": []},
                   ], "subindex": 0});
            }
        }
    }








    function refreshSubjectsEntries()
    {
        // /!\ Change must be done "one by one".
        //     Multi add/remove not supported
        var addMode = regovar.subjectsManager.subjectsOpenList.length > menuModel.model[3]["sublevel"].length-1; // -1 = don't tak ein account the "browser entry"

        if (addMode)
        {
            var modelItem = regovar.subjectsManager.subjectOpen;
            var menuEntry = { "icon": "b", "label": modelItem.firstname + " " + modelItem.lastname, "subjectId": modelItem.id, "page": "", "sublevel": [
                { "label": qsTr("Summary"),    "page": "Subject/SummaryPage.qml", "sublevel": []},
                { "label": qsTr("Phenotype"),  "page": "Subject/PhenotypesPage.qml", "sublevel": []},
                { "label": qsTr("Samples"),    "page": "Subject/SamplesPage.qml", "sublevel": []},
                { "label": qsTr("Analyses"),   "page": "Subject/AnalysesPage.qml", "sublevel": []},
                { "label": qsTr("Files"),      "page": "Subject/FilesPage.qml", "sublevel": []},
            ], "subindex": 0};

            if (menuModel.model[3]["sublevel"].length == 1)
            {
                menuModel.model[3]["sublevel"].splice(1, 0, menuEntry);
                return modelItem;
            }
            else
            {
                for(var idx=0; idx<regovar.subjectsManager.subjectsOpenList.length; idx++)
                {
                    if (modelItem.id != menuModel.model[3]["sublevel"][idx+1].subjectId)
                    {
                        // insert new entry here
                        menuModel.model[3]["sublevel"].splice(idx+1, 0, menuEntry);
                        return modelItem;
                    }
                }
            }
        }
        else
        {
            if (regovar.subjectsManager.subjectsOpenList.length == 0)
            {
                menuModel.model[3]["sublevel"].splice(1, 0, menuEntry);
                return null;
            }
            else
            {
                for(var idx=0; idx<regovar.subjectsManager.subjectsOpenList.length; idx++)
                {
                    if (modelItem.id != menuModel.model[3]["sublevel"][idx+1].subjectId)
                    {
                        // remove entry here
                        menuModel.model[3]["sublevel"].splice(idx, 1);
                        return null;
                    }
                }
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

    function round(number, length)
    {
        if (number)
        {
            var coeff = Math.pow(10,length);
            var rounded = Math.round(number * coeff) / coeff;
            rounded = rounded.toString()
            while (rounded.endsWith("0"))
            {
                rounded = rounded.substr(0,rounded.length-1);
            }
            if (rounded.endsWith("."))
            {
                rounded = rounded.substr(0,rounded.length-1);
            }
            return rounded;
        }
        return 0;
    }

    function formatDate(iso)
    {
        var date = new Date(iso);
        var day = date.getDate();
        day = (day > 9 ? "" : "0") + day;
        var month = date.getMonth() + 1;
        month = (month > 9 ? "" : "0") + month;
        var year = date.getFullYear();
        var hours = date.getHours();
        hours = (hours > 9 ? "" : "0") + hours;
        var minutes = date.getMinutes();
        minutes = (minutes > 9 ? "" : "0") + minutes;

        return year + "-" +  month + "-" + day + " " + hours + ":" + minutes;
    }

    function formatShortDate(iso)
    {
        var date = new Date(iso);
        var day = date.getDate();
        day = (day > 9 ? "" : "0") + day;
        var month = date.getMonth() + 1;
        month = (month > 9 ? "" : "0") + month;
        var year = date.getFullYear();

        return year + "-" +  month + "-" + day;
    }

    function dateFromShortString(dateString)
    {
        var dateElmt = dateString.split("-");
        return new Date(dateElmt[0], dateElmt[1] - 1,  dateElmt[2]);
    }

} 
