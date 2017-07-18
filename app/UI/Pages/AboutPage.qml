import QtQuick 2.7
import QtGraphicalEffects 1.0

import "../Regovar"
import "../Framework"

Rectangle
{
    id: root

    color: Regovar.theme.backgroundColor.main




    ListView
    {
        id: list
        anchors.fill: root
        anchors.margins: 10


        list.model: 50

        delegate: Text
        {
            text: index
            color: list.currentIndex == index ? Regovar.theme.secondaryColor.front.light : Regovar.theme.frontColor.normal
        }
    }
}
