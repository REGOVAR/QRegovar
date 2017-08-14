import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "../../../MainMenu"

import "Quickfilter"
import org.regovar 1.0

Rectangle
{
    id: root
    property FilteringAnalysis model
    onModelChanged:
    {
        console.log("===> FilteringPage model set up");
    }

//    onModelChanged:
//    {
//        lefPanel.tabSharedModel = root.model
//        rightPanel.model = root.model
////        resultsTree.rowHeight = (root.model.samples.length === 1) ? 25 : root.model.samples.length * 18
////        samplesNamesColumn.visible = root.model.sampleColumnDisplayed
//    }

    SplitView
    {
        anchors.fill: parent

        TabView
        {
            id: lefPanel
            tabSharedModel: root.model
            onTabSharedModelChanged:
            {
                console.log("===> FilteringPage setting up the shared model of the tabView with its model");
            }

            tabsModel: ListModel
            {
                ListElement
                {
                    title: qsTr("Quick filters")
                    icon: "F"
                    source: "../Pages/Analysis/Filtering/QuickFilterPanel.qml"
                }
                ListElement
                {
                    title: qsTr("Advanced filters")
                    icon: "3"
                    source: "../Pages/Analysis/Filtering/AdvancedFilterPanel.qml"
                }
                ListElement
                {
                    title: qsTr("Annotations")
                    icon: "o"
                    source: "../Pages/Analysis/Filtering/AnnotationsSelectorPanel.qml"
                }
            }
        }

        ResultsPanel
        {
            id: rightPanel
            model: root.model
        }
    }
}
