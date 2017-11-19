import QtQuick 2.7
import "../../Regovar"

Rectangle
{
    id: root
    height: Regovar.theme.font.boxSize.header
    implicitWidth: 200

    property string url: ""
    property string iconText: ""
    property string label: ""
    property bool isHover: false

    color: (isHover) ? Regovar.theme.secondaryColor.back.light : Regovar.theme.backgroundColor.main

    Row
    {
        anchors.fill: parent

        Text
        {
            text: root.iconText
            width: Regovar.theme.font.boxSize.header
            height: Regovar.theme.font.boxSize.header

            font.family: Regovar.theme.icons.name
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text
        {
            text: root.label
            font.family: "monospace"
            height: Regovar.theme.font.boxSize.header
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea
    {
        anchors.fill: root
        cursorShape: (root.enabled) ? Qt.PointingHandCursor : Qt.ArrowCursor
        hoverEnabled: true
        onEntered: root.isHover = true
        onExited: root.isHover = false
        onClicked:
        {
            if (root.url != "")
            {
                Qt.openUrlExternally(root.url);
            }
        }
    }
}
