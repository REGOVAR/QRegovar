import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2

import "../Regovar"

Item
{
    id: root


    property var tabsModel
    property var tabSharedModel


    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        ListView
        {
            id: headersListView
            anchors.fill: header
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
            interactive: false
            model: root.tabsModel
            currentIndex: screensListView.currentIndex
            delegate: Item
            {
                width: headerLabel.width + headersListView.height * 0.4
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                Text
                {
                    id: headerLabel
                    anchors.centerIn: parent
                    text: model.title
                    font.pixelSize: headersListView.height * 0.3
                    font.capitalization: Font.AllUppercase
                }

                Rectangle
                {
                    visible: index !== 0
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1
                    height: parent.height * 0.4
                    color: "lightgray"
                }

                Rectangle
                {
                    visible: index !== headersListView.count - 1
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1
                    height: parent.height * 0.4
                    color: "lightgray"
                }

                Rectangle
                {
                    anchors.fill: parent
                    opacity: (headerMouseArea.pressed) ? 0.4 : 0
                    color: "#80c342"

                    Behavior on opacity
                    {
                        NumberAnimation
                        {
                            duration: 200
                        }
                    }
                }

                MouseArea
                {
                    id: headerMouseArea
                    anchors.fill: parent
                    onClicked: screensListView.currentIndex = index
                }
            }

            highlightFollowsCurrentItem: false
            highlight: Item
            {
                x: headersListView.currentItem.x
                width: headersListView.currentItem.width
                height: stripRectangle.height * 3
                anchors.bottom: parent.bottom

                Behavior on x
                {
                    NumberAnimation
                    {
                        duration: 300
                    }
                }

                Behavior on width
                {
                    NumberAnimation
                    {
                        duration: 300
                    }
                }

                Rectangle
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: stripRectangle.height * 2
                    color: "#80c342"
                }

                Rectangle
                {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: stripRectangle.height
                    color: "#006325"
                }
            }
        }
    }

    ListView
    {
        id: screensListView
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveVelocity: 2000
        clip: true
        model: root.tabsModel
        onCurrentItemChanged:
        {
            currentItem.item.selected()
        }
        delegate: Loader
        {
            width: screensListView.width
            height: screensListView.height
            source: model.source

        }
    }
}
