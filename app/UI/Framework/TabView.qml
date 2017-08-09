import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2

Item
{
    id: root
    property var model

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        ListView
        {
            id: headersListView
            Layout.fillWidth: true
            Layout.preferredHeight: 16 * Screen.logicalPixelDensity
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
            interactive: false
            model: swipeView.model
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
                    font.capitalization: Font.AllUppercasej
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

            Rectangle
            {
                id: stripRectangle
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: parent.height * 0.05
                z: -1
                color: "lightgray"
            }
        }

    }
}
