import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"

Rectangle
{
    id: root
    height: Regovar.theme.font.boxSize.control
    implicitHeight: Regovar.theme.font.boxSize.control
    color: "transparent"

    property FilteringAnalysis analysis
    property AdvancedFilterModel model

    // We don't use default qml enabled property to keep MouseArea available even when the
    // control is disabled
    property bool isEnabled: true
    onIsEnabledChanged: textColor = (root.isEnabled) ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable;

    property var textColor: Regovar.theme.frontColor.normal

    property bool mouseHover: false

    Rectangle
    {
        anchors.fill: parent
        color: "transparent"


        Row
        {
            anchors.left: parent.left
            anchors.right: controls.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            spacing: 5


            Text
            {
                id: leftOp
                text: model.leftOp
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                color: root.textColor
            }
            Text
            {
                id: operator
                text: model.opRegovarToFriend(model.op)
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                color: root.textColor
            }
            Text
            {
                id: rightOp
                text: model.rightOp
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                color: root.textColor
            }
        }


        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.mouseHover = true
            onExited: root.mouseHover = false
        }

        Row
        {
            id: controls
            anchors.top: parent.top
            anchors.right: parent.right
            visible: root.mouseHover

            Text
            {
                text: "A"
                height: Regovar.theme.font.boxSize.header
                width: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.normal
                font.family: Regovar.theme.icons.name

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: root.model.editCondition()
                    hoverEnabled: true
                    onEntered:
                    {
                        root.mouseHover = true;
                        root.textColor = Regovar.theme.secondaryColor.back.normal;
                        parent.color = Regovar.theme.secondaryColor.back.normal;
                    }
                    onExited:
                    {
                        root.mouseHover = false;
                        root.textColor = (root.isEnabled) ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable;
                        parent.color = Regovar.theme.primaryColor.back.normal;
                    }
                }
            }
            Text
            {
                text: "h"
                height: Regovar.theme.font.boxSize.header
                width: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.normal
                font.family: Regovar.theme.icons.name

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: root.model.removeCondition()
                    hoverEnabled: true
                    onEntered:
                    {
                        root.mouseHover = true;
                        root.textColor = Regovar.theme.frontColor.danger;
                        parent.color =  Regovar.theme.frontColor.danger;
                    }
                    onExited:
                    {
                        root.mouseHover = false;
                        root.textColor = (root.isEnabled) ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable;
                        parent.color = Regovar.theme.primaryColor.back.normal;
                    }
                }
            }
        }
    }
}
