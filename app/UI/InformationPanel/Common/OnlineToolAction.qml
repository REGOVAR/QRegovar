import QtQuick 2.9
import QtQuick.Layouts 1.3
import "qrc:/qml/Regovar"

Rectangle
{
    id: root
    height: Regovar.theme.font.boxSize.header
    implicitWidth: 200

    property string url: ""
    property string icon: ""
    property string label: ""
    property bool isHover: false
    property var model

    color: (isHover) ? Regovar.theme.secondaryColor.back.light : Regovar.theme.backgroundColor.main

    RowLayout
    {
        anchors.fill: parent

        Text
        {
            text: root.icon
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
            height: Regovar.theme.font.boxSize.header

            font.family: Regovar.theme.icons.name
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            text: root.label
            font.family: fixedFont
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    MouseArea
    {
        anchors.fill: parent
        cursorShape: (root.enabled) ? Qt.PointingHandCursor : Qt.ArrowCursor
        hoverEnabled: true
        onEntered: root.isHover = true
        onExited: root.isHover = false
        onClicked:
        {
            var finalUrl = root.url;
            if (model)
            {
                for (var idx=0; idx<model.length; idx++)
                {
                    finalUrl = finalUrl.replace("{" + idx + "}", model[idx]);
                }
            }
            Qt.openUrlExternally(finalUrl);
        }
    }
}
