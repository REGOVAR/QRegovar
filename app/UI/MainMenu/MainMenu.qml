import QtQuick 2.7
import "../Regovar"

Item
{
    id: mainMenu

    property string selectedEntry: ""


    ListModel
    {
        id: menuModel
        Component.onCompleted: { menuModel.append(Regovar.mainMenu.model["menu"])}
    }

    ListModel
    {
        id: subMenuModel
    }

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
