import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    property int subjectId
    property int sampleId

    property real dateColWidth: 150
    property string date: ""
    property string name: ""
    property string subjectIdentifiant: ""
    property string subjectLastName: ""
    property string subjectFirstName: ""

    property bool isHover: false
    signal clicked(var analysisId)

    height: Regovar.theme.font.boxSize.control
    color: "transparent"
    Row
    {
        anchors.fill: parent
        Rectangle
        {
            width: Regovar.theme.font.boxSize.control
            height: Regovar.theme.font.boxSize.control
            color: "transparent"
        }
        Text
        {
            width: dateColWidth
            font.pixelSize: Regovar.theme.font.size.control
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.disable
            verticalAlignment: Text.AlignVCenter
            text: "2017-08-27 14h15" // date
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
            text: "4"
        }

        Text
        {
            font.pixelSize: Regovar.theme.font.size.control
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            font.family: "monospace"
            text: "MD-02-75"+ " - "
        }
        Text
        {
            font.pixelSize: Regovar.theme.font.size.control
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            font.family: Regovar.theme.font.familly
            text: "DUPONT" + " "
        }
        Text
        {
            font.pixelSize: Regovar.theme.font.size.control
            color: isHover ?  Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: "Michel" + " (64y)"
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
