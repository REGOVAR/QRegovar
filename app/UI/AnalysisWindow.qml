import QtQuick 2.7
import QtQuick.Window 2.3
import org.regovar 1.0

import "MainMenu"
import "Regovar"

GenericWindow
{
    id: root
    width: 800
    height: 600

    property FilteringAnalysis model

    menuModel: MenuModel
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

    Component.onCompleted:
    {
        model = regovar.getAnalysisFromWindowId(winId);
    }
}
