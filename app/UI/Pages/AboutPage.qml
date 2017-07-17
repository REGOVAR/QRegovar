import QtQuick 2.7
import QtGraphicalEffects 1.0

import "../Regovar"
import "../Framework"

Rectangle
{
    id: root

    color: Regovar.theme.backgroundColor.main



    Rectangle
    {
        id: browserRoot
        anchors.fill: parent
        anchors.margins: 10

        color: Regovar.theme.boxColor.back
        border.width: 1
        border.color: Regovar.theme.boxColor.border

        Rectangle
        {
            id: browserHeader
            anchors.left: browserRoot.left
            anchors.right: browserRoot.right
            anchors.top: browserRoot.top
            height: 24

            border.width: 1
            border.color: Regovar.theme.boxColor.border

            LinearGradient
            {
                anchors.fill: parent
                anchors.margins: 1
                start: Qt.point(0, 0)
                end: Qt.point(0, 24)
                gradient: Gradient
                {
                    GradientStop { position: 0.0; color: "#fcfcfd" }
                    GradientStop { position: 1.0; color: "#e7e7e7" }
                }
            }

            Row
            {
                anchors.fill: parent

                Text
                {
                    leftPadding: 4
                    height: parent.height
                    width: 200
                    text: "Name"
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.font.familly
                    font.bold: false
                    color: Regovar.theme.frontColor.normal
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                Rectangle
                {
                    width: 1
                    height: parent.height
                    color: Regovar.theme.boxColor.border

                    MouseArea
                    {
                        anchors.fill: parent
                        anchors.leftMargin: -2
                        anchors.rightMargin: -2
                        hoverEnabled: true
                        onEntered: cursorShape = Qt.SplitHCursor
                        onExited: cursorShape = Qt.ArrowCursor
                    }
                }

                Text
                {
                    leftPadding: 4
                    height: parent.height
                    width: 200
                    text: "Date"
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.font.familly
                    font.bold: false
                    color: Regovar.theme.frontColor.normal
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                Rectangle
                {
                    width: 1
                    height: parent.height
                    color: Regovar.theme.boxColor.border

                    MouseArea
                    {
                        anchors.fill: parent
                        anchors.leftMargin: -2
                        anchors.rightMargin: -2
                        hoverEnabled: true
                        onEntered: cursorShape = Qt.SplitHCursor
                        onExited: cursorShape = Qt.ArrowCursor
                    }
                }

                Text
                {
                    leftPadding: 4
                    height: parent.height
                    text: "Comment"
                    font.pixelSize: Regovar.theme.font.size.control
                    font.family: Regovar.theme.font.familly
                    font.bold: false
                    color: Regovar.theme.frontColor.normal
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }
        }

        ListView
        {
            id: browserList

            anchors.left: browserRoot.left
            anchors.top: browserHeader.bottom
            anchors.right: browserRoot.right
            anchors.bottom: browserRoot.bottom
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

                Text
                {
                    id: browserListItemText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    text: "salut : " + index + " " + browserList.model[index]["name"]
                    font.pixelSize: Regovar.theme.font.size.content
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    anchors.margins: 4
                }
                Text
                {
                    anchors.right: parent.right
                    text: "idx : " + index + ", selectedIdx : " + browserListItemRoot.selectedIndex + ", currentState : " + browserListItemRoot.currentState
                    font.pixelSize: Regovar.theme.font.size.content
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    anchors.margins: 4
                }
                MouseArea
                {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: browserListItemRoot.selectedIndex = index
                    onEntered: browserListItemRoot.state = "hover"
                    onExited: browserListItemRoot.state = browserListItemRoot.currentState
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
                        PropertyChanges { target: browserListItemText; color: Regovar.theme.frontColor.normal}
                    },
                    State
                    {
                        name: "alt2"
                        PropertyChanges { target: browserListItemRoot; color: Regovar.theme.boxColor.back}
                        PropertyChanges { target: browserListItemText; color: Regovar.theme.frontColor.normal}
                    },
                    State
                    {
                        name: "selected"
                        PropertyChanges { target: browserListItemRoot; color: Regovar.theme.secondaryColor.back.light}
                        PropertyChanges { target: browserListItemText; color: Regovar.theme.secondaryColor.front.light}
                    },
                    State
                    {
                        name: "hover"
                        PropertyChanges { target: browserListItemRoot; color: Regovar.theme.secondaryColor.back.normal}
                        PropertyChanges { target: browserListItemText; color: Regovar.theme.secondaryColor.front.normal}

                    }
                ]
            }
        }
    }
}
