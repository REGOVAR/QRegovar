import QtQuick 2.7


import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema
import "../Regovar.js" as JS

import "../Framework"

Item
{
    id: mainMenu

    property string selectedEntry: ""


    ListModel
    {
        id: menuModel
        Component.onCompleted: { menuModel.append(JS.menuModel)}
    }

    ListModel
    {
        id: subMenuModel
    }

    Rectangle
    {
        id: back
        color: ColorTheme.primaryDarkBackColor
        anchors.fill: mainMenu
    }


    Column
    {
        Repeater
        {
            model: menuModel

            MenuEntryL1
            {
                id: menuItem
                icon: menuModel.get(index).icon
                label: menuModel.get(index).label

                // Bidirectional binding between selectedEntry properties of the MainMenu and its items
                Binding {
                    target: menuItem
                    property: "selectedEntry"
                    value: mainMenu.selectedEntry
                }
                Binding {
                    target: mainMenu
                    property: "selectedEntry"
                    value: menuItem.selectedEntry
                }
            }
        }
    }
}
