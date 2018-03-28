import QtQuick 2.9
import QtQuick.Controls 2.0
import Regovar.Core 1.0

import "qrc:/qml/MainMenu"
import "qrc:/qml/Dialogs"

ApplicationWindow
{
    id: root
    visible: true
    minimumWidth: 900
    minimumHeight: 300

    // The id of this window that allow "Regovar model" to retrieve corresponding "Analysis model" among open models/windows
    property int winId
    // Internal map to store qml page associated with their menuModel Uid
    property var pages
    // The uid of the page currently displayed
    property int currentUid: -1


    property alias menuModel: mainMenu.model    
    onMenuModelChanged:
    {
        if (menuModel)
        {
            root.pages = {};
            buildPages(menuModel, null);
            openPage(menuModel.selectedEntry);
        }
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

        Keys.onPressed:
        {
            if (event.key == Qt.Key_F5) regovar.loadWelcomData();
        }
    }

    LoginPage
    {
        id: loginPage
        anchors.fill: parent
        visible: false
    }


    CloseDialog
    {
        id: closePopup
        visible: false
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

    Connections
    {
        target: regovar.usersManager
        onDisplayLoginScreen:
        {
            loginPage.visible = state;
            mainMenu.enabled = !state;
            stack.enabled = !state;
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
                if (menuEntry.qmlPage !== "")
                {
                    var comp = Qt.createComponent("Pages/" + menuEntry.qmlPage);
                    if (comp.status == Component.Ready)
                    {
                        var elmt = comp.createObject(stack, {"visible": false});
                        root.pages[uid] = elmt;
                        if (elmt.hasOwnProperty("model"))
                        {
                            if (sharedModel)
                            {
                                elmt.model = sharedModel;
                            }
                            else if (menuEntry.project)
                            {
                                elmt.model = menuEntry.project;
                            }
                            else if (menuEntry.subject)
                            {
                                elmt.model = menuEntry.subject;
                            }
                        }

                        console.log ("load " + uid + ": Pages/" + menuEntry.qmlPage)
                    }
                    else if (comp.status == Component.Error)
                    {
                        console.log("Error loading component: ", comp.errorString());
                    }
                }
                else
                {
                    root.pages[uid] = false;
                }
            }

            if (menuEntry.entries.length > 0)
            {
                buildPages(menuEntry, sharedModel);
            }
        }
    }


    //! Open qml page according to the provided
    function openPage(menuEntry)
    {
        // Check if new pages need to be build
        buildPages(mainMenu.model, null);
        // hide former page
        if (currentUid in pages)
        {
            pages[currentUid].visible = false;
        }
        // Display new page
        if (menuEntry && menuEntry.uid)
        {
            currentUid = menuEntry.uid;
            pages[currentUid].visible = true;
            pages[currentUid].anchors.fill = stack;
        }
    }
}
