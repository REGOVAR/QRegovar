import QtQuick 2.0
//import QtQuick.Controls 2.0
//import QtQuick.Layouts 1.3
//import QtGraphicalEffects 1.0

import "components/mainmenu"
import "pages"
Item
{
    id: root

//    LinearGradient
//    {
//        anchors.fill: parent
//        start: Qt.point(0, 0)
//        end: Qt.point(0, 600)
//        gradient: Gradient
//        {
//            GradientStop { position: 0.0; color: "#00FFFFFF" }
//            GradientStop { position: 1.0; color: "#DDDDDDFF" }
//        }
//    }




    MainMenu
    {
        id: mainMenu
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.left: root.left
        width: 300
    }

    WelcomPage
    {
        id: page
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.left: mainMenu.right
        anchors.right: root.right

    }

}
