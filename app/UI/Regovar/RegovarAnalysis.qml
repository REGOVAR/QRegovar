import QtQuick 2.0
import Qt.labs.settings 1.0

import "../Pages"
import "../MainMenu"

QtObject
{
    id: uiModel
    /*! This QML model is a "view model" for a filtering analysis (open in a new windows)
     *  It manage only data use for  the UI (like the selected entry in the main menu and so on
     *  The "True" model of the application is done in C++, see /Model/Regovar singleton
     *  accessible in the QML by the id "regovar.openAnalyses[windowId]"
     */

    //! The id of this window. Allow us to retrieve the C++ model via regovar.openAnalyses[windowId]
    property int windowId;

    //! The id of the filtering analysis
    property int analysisId

    //! The title of the window
    property string title: "Prosper"

    //! Main menu model
    property MenuModel mainMenu: MenuModel
    {
        model:  [
            { "icon": "a", "label": qsTr("Analysis"),            "page": "Analysis/Filtering/ResumePage.qml", "sublevel": [], "subindex": -1},
            { "icon": "3", "label": qsTr("Filtering"), "page": "Analysis/Filtering/FilteringPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "`", "label": qsTr("Selection"), "page": "Analysis/Filtering/SelectionsPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "d", "label": qsTr("Settings"),            "page": "", "sublevel": [
                { "icon": "k", "label": qsTr("Informations"),    "page": "Analysis/Filtering/SettingsInformationsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "4", "label": qsTr("Samples"),         "page": "Analysis/Filtering/SettingsSamplesPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "B", "label": qsTr("Annotations DB"),  "page": "Analysis/Filtering/SettingsAnnotationsDBPage.qml", "sublevel": [], "subindex": -1},
                ], "subindex": 0},
            { "icon": "e", "label": qsTr("Help "),     "page": "Analysis/Filtering/HelpPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "h", "label": qsTr("Close"),     "page": "@close",      "sublevel": [], "subindex": -1}
        ]
    }
}
