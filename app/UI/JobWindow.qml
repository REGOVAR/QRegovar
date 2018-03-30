import QtQuick 2.9
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import Regovar.Core 1.0

import "qrc:/qml/MainMenu"
import "qrc:/qml/Dialogs"



ApplicationWindow
{
    id: root
    visible: true
    width: 800
    height: 600

    title: "Analysis"

    // The id of this window that allow "Regovar model" to retrieve corresponding "Analysis model" among open models/windows
    property int winId
    // Internal map to store qml page associated with their menuModel Uid
    property var pages
    // The uid of the page currently displayed
    property int currentUid: -1


    property alias menuModel: mainMenu.model

    //! Analysis model dedicated to the window
    property PipelineAnalysis model

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

        onOpenPage: root.openPage(menuEntry);
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
        onErrorOccured:
        {
            if (active)
            {
                console.log("server error occured : [" + errCode + "] " + message + "\n" + techData);
                errorPopup.errorCode = errCode;
                errorPopup.errorMessage = message;
                errorPopup.errorTechnicalData = techData;
                errorPopup.open();
            }
        }
    }



    function buildPages(model, sharedModel)
    {
        for (var idx=0; idx<model.entries.length; idx++)
        {
            var menuEntry = model.entries[idx];
            var uid = menuEntry.uid;
            if (!(uid in root.pages))
            {
                if (menuEntry.qmlPage !== "" && menuEntry.qmlPage[0] !== "@")
                {
                    var comp = Qt.createComponent("Pages/" + menuEntry.qmlPage);
                    if (comp.status == Component.Ready)
                    {
                        var elmt = comp.createObject(stack, {"visible": false});
                        root.pages[uid] = elmt;
                        if (sharedModel && elmt.hasOwnProperty("model"))
                        {
                            elmt.model = sharedModel;
                        }

                        console.log ("load " + uid + ": Pages/" + menuEntry.qmlPage)
                    }
                    else if (comp.status == Component.Error)
                    {
                        console.log("Error loading component: ", comp.errorString());
                    }
                }
                else if (menuEntry.qmlPage === "@close")
                {
                    root.pages[uid] = "@close";
                }
                else
                {
                    root.pages[uid] = false;
                }

                if (menuEntry.entries.length > 0)
                {
                    buildPages(menuEntry, sharedModel);
                }
            }
        }
    }


    //! Open qml page according to the provided
    function openPage(menuEntry)
    {
        if (currentUid in pages)
        {
            pages[currentUid].visible = false;
        }
        if (menuEntry && menuEntry.uid)
        {
            currentUid = menuEntry.uid;
            if (pages[currentUid] == "@close")
            {
                root.close();
            }

            pages[currentUid].visible = true;
            pages[currentUid].anchors.fill = stack;
        }
    }

    onClosing:
    {
        for (var idx in pages)
        {
            if (pages[idx][0] != "@")
                pages[idx].destroy();
        }
    }




    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        model = regovar.openWindowModels[winId];
        menuModel = model.menuModel;
        title = model.name;

        if (menuModel)
        {
            root.pages = {};
            buildPages(root.menuModel, model);
            openPage(root.menuModel.selectedEntry);
        }
    }
}

