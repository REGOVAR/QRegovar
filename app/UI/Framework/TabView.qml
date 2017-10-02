import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2

import "../Regovar"

Item
{
    id: root


    property var tabsModel
    property var tabSharedModel
    property alias currentIndex: tabsPanel.currentIndex


    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Rectangle
        {
            height: 1
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color:  Regovar.theme.boxColor.border
        }

        ListView
        {
            id: tabsPanel
            anchors.fill: header
            anchors.topMargin: 5
            anchors.leftMargin: 0
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
            interactive: false
            model: root.tabsModel
            currentIndex: 0
            onCurrentItemChanged: openPage();



            delegate: Item
            {
                height: 45
                width: headerLabel.width + headerIcon.width + (hasLabel ? 20 : 0)
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                property bool hasIcon: model.icon !== undefined && model.icon !== null && model.icon !== ""
                property bool hasLabel: model.title !== undefined && model.title !== null && model.title !== ""
                property bool isSelected: tabsPanel.currentIndex == index

                Rectangle
                {
                    anchors.fill: parent
                    color: parent.isSelected ? Regovar.theme.backgroundColor.main : Regovar.theme.backgroundColor.alt
                }

                Rectangle
                {
                    visible: parent.isSelected
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 1
                    color: Regovar.theme.boxColor.border
                }
                Rectangle
                {
                    visible: parent.isSelected
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 1
                    color: Regovar.theme.boxColor.border
                }
                Rectangle
                {
                    visible: parent.isSelected
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.left: parent.left
                    height: 1
                    color: Regovar.theme.boxColor.border
                }
                Rectangle
                {
                    visible: !parent.isSelected
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    height: 1
                    color: Regovar.theme.boxColor.border
                }

                Text
                {
                    id: headerIcon
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    width: parent.hasIcon ? 50 : 0

                    text: (parent.hasIcon) ? model.icon : ""
                    color: parent.isSelected ? Regovar.theme.primaryColor.back.dark : Regovar.theme.primaryColor.back.light
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Regovar.theme.font.size.title
                    font.family: Regovar.theme.icons.name
                }

                Text
                {
                    id: headerLabel
                    anchors.left: (parent.hasIcon) ? headerIcon.right : parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    text: (parent.hasLabel) ? model.title : ""
                    color: parent.isSelected ? Regovar.theme.primaryColor.back.dark : Regovar.theme.primaryColor.back.light
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.title
                }

                MouseArea
                {
                    id: headerMouseArea
                    anchors.fill: parent
                    onClicked: tabsPanel.currentIndex = index
                }
            }
        }


    }

    Item
    {
        id: stackPanel
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom

        clip: true

        Rectangle
        {
            // To be sure to hide tabs that are not selected ( selectedTab.z = 100, otherTabs.z = 0)
            anchors.fill: parent
            color: Regovar.theme.backgroundColor.main
            z: 99

            // block click otherwise risk to interact with hidden tabs
            MouseArea
            {
                anchors.fill: parent
            }
        }
    }



    property var menuPageMapping
    property var previousIndex

    onTabsModelChanged:
    {
        if (tabsModel !== undefined)
        {
            var pages = {};
            for (var idx=0; idx<tabsModel.count; idx++)
            {
                var model = tabsModel.get(idx);
                console.log ("> Tab n°" + idx + " : " + model.title + " " + model.source);
                var comp = Qt.createComponent(model.source);
                if (comp.status == Component.Ready)
                {
                    var elmt = comp.createObject(stackPanel, {"z": 0});
                    pages[idx] = elmt;
                    if (elmt.hasOwnProperty("model"))
                    {
                        elmt.model = Qt.binding(function() { return tabSharedModel; });
                    }


                }
                else if (comp.status == Component.Error)
                {
                    console.log("> Error creating tab's QML component : ", comp.errorString());
                }
            }

            menuPageMapping = pages;
            previousIndex = 0
            openPage();
        }
    }

    //! Open qml page according to the selected index
    function openPage()
    {
        if (menuPageMapping !== undefined)
        {
            var newIdx = tabsPanel.currentIndex;

            if (menuPageMapping[previousIndex])
            {
                menuPageMapping[previousIndex].z = 0;
                menuPageMapping[newIdx].z = 100;
                menuPageMapping[newIdx].anchors.fill = stackPanel;
                previousIndex = newIdx;
            }
        }
    }

    // TODO / FIXME : workaround to force a refresh before a validation in Dialog FilerNewCondition.
    function forceUpdateModel()
    {
        menuPageMapping[tabsPanel.currentIndex].updateModel();
    }
}
