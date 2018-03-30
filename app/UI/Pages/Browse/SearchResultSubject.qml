import QtQuick 2.9
import QtQuick.Layouts 1.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    property int subjectId


    property real dateColWidth: 100
    property string date: ""
    property string identifier: ""
    property string firstname: ""
    property string lastname: ""
    property string sex: ""
    property string age: ""
    property int indent: 1

    property bool isHover: false
    signal clicked(var subjectId)

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
            text: regovar.formatDate(date)
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
            text: Regovar.sexToIcon(sex)
        }

        Text
        {
            font.pixelSize: Regovar.theme.font.size.normal
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            font.family: "monospace"
            text: identifier
        }
        Text
        {
            Layout.minimumWidth: Regovar.theme.font.boxSize.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.icons.name
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: "{"
            elide: Text.ElideRight
        }

        Text
        {
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: lastname + " " + firstname + (age ? " (" + age + ")" : "")
            elide: Text.ElideRight
        }
    }

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: isHover = true
        onExited: isHover = false
        onClicked: root.clicked(subjectId)
    }
}
