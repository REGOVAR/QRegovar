import QtQuick 2.7
import QtQuick.Controls 2.2
import "../Regovar"


ComboBox
{
    id: control
    model: ["First", "Second", "Third"]

    delegate: ItemDelegate
    {
        width: control.width
        contentItem: Text
        {
            text: modelData
            color: Regovar.theme.boxColor.front
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: control.highlightedIndex === index
    }

    indicator: Text
    {
        anchors.right: control.right
        text: "["
        width: Regovar.theme.font.boxSize.control
        height: Regovar.theme.font.boxSize.control
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: Regovar.theme.icons.name
        color: control.pressed ? Regovar.theme.secondaryColor.back.light : Regovar.theme.boxColor.front
    }

    contentItem: Text
    {
        leftPadding: 5
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        color: control.pressed ? Regovar.theme.secondaryColor.back.light : Regovar.theme.boxColor.front
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle
    {
        implicitWidth: 60
        implicitHeight: Regovar.theme.font.boxSize.control
        color: Regovar.theme.boxColor.back
        border.color: control.pressed ? Regovar.theme.secondaryColor.back.light : Regovar.theme.boxColor.border
        border.width: 1
    }

    popup: Popup
    {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView
        {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle
        {
            border.color: Regovar.theme.boxColor.border
            radius: 2
        }
    }
}
