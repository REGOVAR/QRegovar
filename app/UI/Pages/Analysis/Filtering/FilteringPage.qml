import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Regovar.Core 1.0

import "../../../Regovar"
import "../../../Framework"
import "../../../MainMenu"
import "../../../Dialogs"


import "Quickfilter"
import Regovar.Core 1.0

Rectangle
{
    id: root
    property FilteringAnalysis model
    onModelChanged:
    {
        if (model)
        {
            model.loaded.connect(updateViewFromModel);
            updateViewFromModel(model);
        }
    }
    Component.onDestruction:
    {
        model.loaded.disconnect(updateViewFromModel);
    }

    function updateViewFromModel()
    {
        if (!rootSplitView.visible)
        {
            rootSplitView.visible = root.model ? root.model.loaded && root.model.status === "ready" : false;
            lefPanel.tabSharedModel = root.model;
        }
    }


    Row
    {
        anchors.centerIn: parent

        Text
        {
            height: Regovar.theme.font.boxSize.header
            width: Regovar.theme.font.boxSize.header
            font.pixelSize: Regovar.theme.font.size.header
            font.family: Regovar.theme.icons.name
            color: Regovar.theme.primaryColor.back.normal
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: "j"
        }

        Text
        {
            height: Regovar.theme.font.boxSize.header
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.normal
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Your analysis is not ready.")
        }
    }





    SplitView
    {
        id: rootSplitView
        visible: false
        anchors.fill: parent

        TabView
        {
            id: lefPanel
            width: 275

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
