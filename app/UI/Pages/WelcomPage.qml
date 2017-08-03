import QtQuick 2.7
import "../Framework"
import "../Regovar"

Rectangle
{
    id: root

    color: Regovar.theme.backgroundColor.main

    Text
    {
       text: "Welcome" //+ regovar.currentUser.firstname
       color: "#55999999"
       font.family: "Sans"
       font.weight: Font.Black
       font.pointSize: 24
       anchors.left: parent.left
       anchors.top: parent.top
       anchors.topMargin: 30
       anchors.leftMargin: 30
    }


//    Row
//    {
//        anchors.centerIn: parent
//        spacing: 20

//        Rectangle
//        {
//            width: 310
//            height: 310
//            color: "red"
//            border.width: 1
//            border.color: "black"

//            BusyIndicator
//            {
//                width: 300
//                height: 300
//                anchors.centerIn: parent
//            }
//        }

//        Rectangle
//        {
//            width: 210
//            height: 210
//            color: "red"
//            border.width: 1
//            border.color: "black"

//            BusyIndicator
//            {
//                width: 200
//                height: 200
//                anchors.centerIn: parent
//            }
//        }

//        Rectangle
//        {
//            width: 110
//            height: 110
//            color: "red"
//            border.width: 1
//            border.color: "black"

//            BusyIndicator
//            {
//                width: 100
//                height: 100
//                anchors.centerIn: parent
//            }
//        }

//        Rectangle
//        {
//            width: 24
//            height: 24
//            color: "red"
//            border.width: 1
//            border.color: "black"

//            BusyIndicator
//            {
//                width: 22
//                height: 22
//                anchors.centerIn: parent
//            }
//        }

//        Rectangle
//        {
//            width: 18
//            height: 18
//            color: "red"
//            border.width: 1
//            border.color: "black"

//            BusyIndicator
//            {
//                width: 16
//                height: 16
//                anchors.centerIn: parent
//            }
//        }
//    }
}
