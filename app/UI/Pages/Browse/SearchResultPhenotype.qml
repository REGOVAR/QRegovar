import QtQuick 2.9
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    property string phenotypeId
    property real dateColWidth: 100
    property string date: ""
    property string label: ""

    property bool isHover: false
    signal clicked(var phenotypeId)

    height: Regovar.theme.font.boxSize.normal
    color: "transparent"
    RowLayout
    {
        spacing: 0
        anchors.fill: parent
        Rectangle
        {
            width: Regovar.theme.font.boxSize.normal
            height: Regovar.theme.font.boxSize.normal
            color: "transparent"
        }
        Text
        {
            Layout.minimumWidth: dateColWidth
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: "monospace"
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.disable
            verticalAlignment: Text.AlignVCenter
            text: phenotypeId
            elide: Text.ElideRight
        }
        Rectangle
        {
            width: Regovar.theme.font.boxSize.normal
            height: Regovar.theme.font.boxSize.normal
            color: "transparent"
        }
        Text
        {
            Layout.minimumWidth: Regovar.theme.font.boxSize.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.icons.name
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: "K"
        }

        Text
        {
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: label
        }
    }

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: isHover = true
        onExited: isHover = false
        onClicked: root.clicked(phenotypeId)
    }
}
