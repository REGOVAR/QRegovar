import QtQuick 2.7
import "../Regovar"

Item
{
    id: mainMenu

    // bidirectional binding of selectedEntry between view and main model
    property int selectedIndex: 0
    Binding {
        target: Regovar.mainMenu
        property: "selectedMainIndex"
        value: mainMenu.selectedIndex
    }
    Binding {
        target: mainMenu
        property: "selectedIndex"
        value: Regovar.mainMenu.selectedMainIndex
    }

    // --------------------------------------------------
    // View internals models
    // --------------------------------------------------
    ListModel
    {
        id: menuModel
        Component.onCompleted: { menuModel.append(Regovar.mainMenu.model)}
    }

    ListModel
    {
        id: subMenuModel
    }



    // --------------------------------------------------
    // The view
    // --------------------------------------------------
    Rectangle
    {
        id: back
        color: Regovar.theme.primaryColor.back.dark
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

                // Bidirectional binding between selectedIndex properties of the MainMenu and its items
                Binding {
                    target: menuItem
                    property: "selectedIndex"
                    value: mainMenu.selectedIndex
                }
                Binding {
                    target: mainMenu
                    property: "selectedIndex"
                    value: menuItem.selectedIndex
                }
            }
        }
    }
}
