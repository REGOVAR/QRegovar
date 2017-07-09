import QtQuick 2.7

import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

Rectangle
{
    id: root

    color: ColorTheme.backgroundColor

    Text
    {
       text: "Welcome " //+ regovar.currentUser.firstname
       color: "#55999999"
       font.family: "Sans"
       font.weight: Font.Black
       font.pointSize: 24
       anchors.left: parent.left
       anchors.top: parent.top
       anchors.topMargin: 30
       anchors.leftMargin: 30
    }

    Item
    {
        id: logo
        width: 300
        height: 100

//        Image
//        {
//            source: "qrc:///img/sandbox.png"
//            height: 100
//            width: 300
//            anchors.left: logo.left
//            anchors.bottom: logo.bottom
//            anchors.bottomMargin: 7
//        }
        anchors.right: root.right
        anchors.rightMargin: 10
        anchors.bottom: root.bottom
        anchors.bottomMargin: 10
    }

}
