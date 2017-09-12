import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    property int analysisId
    property real dateColWidth: 150
    property string date: ""
    property string name: ""
    property string projectName: ""
    property int indent: 1

    property bool isHover: false
    signal clicked()

    height: Regovar.theme.font.boxSize.control
    color: "transparent"
    Row
    {
        anchors.fill: parent
        Rectangle
        {
            width: indent * Regovar.theme.font.boxSize.control
            height: Regovar.theme.font.boxSize.control
            color: "transparent"
        }
        Text
        {
            width: dateColWidth
            font.pixelSize: Regovar.theme.font.size.control
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.disable
            verticalAlignment: Text.AlignVCenter
            text: date
            elide: Text.ElideRight
        }
        Rectangle
        {
            width: Regovar.theme.font.boxSize.control
            height: Regovar.theme.font.boxSize.control
            color: "transparent"
        }
        Text
        {
            width: Regovar.theme.font.boxSize.control
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.icons.name
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: "I"
        }

        Text
        {
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: projectName
        }
        Text
        {
            width: Regovar.theme.font.boxSize.control
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.icons.name
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: "{"
        }

        Text
        {
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: name
        }
    }

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: isHover = true
        onExited: isHover = false
        onClicked: root.clicked()
    }
}
