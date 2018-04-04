import QtQuick 2.9
import QtQuick.Controls 1.4

import "qrc:/qml/Regovar"

SplitView
{
    id: control
    handleDelegate: Rectangle
    {
        width: control.orientation === Qt.Horizontal ? 1 : control.width
        height: control.orientation === Qt.Vertical ? 1 : control.height
        color: Regovar.theme.boxColor.border
    }
}
