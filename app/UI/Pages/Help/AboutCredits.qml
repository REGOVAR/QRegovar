import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../../Regovar"

Item
{
    id: root



    Column
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5


        Text
        {
            text: qsTr("Thanks to")
            font.pixelSize: Regovar.theme.font.size.header
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
            Layout.columnSpan: 2
        }

        TextEdit
        {
            text: "Anne-Sophie DENOMME-PICHON, David GOUDEGENE,  Jérémie ROQUET, June SALLOU, Olivier GUEUDELOT, Sacha SCHUTZ"
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            readOnly: true
            selectByMouse: true
            selectByKeyboard: true
        }

        Rectangle
        {
            color: "transparent"
            Layout.columnSpan: 2
            height: 15
            width: 50
            Rectangle
            {
                width: 50
                height: 1
                anchors.verticalCenter: parent.verticalCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }

        Text
        {
            text: qsTr("Tools")
            font.pixelSize: Regovar.theme.font.size.header
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
            Layout.columnSpan: 2
        }


        Text
        {
            text: "Ubuntu 16"
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
        }
        Text
        {
            text: "Python 3.5"
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
        }
        Text
        {
            text: "PostgresSQL 9.5"
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
        }
        Text
        {
            text: "Qt 5.9"
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
        }


    }
}
