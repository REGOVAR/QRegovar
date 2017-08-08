import QtQuick 2.7
import QtQuick.Window 2.3

Window
{
    id: root
    visible: true
    title: "Analysis - My analysis"
    width: 800
    height: 600

    Rectangle
    {

        anchors.fill: parent

        color: "lightGrey"

        Text {

            anchors.centerIn: parent

            text: "My New Window"
        }
    }
}
