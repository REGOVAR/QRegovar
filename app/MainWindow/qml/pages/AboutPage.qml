import QtQuick 2.9
import QtQuick.Controls 2.2

import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

Rectangle
{
    id: parent

    color: ColorTheme.backgroundColor


    Grid
    {
        anchors.fill: parent
        anchors.leftMargin: 350
        columns: 5
        spacing: 2

        Text
        {
           text: "ABOUT"
           font.pointSize: 24
           anchors.centerIn: parent
        }


        Button
        {
            text: "Enabled"
        }

        Button
        {
            text: "Disabled"
            enabled: false
        }

        TextField
        {
            placeholderText: "Search Project by name..."
        }

        TextField
        {
            placeholderText: "Disabled..."
            enabled: false
        }

        BusyIndicator {}

        CheckBox {}

        ComboBox {
            model: ["First", "Second", "Third"]
        }

        Dial {}

        Drawer
        {
            background: Rectangle {
                Rectangle {
                    x: parent.width - 1
                    width: 1
                    height: parent.height
                    color: "#21be2b"
                }
            }
        }

        Frame {
            background: Rectangle {
                color: "transparent"
                border.color: "#21be2b"
                radius: 2
            }

            Label {
                text: qsTr("Content goes here!")
            }
        }

        GroupBox {
            id: gpb
            title: qsTr("GroupBox")

            background: Rectangle {
                y: gpb.topPadding - gpb.padding
                width: parent.width
                height: parent.height - gpb.topPadding + gpb.padding
                color: "transparent"
                border.color: "#21be2b"
                radius: 2
            }

            Label {
                text: qsTr("Content goes here!")
            }
        }

        PageIndicator {
            id: indicator
            count: 5
            currentIndex: 2

            delegate: Rectangle {
                implicitWidth: 8
                implicitHeight: 8

                radius: width / 2
                color: "#21be2b"

                opacity: index === indicator.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 100
                    }
                }
            }
        }

        ProgressBar {
            id: pb
            value: 0.5
            padding: 2

            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                color: "#e6e6e6"
                radius: 3
            }

            contentItem: Item {
                implicitWidth: 200
                implicitHeight: 4

                Rectangle {
                    width: pb.visualPosition * parent.width
                    height: parent.height
                    radius: 2
                    color: "#17a81a"
                }
            }
        }

    }
}
