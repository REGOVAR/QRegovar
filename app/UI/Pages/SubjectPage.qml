import QtQuick 2.7
import QtQuick.Controls 1.4

import org.regovar 1.0


import "../Regovar"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main




    TreeView
    {
        anchors.fill: parent
        itemDelegate: Text
        {
            anchors.fill: parent
            color: Regovar.theme.font.main
            text: "tab : " + index
        }

        TableViewColumn
        {
            role: "title"
            title: "Title"
        }

        TableViewColumn
        {
            role: "summary"
            title: "Summary"
        }
    }
}

