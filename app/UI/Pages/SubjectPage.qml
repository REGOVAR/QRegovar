import QtQuick 2.7
import QtQuick.Controls 1.4

import "../Regovar"

Rectangle
{
    id: root

    color: Regovar.theme.backgroundColor.main

    Text
    {
       text: "SUBJECTS " //+ regovar.currentUser.firstname
       color: "#55999999"
       font.family: "Sans"
       font.weight: Font.Black
       font.pointSize: 24
       anchors.left: parent.left
       anchors.top: parent.top
       anchors.topMargin: 30
       anchors.leftMargin: 30
    }
}

