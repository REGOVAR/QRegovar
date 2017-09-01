import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"

Rectangle
{
    id: root
    width: parent.width
    implicitHeight: Regovar.theme.font.boxSize.control

    property var model


    Text
    {
        anchors.fill: root
        text: "the field block !"
    }
}
