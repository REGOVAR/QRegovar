import QtQuick 2.7

import "../../Framework"
import "../../Regovar"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model



    TabView
    {
        id: swipeview
        anchors.fill : root
        tabSharedModel: root.model



        tabsModel: ListModel
        {
//            ListElement
//            {
//                title: "Informations"
//                source: "../Pages/Project/SettingsInformationsPage.qml"
//            }
            ListElement
            {
                title: "Indicators"
                source: "../Pages/Project/SettingsIndicatorsPage.qml"
            }
            ListElement
            {
                title: "Sharing"
                source: "../Pages/Project/SettingsSharingPage.qml"
            }
        }
    }
}
