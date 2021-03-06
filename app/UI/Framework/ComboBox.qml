import QtQuick 2.9
import QtQuick.Controls 2.2
import "qrc:/qml/Regovar"


ComboBox
{
    id: control
    model: -1 // DO NOT CHANGE DEFAULT VALUE AS IT'S USED TO KNOW WHEN COMBO BOX MODEL IS SET

    property var color: Regovar.theme.boxColor.border

//    delegate: ItemDelegate
//    {
//        x: 1
//        width: control.width -2
//        height: Regovar.theme.font.boxSize.normal
//        contentItem: Text
//        {
//            text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
//            color: enabled ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
//            font: control.font
//            elide: Text.ElideRight
//            verticalAlignment: Text.AlignVCenter
//        }
//        highlighted: control.highlightedIndex === index
//    }

    indicator: Text
    {
        anchors.right: control.right
        text: "["
        width: Regovar.theme.font.boxSize.normal
        height: Regovar.theme.font.boxSize.normal
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
        font.pixelSize: Regovar.theme.font.size.normal
        font.family: Regovar.theme.font.family
        elide: Text.ElideRight
    }

    background: Rectangle
    {
        implicitWidth: 40
        implicitHeight: Regovar.theme.font.boxSize.normal
        color: enabled ? Regovar.theme.boxColor.back : "transparent"
        border.color: !enabled ? Regovar.theme.frontColor.disable : control.pressed ? Regovar.theme.secondaryColor.back.light : control.color
        border.width: 1
        radius: 2
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

            delegate:Text
            {
                leftPadding: 5
                rightPadding: 5

                text: control.displayText
                color: Regovar.theme.boxColor.front
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                elide: Text.ElideRight
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle
        {
            border.color: control.color
            radius: 2
        }
    }
}
