import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.boxColor.back
    border.width: 1
    border.color: Regovar.theme.boxColor.border

    property bool isEnabled: false

    state: "collapsed"

    FontLoader
    {
        id : iconFont
        source: "../../../../Icons.ttf"
    }

    Rectangle
    {
        id: header
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right

        height: 30
        color: Regovar.theme.backgroundColor.main


        Text
        {
            id: activeIcon
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.left: header.left
            width: 30
            text: "n"
            font.family: iconFont.name
            font.pixelSize: Regovar.theme.font.size.header
            color: root.isEnabled ? Regovar.theme.primaryColor.back.dark : Regovar.theme.primaryColor.back.light

        }

        Text
        {
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.left: header.left
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            anchors.right: header.right

            text: qsTr("Inheritance mode")
            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.dark
        }

        Text
        {
            id: collapseIcon
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.right: header.right
            width: 30
            height: 30
            text: "{"
            font.family: iconFont.name
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.dark
        }

        MouseArea
        {
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.left: header.left
            anchors.right: header.right
            anchors.leftMargin: 50

            cursorShape: "PointingHandCursor"

            onClicked:
            {
                console.log("click");
                root.state = (root.state == "collapsed") ? "expanded" : "collapsed"
            }
        }

        Rectangle
        {
            anchors.bottom: header.bottom
            anchors.left: header.left
            anchors.right: header.right
            height: 1
            color: Regovar.theme.boxColor.border
        }
    }



    Column
    {
        id: content
        anchors.top: header.bottom
        anchors.left: root.left
        anchors.right: root.right

        visible: false

        CheckBox
        {
            text: qsTr("Heterozygous")
            onCheckedChanged: regovar.currentQuickFilters.transmissionFilter.setFilter(0, checked)
        }
        CheckBox
        {
            text: qsTr("Homozygous")
            onCheckedChanged: regovar.currentQuickFilters.transmissionFilter.setFilter(1, checked)
        }
        CheckBox
        {
            text: qsTr("Composite heterozygous")
            onCheckedChanged: regovar.currentQuickFilters.transmissionFilter.setFilter(2, checked)
        }
    }


    states:
    [
        State
        {
            name: "collapsed"
            PropertyChanges { target: collapseIcon; rotation: 0}
            PropertyChanges { target: content; visible: false}
        },
        State
        {
            name: "expanded"
            PropertyChanges { target: collapseIcon; rotation: 90}
            PropertyChanges { target: content; visible: true}
        }
    ]
}
