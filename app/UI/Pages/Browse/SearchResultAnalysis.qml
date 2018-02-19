import QtQuick 2.9
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    property int analysisId
    property real dateColWidth: 100
    property string date: ""
    property string name: ""
    property string projectName: ""
    property int indent: 1
    property var fullpath: []
    property string status: ""

    property bool isHover: false
    signal clicked()

    height: Regovar.theme.font.boxSize.normal
    color: "transparent"
    RowLayout
    {
        spacing: 0
        anchors.fill: parent
        Rectangle
        {
            width: indent * Regovar.theme.font.boxSize.normal
            height: Regovar.theme.font.boxSize.normal
            color: "transparent"
        }
        Text
        {
            Layout.minimumWidth: dateColWidth
            font.pixelSize: Regovar.theme.font.size.normal
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.disable
            verticalAlignment: Text.AlignVCenter
            text: Regovar.formatDate(date)
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
            horizontalAlignment: Text.AlignHCenter
            text: Regovar.filteringAnalysisStatusToIcon(status)

            onTextChanged:
            {
                if (status == "computing")
                {
                    statusIconAnimation.start();
                }
                else
                {
                    statusIconAnimation.stop();
                    rotation = 0;
                }
            }

            NumberAnimation on rotation
            {
                id: statusIconAnimation
                duration: 1000
                loops: Animation.Infinite
                from: 0
                to: 360
            }
            elide: Text.ElideRight
        }

        Repeater
        {
            model: fullpath

            Row
            {
                spacing: 0
                Text
                {
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: modelData.name
                    elide: Text.ElideRight
                }
                Text
                {
                    width: Regovar.theme.font.boxSize.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.icons.name
                    color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "{"
                    elide: Text.ElideRight
                }
            }
        }

        Text
        {
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: name
            elide: Text.ElideRight
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
