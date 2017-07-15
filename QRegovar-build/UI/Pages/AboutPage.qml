import QtQuick 2.7
import QtQuick.Controls 2.0

import "../Regovar"

Rectangle
{
    id: parent

    color: Regovar.theme.backgroundColor.main


    ListView
    {
        anchors.fill: parent


        model: 100


    }
}
