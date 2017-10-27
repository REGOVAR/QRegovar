import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"
import "NewAnalysisWizardScreens"

Dialog
{
    id: root
    modality: Qt.WindowModal

    title: qsTr("Create new analysis")

    width: 900
    height: 500

    onVisibleChanged:
    {
        startScreen.visible = true;
        regovar.resetNewAnalysisWizardModels();
    }

    property var menuModel
    property int menuSelectedIndex
    property var analysisModel

    Connections
    {
        target: regovar
        onAnalysisCreationDone:
        {
            loadingIndicator.visible = false;
            if (success) root.close();
        }
    }


    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.alt



        // Start screen
        AnalysisTypeScreen
        {
            id: startScreen
            anchors.fill: parent
            z: 1000

            onSelected:
            {
                root.analysisModel = {"inputs": [], "settings": {}, "name": "", "comment": "", "type": ""};
                if (choice == 1)
                {
                    root.menuModel = [
                        { "title" : qsTr("Analysis type")},
                        { "title" : qsTr("Pipeline"), "source":"../Dialogs/NewAnalysisWizardScreens/PipelinesScreen.qml"},
                        { "title" : qsTr("Inputs files"), "source":"../Dialogs/NewAnalysisWizardScreens/PipelineInputsScreen.qml"},
                        { "title" : qsTr("Configure"), "source":"../Dialogs/NewAnalysisWizardScreens/PipelineSettingsScreen.qml"},
                        { "title" : qsTr("Launch"), "source":"../Dialogs/NewAnalysisWizardScreens/PipelineLaunch.qml"}
                    ];
                    root.analysisModel["type"] = "pipeline";
                }
                else if (choice == 2)
                {
                    root.menuModel = [
                        { "title" : qsTr("Analysis type")},
                        { "title" : qsTr("Reference"), "source":"../Dialogs/NewAnalysisWizardScreens/FilteringReferenceScreen.qml"},
                        { "title" : qsTr("Samples"), "source":"../Dialogs/NewAnalysisWizardScreens/FilteringSamplesScreen.qml"},
                        { "title" : qsTr("Samples attributes"), "source":"../Dialogs/NewAnalysisWizardScreens/FilteringAttributesScreen.qml"},
                        { "title" : qsTr("Subjects associations"), "source":"../Dialogs/NewAnalysisWizardScreens/FilteringSubjectsScreen.qml"},
                        { "title" : qsTr("Annotations"), "source":"../Dialogs/NewAnalysisWizardScreens/FilteringAnnotationsScreen.qml"},
                        { "title" : qsTr("Launch"), "source":"../Dialogs/NewAnalysisWizardScreens/FilteringLaunchScreen.qml"}
                    ];
                    root.analysisModel["type"] = "filtering";
                }

                menuSelectedIndex = 1;
                startScreen.visible = false;
            }
        }


        // Wizard root layout
        Rectangle
        {
            id: naviguationPanel
            width: 175
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: Regovar.theme.primaryColor.back.dark


            Text
            {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 5
                text:  qsTr("New analysis") + " :" // (root.menuModel !== undefined) ? qsTr("Step") + " " + (menuSelectedIndex + 1) + "/" + root.menuModel.length : ""
                color: Regovar.theme.primaryColor.front.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: Regovar.theme.font.boxSize.title
            }

            Column
            {
                anchors.fill: parent
                anchors.topMargin: Regovar.theme.font.boxSize.title

                Repeater
                {
                    model: root.menuModel

                    Rectangle
                    {
                        id: menuItem

                        width: naviguationPanel.width
                        height: Regovar.theme.font.boxSize.header
                        color: isSelected ? Regovar.theme.primaryColor.back.light: "transparent"

                        property bool isHover: false
                        property bool isSelected: index == menuSelectedIndex


                        Row
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            spacing: 5

                            Text
                            {
                                height: Regovar.theme.font.boxSize.header
                                width: Regovar.theme.font.boxSize.normal

                                text: (index+1) + "."
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: Regovar.theme.font.size.normal
                                // menuItem.isHover ?  Regovar.theme.secondaryColor.front.normal : menuItem.isSelected ? Regovar.theme.secondaryColor.back.light :
                                color: menuSelectedIndex >= index ? Regovar.theme.primaryColor.front.dark : Regovar.theme.primaryColor.back.light
                            }
                            Text
                            {
                                height: Regovar.theme.font.boxSize.header
                                text: modelData["title"]
                                // menuItem.isHover ?  Regovar.theme.secondaryColor.front.normal : menuItem.isSelected ? Regovar.theme.secondaryColor.back.light :
                                color: menuSelectedIndex >= index ? Regovar.theme.primaryColor.front.dark : Regovar.theme.primaryColor.back.light
                                font.pixelSize: Regovar.theme.font.size.normal
                                font.family: Regovar.theme.font.familly
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.isHover = true
                            onExited: parent.isHover = false
                        }
                    }
                }
            }
        }

        Rectangle
        {
            id: controls
            anchors.bottom: parent.bottom
            anchors.left: naviguationPanel.right
            anchors.right: parent.right
            anchors.margins: 10
            height: Regovar.theme.font.boxSize.normal
            color: "transparent"

            Button
            {
                id: previousButton
                visible: false
                text: qsTr("< Previous")
                onClicked:
                {
                    if (menuSelectedIndex > 1)
                    {
                        openPage(menuSelectedIndex - 1);
                    }
                    else
                    {
                        reset();
                        startScreen.visible = true;
                    }
                }
            }
            Row
            {
                anchors.right: parent.right
                spacing: 10

                Button
                {
                    id: cancelButton
                    text: qsTr("Cancel")
                    onClicked: close()
                }
                Button
                {
                    id: nextButton
                    visible: false
                    text: qsTr("Next >")
                    onClicked: openPage(menuSelectedIndex + 1)
                }
                Button
                {
                    id: launchButton
                    visible: false
                    text: qsTr("Launch !")
                    onClicked: launchAnalaysis()
                }
            }
        }

        Item
        {
            id: stackPanel
            anchors.top: parent.top
            anchors.bottom: controls.top
            anchors.left: naviguationPanel.right
            anchors.right: parent.right
            anchors.margins: 10

            Rectangle
            {
                // FIXME : To be sure to hide tabs that are not selected ( selectedTab.z = 100, otherTabs.z = 0) BUT Zorder not working :(... need to fin another solution)
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


        // Loading indicator
        Rectangle
        {
            id: loadingIndicator
            z: 1500
            anchors.fill : parent
            color: Regovar.theme.backgroundColor.alt
            visible: false

            BusyIndicator
            {
                anchors.centerIn: parent
            }
        }
    }


    property var menuPageMapping: ({"length": 0})
    onMenuModelChanged:
    {
        if (menuModel !== undefined)
        {
             reset();

            // Load new pages
            var pages = {};
            for (var idx=1; idx<menuModel.length; idx++)
            {
                var model = menuModel[idx];
                console.log ("> Page n°" + idx + " : " + model.title + " " + model.source);
                var comp = Qt.createComponent(model.source);
                if (comp.status == Component.Ready)
                {
                    var elmt = comp.createObject(stackPanel, {"z": 0});
                    pages[idx] = elmt;
                    elmt.anchors.fill = stackPanel;
                    if (elmt.hasOwnProperty("model"))
                    {
                        elmt.model = model;
                    }
                }
                else if (comp.status == Component.Error)
                {
                    console.log("> Error creating page QML component : ", comp.errorString());
                }
            }

            menuPageMapping = pages;
            menuSelectedIndex = 1;
            menuPageMapping[1].z = 100;
            // menuPageMapping[1].anchors.fill = stackPanel;

            previousButton.visible = Qt.binding(function() { return menuSelectedIndex > 0;});
            nextButton.visible = Qt.binding(function() { return menuSelectedIndex < menuModel.length -1; });
            launchButton.visible = Qt.binding(function() { return menuSelectedIndex == menuModel.length -1; });
        }
    }

    function reset()
    {
        // Clear old pages
        for(var i = stackPanel.children.length; i > 0 ; i--)
        {
            stackPanel.children[i-1].destroy()
        }
    }

    //! Open qml page according to the selected index
    function openPage(newIdx)
    {
        if (menuPageMapping !== undefined && newIdx>0 && newIdx != menuSelectedIndex)
        {
            if (menuPageMapping[menuSelectedIndex])
            {
                menuPageMapping[menuSelectedIndex].z = 0;
                menuPageMapping[newIdx].z = 100;
                menuPageMapping[newIdx].anchors.fill = stackPanel;
                nextButton.enabled = Qt.binding(function()
                {
                    var ready = false;
                    if ( menuPageMapping[newIdx])
                    {
                        ready = menuPageMapping[newIdx].readyForNext;
                        //menuModel[newIdx]["checked"] = ready;
                    }
                    return ready;
                });
                menuSelectedIndex = newIdx;
            }
        }
    }


    function launchAnalaysis()
    {
        if (regovar.newAnalysis(root.analysisModel["type"]))
        {

        }
        else
        {
            // Unable to create analysis.
        }
    }

}
