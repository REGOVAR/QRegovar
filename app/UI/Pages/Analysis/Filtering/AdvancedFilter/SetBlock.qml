import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"

Rectangle
{
    id: root
    height: Regovar.theme.font.boxSize.normal
    implicitHeight: Regovar.theme.font.boxSize.normal
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




        Text
        {
            anchors.left: parent.left
            anchors.right: controls.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            text: "variant " + model.opRegovarToFriend(model.op) + " " + model.rightOp
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.normal
            color: root.textColor
            elide: Text.ElideRight
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
            //width: root.mouseHover ? 2*Regovar.theme.font.boxSize.normal : 0

            Text
            {
                text: "A"
                height: Regovar.theme.font.boxSize.normal
                width: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Regovar.theme.font.size.normal
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
                height: Regovar.theme.font.boxSize.normal
                width: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Regovar.theme.font.size.normal
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
