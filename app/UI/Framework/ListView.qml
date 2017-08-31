import QtQuick 2.7
import QtQuick.Controls 2.0


import "../Regovar"



Rectangle
{
    id: root

    color: Regovar.theme.boxColor.back
    border.width: 1
    border.color: Regovar.theme.boxColor.border

    property alias list : browserList
    property Component delegate

    ListView
    {
        id: browserList

        anchors.fill: root
        anchors.margins: 1
        ScrollBar.vertical: ScrollBar { }
        clip:true



        // Manage selected item of the list using exing property currentIndex
        delegate: Rectangle
        {
            id: browserListItemRoot
            height: 22
            anchors.left: parent.left
            anchors.right: parent.right

            ItemDelegate
            {
                contentItem: delegate
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: browserListItemRoot.selectedIndex = index
//                hoverEnabled: true
//                onEntered: browserListItemRoot.state = "hover"
//                onExited: browserListItemRoot.state = browserListItemRoot.currentState
            }



            // Manage selected item of the list using exing property currentIndex
            property int selectedIndex
            // Bidirectional binding between selectedEntry properties of the listview and its items
            Binding {
                target: browserListItemRoot
                property: "selectedIndex"
                value: browserList.currentIndex
            }
            Binding {
                target: browserList
                property: "currentIndex"
                value: browserListItemRoot.selectedIndex
            }



            // Manage style and states of the listview item
            property string mainState
            property string currentState
            onCurrentStateChanged: browserListItemRoot.state = browserListItemRoot.currentState
            onSelectedIndexChanged: browserListItemRoot.currentState = (browserListItemRoot.selectedIndex == index) ? "selected" : browserListItemRoot.mainState
            Component.onCompleted:
            {
                browserListItemRoot.mainState = index % 2 == 0 ? "alt1" : "alt2"
                browserListItemRoot.currentState = browserListItemRoot.mainState
            }


            states:
            [
                State
                {
                    name: "alt1"
                    PropertyChanges { target: browserListItemRoot; color: Regovar.theme.backgroundColor.main}
                },
                State
                {
                    name: "alt2"
                    PropertyChanges { target: browserListItemRoot; color: Regovar.theme.boxColor.back}
                },
                State
                {
                    name: "selected"
                    PropertyChanges { target: browserListItemRoot; color: Regovar.theme.secondaryColor.back.light}
                }
//                State
//                {
//                    name: "hover"
//                    PropertyChanges { target: browserListItemRoot; color: Regovar.theme.secondaryColor.back.normal}
//                    PropertyChanges { target: browserListItemText; color: Regovar.theme.secondaryColor.front.normal}

//                }
            ]
        }
    }
}



