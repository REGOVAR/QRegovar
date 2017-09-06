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

    width: 600
    height: 400

    onVisibleChanged: startScreen.visible = true

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
        StartScreen
        {
            id: startScreen
            anchors.fill: parent
            z: 1000

            onSelected:
            {
                root.analysisModel = {"inputs": [], "settings": {}, "name": "", "comment": "", "type": ""}
                if (choice == 1)
                {
                    root.menuModel = [
                        { "title" : qsTr("Start"), "checked": true, "selected": false},
                        { "title" : qsTr("Select files"), "checked": false, "selected": true, "source":"../Dialogs/NewAnalysisWizardScreens/InputsScreen.qml"},
                        { "title" : qsTr("Select pipeline"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/PipelinesScreen.qml"},
                        { "title" : qsTr("Configure"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/PipelineSettingsScreen.qml"},
                        { "title" : qsTr("Launch"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/LaunchScreen.qml"}
                    ];
                    root.analysisModel["type"] = "pipeline";
                }
                else if (choice == 2)
                {
                    root.menuModel = [
                        { "title" : qsTr("Start"), "checked": true, "selected": false},
                        { "title" : qsTr("Select pipeline"), "checked": false, "selected": true, "source":"../Dialogs/NewAnalysisWizardScreens/PipelinesScreen.qml"},
                        { "title" : qsTr("Select files"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/InputsScreen.qml"},
                        { "title" : qsTr("Configure"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/PipelineSettingsScreen.qml"},
                        { "title" : qsTr("Launch"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/LaunchScreen.qml"}
                    ];
                    root.analysisModel["type"] = "pipeline";
                }
                else if (choice == 3)
                {
                    root.menuModel = [
                        { "title" : qsTr("Start"), "checked": true, "selected": false},
                        { "title" : qsTr("Settings"), "checked": false, "selected": true, "source":"../Dialogs/NewAnalysisWizardScreens/FilteringSettingsScreen.qml"},
                        { "title" : qsTr("Select samples"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/FilteringSamplesScreen.qml"},
                        { "title" : qsTr("Select annotations"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/FilteringAnnotationScreen.qml"},
                        { "title" : qsTr("Launch"), "checked": false, "selected": false, "source":"../Dialogs/NewAnalysisWizardScreens/LaunchScreen.qml"}
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
                text: qsTr("Step") + " " + (menuSelectedIndex + 1) + "/" + root.menuModel.length
                color: Regovar.theme.primaryColor.front.dark
                font.pixelSize: Regovar.theme.font.size.control
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
                        color: isHover ? Regovar.theme.secondaryColor.back.normal: "transparent"

                        property bool isHover: false
                        property bool isSelected: modelData["selected"]
                        property bool isChecked: modelData["checked"]


                        Row
                        {
                            anchors.fill: parent
                            spacing: 5

                            Text
                            {
                                height: Regovar.theme.font.boxSize.control
                                width: Regovar.theme.font.boxSize.header

                                text: menuItem.isChecked ? "p" : "r"
                                font.family: Regovar.theme.icons.name
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: Regovar.theme.font.size.control

                                color: menuItem.isHover ?  Regovar.theme.secondaryColor.front.normal : menuItem.isSelected ? Regovar.theme.secondaryColor.back.light : Regovar.theme.primaryColor.front.dark
                            }
                            Text
                            {
                                height: Regovar.theme.font.boxSize.control
                                text: modelData["title"]
                                color: menuItem.isHover ?  Regovar.theme.secondaryColor.front.normal : menuItem.isSelected ? Regovar.theme.secondaryColor.back.light : menuItem.isChecked ? Regovar.theme.primaryColor.front.dark : Regovar.theme.primaryColor.back.light
                                font.pixelSize: Regovar.theme.font.size.control
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
        Container
        {
            id: currentPageContainer
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: naviguationPanel.right
            anchors.right: parent.right

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
}
