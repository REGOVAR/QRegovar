import QtQuick 2.7
import QtQuick.Controls 2.0

import "MainMenu"
import "Dialogs"

ApplicationWindow
{
    id: root
    visible: true

    // The id of this window that allow "Regovar model" to retrieve corresponding "Analysis model" among open models/windows
    property int winId

    //! Menu model
    property MenuModel menuModel


    property var previousIndex : [0,-1,-1]



    MainMenu
    {
        id: mainMenu
        z: 10
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 300

        model: menuModel

        onSelectedIndexChanged:
        {
            openPage()
        }
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


    //! Retrieve the Qml component corresponding to the provided index
    function pageIdxToQml(idx)
    {
        var model = menuModel.model[idx[0]];
        if (idx[1] >= 0)  model =  model["sublevel"][idx[1]];
        if (idx[2] >= 0)  model =  model["sublevel"][idx[2]];

        return model.qml;
    }


    function buildPages(model, sharedModel)
    {
        for (var idx in model)
        {
            if (model[idx].qml === undefined)
            {
                if (model[idx].page !== "" && model[idx].page[0] !== "@")
                {
                    var comp = Qt.createComponent("Pages/" + model[idx].page);
                    if (comp.status == Component.Ready)
                    {
                        var elmt = comp.createObject(stack, {"visible": false});
                        model[idx].qml = elmt;
                        if (sharedModel)
                        {
                            elmt.model = sharedModel;
                        }

                        console.log ("load Pages/" + model[idx].page)
                    }
                    else if (comp.status == Component.Error)
                    {
                        console.log("Error loading component:", comp.errorString());
                    }
                }
                else
                {
                    model[idx].qml = false;
                }

                if (model[idx]["sublevel"].length > 0)
                {
                    buildPages(model[idx]["sublevel"], sharedModel);
                }
            }
        }
    }


    //! Open qml page according to the selected indexes
    function openPage()
    {
        var oldQmlPage = pageIdxToQml(previousIndex);
        var newQmlPage = pageIdxToQml(menuModel.selectedIndex);

        oldQmlPage.visible = false;
        newQmlPage.visible = true;
        newQmlPage.anchors.fill = stack;
        previousIndex = menuModel.selectedIndex;
    }

    onMenuModelChanged:
    {
        if (menuModel !== undefined)
        {
            var pages = {};
            buildPages(menuModel.model, null);
            openPage();
        }
    }
}
