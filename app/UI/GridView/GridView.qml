import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "../Style"




Rectangle
{
    id: root
    color: Style.boxColor.back
    border.width: 1
    border.color: Style.boxColor.border

    property alias interactive: content.interactive
    property var model
    property Item delegate

    // Manage headers of the grid
    property var headers
    onHeadersChanged:
    {
        if (headers.length > 0)
        {
            console.log("Salut, il faut regler les headers")
            headerContent.model = headers
        }
    }


    Column
    {
        anchors.fill: root
        anchors.margins: 1

        Row
        {
            id: header
            visible: true
            Repeater
            {
                id: headerContent

                Rectangle
                {
                    border.width: 1
                    border.color: Style.boxColor.border
                    height: 24

                    LinearGradient
                    {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, 300)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#e7e7e7" }
                            GradientStop { position: 1.0; color: "#fcfcfd" }
                        }
                    }

                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        text: title
                        font.pixelSize: Style.font.size.control
                        font.family: Style.font.familly
                        font.bold: false
                        color: Style.frontColor.normal
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }
            }
        }

        ListView
        {
            id: content
            interactive: true
            clip:true

            model: root.model
            delegate: GridViewItem
            {
                model: root.model[index]
                contentItem: root.delegate
            }
            ScrollBar.vertical: ScrollBar { }
        }
    }

}



