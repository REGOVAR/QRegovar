import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "../../../MainMenu"
import "../../../Dialogs"


import "Quickfilter"
import org.regovar 1.0

Rectangle
{
    id: root
    property FilteringAnalysis model

    SplitView
    {
        anchors.fill: parent

        TabView
        {
            id: lefPanel
            width: 275
            tabSharedModel: root.model

            tabsModel: ListModel
            {
                ListElement
                {
                    //title: qsTr("Quick filters")
                    icon: "2"
                    source: "../Pages/Analysis/Filtering/QuickFilterPanel.qml"
                }
                ListElement
                {
                    //title: qsTr("Advanced filters")
                    icon: "3"
                    source: "../Pages/Analysis/Filtering/AdvancedFilterPanel.qml"
                }
                ListElement
                {
                    //title: qsTr("Quick filters")
                    icon: "D"
                    source: "../Pages/Analysis/Filtering/FavoritesPanel.qml"
                }
                ListElement
                {
                    icon: "`"
                    source: "../Pages/Analysis/Filtering/SelectionPanel.qml"
                }
                ListElement
                {
                    //title: qsTr("Annotations")
                    icon: "o"
                    source: "../Pages/Analysis/Filtering/AnnotationsSelectorPanel.qml"
                }
            }
        }

        ResultsPanel
        {
            id: rightPanel
            model: root.model
            Layout.fillWidth: true
        }
    }
}
