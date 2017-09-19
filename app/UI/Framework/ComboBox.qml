import QtQuick 2.7
import QtQuick.Controls 2.2
import "../Regovar"


ComboBox
{
    id: control
    model: ["First", "Second", "Third"]

    property var color: Regovar.theme.boxColor.border

    delegate: ItemDelegate
    {
        width: control.width
        height: Regovar.theme.font.boxSize.control
        contentItem: Text
        {
            text: modelData
            color: enabled ? Regovar.theme.boxColor.front : Regovar.theme.frontColor.disable
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
        color: !enabled ? Regovar.theme.frontColor.disable :  control.pressed ? Regovar.theme.secondaryColor.back.light : Regovar.theme.boxColor.front
    }

    contentItem: Text
    {
        leftPadding: 5
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        color: !enabled ? Regovar.theme.frontColor.disable : control.pressed ? Regovar.theme.secondaryColor.back.light : Regovar.theme.boxColor.front
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle
    {
        implicitWidth: 60
        implicitHeight: Regovar.theme.font.boxSize.control
        color: enabled ? Regovar.theme.boxColor.back : "transparent"
        border.color: !enabled ? Regovar.theme.frontColor.disable : control.pressed ? Regovar.theme.secondaryColor.back.light : control.color
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
            border.color: control.color
            radius: 2
        }
    }
}
