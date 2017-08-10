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

    //! Load root's pages of regovar
    property var menuPageMapping

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


    //! Convert MainMenu index into one string key for internal map with qml pages
    function pageIdxKey(idx)
    {
        var key = idx[0];
        if (idx[1] >= 0)  key += "-" + idx[1];
        if (idx[2] >= 0)  key += "-" + idx[2];

        return key;
    }

    function buildPages(pages, model, baseIndex)
    {
        for (var idx in model)
        {
            if (model[idx].page !== "" && model[idx].page[0] !== "@")
            {
                var comp = Qt.createComponent("Pages/" + model[idx].page);
                var elmt = comp.createObject(stack, {"visible": false});
                var uid = baseIndex+idx
                pages[uid] = elmt;
                console.log ("load " + uid + " : Pages/" + model[idx].page)
            }
            else
            {
                pages[baseIndex+idx] = false;
            }

            if (model[idx]["sublevel"].length > 0)
            {
                buildPages(pages, model[idx]["sublevel"], baseIndex+idx + "-");
            }

        }
    }


    //! Open qml page according to the selected indexes
    function openPage()
    {
        if (root.menuPageMapping !== undefined)
        {
            var newIdx = pageIdxKey(menuModel.selectedIndex);
            var oldIdx = pageIdxKey(previousIndex);
            console.log ("close " + oldIdx + " open " + newIdx);
            root.menuPageMapping[oldIdx].visible = false;
            root.menuPageMapping[newIdx].visible = true;
            root.menuPageMapping[newIdx].anchors.fill = stack;
            root.menuPageMapping[newIdx].model = model

            previousIndex = menuModel.selectedIndex;
        }
    }

    onMenuModelChanged:
    {
        if (menuModel !== undefined)
        {
            var pages = {};
            buildPages(pages, menuModel.model, "");
            root.menuPageMapping = pages;
            openPage();
        }
    }
}
