import QtQuick 2.0
import QtQuick.Controls 2.2
import "../../../Regovar"

Popup
{
    id: root


    width: 200
    height: rootLayout.height + 2

    property string title: ""
    property string varsomUrl: ""
    property string marrvelUrl: ""

    property string gene: ""

    modal: Qt.NonModal
    padding: 1
    background: Rectangle
    {
        color: Regovar.theme.backgroundColor.main
        border.width: 1
        border.color: Regovar.theme.boxColor.border
    }



    Column
    {
        id: rootLayout

        Rectangle
        {
            id: header
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: Regovar.theme.primaryColor.back.normal

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "j"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.front.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: root.title
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.front.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle
            {
                height: 1
                width: root.width
                anchors.bottom: header.bottom
                color: Regovar.theme.primaryColor.back.darker
            }
        }

        ResultContextMenuAction
        {
            url: root.varsomUrl
            iconText: "_"
            label: "Varsom"
            width: root.width - 2
        }

        ResultContextMenuAction
        {
            url: root.marrvelUrl
            iconText: "_"
            label: "Marrvel"
            width: root.width - 2
        }
    }
}
