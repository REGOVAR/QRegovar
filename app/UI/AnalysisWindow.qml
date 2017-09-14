import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import org.regovar 1.0

import "MainMenu"
import "Dialogs"



ApplicationWindow
{
    id: root
    visible: true
    width: 800
    height: 600

    // The id of this window that allow "Regovar model" to retrieve corresponding "Analysis model" among open models/windows
    property int winId: -1

    //! Analysis model dedicated to the window
    property FilteringAnalysis model

    //! Load root's pages of regovar
    property var menuPageMapping

    //! Menu model
    property MenuModel menuModel: MenuModel
    {
        model:  [
            { "icon": "a", "label": qsTr("Analysis"),            "page": "Analysis/Filtering/SummaryPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "^", "label": qsTr("Statistics"),          "page": "Analysis/Filtering/StatisticsPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "3", "label": qsTr("Filtering"), "page": "Analysis/Filtering/FilteringPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "`", "label": qsTr("Selection"), "page": "Analysis/Filtering/SelectionsPage.qml", "sublevel": [], "subindex": -1},
//            { "icon": "d", "label": qsTr("Settings"),            "page": "", "sublevel": [
//                { "icon": "k", "label": qsTr("Informations"),    "page": "Analysis/Filtering/SettingsInformationsPage.qml", "sublevel": [], "subindex": -1},
//                { "icon": "4", "label": qsTr("Samples"),         "page": "Analysis/Filtering/SettingsSamplesPage.qml", "sublevel": [], "subindex": -1},
//                { "icon": "B", "label": qsTr("Annotations DB"),  "page": "Analysis/Filtering/SettingsAnnotationsDBPage.qml", "sublevel": [], "subindex": -1},
//                ], "subindex": 0},
            { "icon": "e", "label": qsTr("Help "),     "page": "Analysis/Filtering/HelpPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "h", "label": qsTr("Close"),     "page": "@close",      "sublevel": [], "subindex": -1}
        ]
    }
    property var previousIndex : [0,-1,-1]

    Settings
    {
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }

    MainMenu
    {
        id: mainMenu
        z: 10
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 300

        model: menuModel

        onSelectedIndexChanged:
        {
            openPage()
        }
    }

    Item
    {
        id: stack
        z:0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: mainMenu.right
        anchors.right: parent.right
    }



    ErrorDialog
    {
        id: errorPopup
        visible: false
    }

    Connections
    {
        target: regovar
        onOnError:
        {
            if (active)
            {
                console.log("server error occured : [" + errCode + "] " + message);
                errorPopup.errorCode = errCode;
                errorPopup.errorMessage = message;
                errorPopup.open();
            }
        }
    }


    //! Convert MainMenu index into one string key for internal map with qml pages
    function pageIdxKey(idx)
    {
        var key = idx[0];
        if (idx[1] >= 0)  key += "-" + idx[1];
        if (idx[2] >= 0)  key += "-" + idx[2];

        return key;
    }


    property var components
    function buildPages(pages, model, baseIndex)
    {
        for (var idx in model)
        {
            if (model[idx].page !== "" && model[idx].page[0] !== "@")
            {
                var comp = Qt.createComponent("Pages/" + model[idx].page);
                if (comp.status == Component.Ready)
                {
                    var elmt = comp.createObject(stack, {"visible": false});
                    var uid = baseIndex+idx
                    pages[uid] = elmt;
                    console.log ("load " + uid + " : Pages/" + model[idx].page)
                }
                else if (comp.status == Component.Error)
                {
                    console.log("Error loading component:", comp.errorString());
                }

            }
            else if ( model[idx].page[0] === "@")
            {
                if (model[idx].page === "@close")
                {
                    pages[baseIndex+idx] = "@close";
                }
            }
            else
            {
                pages[baseIndex+idx] = false;
            }

            if (model[idx]["sublevel"].length > 0)
            {
                buildPages(pages, model[idx]["sublevel"], baseIndex+idx + "-");
            }

        }
    }


    //! Open qml page according to the selected indexes
    function openPage()
    {
        if (root.menuPageMapping !== undefined)
        {
            var newIdx = pageIdxKey(menuModel.selectedIndex);
            var oldIdx = pageIdxKey(previousIndex);
            if (root.menuPageMapping[newIdx] == "@close")
            {
                root.close();
            }
            else if (root.menuPageMapping[oldIdx])
            {
                root.menuPageMapping[oldIdx].visible = false;
                root.menuPageMapping[newIdx].visible = true;
                root.menuPageMapping[newIdx].anchors.fill = stack;
                if (root.menuPageMapping[newIdx].model == null)
                {
                    root.menuPageMapping[newIdx].model = root.model;
                }
                previousIndex = menuModel.selectedIndex;
            }
        }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        model = regovar.getAnalysisFromWindowId(winId);
        title = model.name;

        if (menuModel !== undefined)
        {
            components = {}
            var pages = {};
            buildPages(pages, menuModel.model, "");
            root.menuPageMapping = pages;
            openPage();
        }
    }
}

