import QtQuick 2.7
import QtQuick.Controls 2.0

import "MainMenu"
import "Dialogs"

ApplicationWindow
{
    id: root
    visible: true


    //! Load root's pages of regovar
    property var menuPageMapping

    //! Main model
    property MenuModel menuModel


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

    Loader
    {
        id: stack
        z:0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: mainMenu.right
        anchors.right: parent.right

        onSourceComponentChanged:
        {
            anim.start()
        }

        NumberAnimation
        {
            id: anim
            target: stack
            property: "opacity"
            easing.type: Easing.OutQuad
            from: 0
            to: 1
            duration: 250
        }
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
                var uid = baseIndex+idx
                pages[uid] = comp;
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
            var idx = menuModel.selectedIndex;
            var mIdx = pageIdxKey(idx);
            console.log ("open " + mIdx);
            stack.sourceComponent = root.menuPageMapping[mIdx];
        }
    }









//    Component.onCompleted:
//    {
//        if (menuModel !== undefined)
//        {
//            buildPages(menuModel.model, "");
//            stack.sourceComponent = root.menuPageMapping[pageIdxKey(menuModel.mainMenu.selectedIndex)];
//        }
//    }

    onMenuModelChanged:
    {
        if (menuModel !== undefined)
        {
            var pages = {};
            buildPages(pages, menuModel.model, "");
            root.menuPageMapping = pages;
            stack.sourceComponent = root.menuPageMapping[pageIdxKey(menuModel.selectedIndex)];
        }
    }
}
