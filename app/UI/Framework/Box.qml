import QtQuick 2.9
import QtQuick.Layouts 1.3
import "qrc:/qml/Regovar"

Rectangle
{
    id: root

    property string icon: "k"
    property bool iconAnimation: false
    property string text: "A text box"
    property string mainColor: Regovar.theme.frontColor.info

    color: Regovar.theme.lighter(root.mainColor)
    border.width: 1
    border.color: root.mainColor
    Component.onCompleted: setAnimation()

    onIconAnimationChanged:setAnimation()

    function setAnimation()
    {
        if (iconAnimation)
        {
            logo.rotation = 0;
            logoAnimation.start();
        }
        else
        {
            logoAnimation.stop();
            logo.rotation = 0;
        }
    }


    Text
    {
        id: logo
        width: Regovar.theme.font.boxSize.header
        height: Regovar.theme.font.boxSize.normal
        anchors.left: root.left
        anchors.top: root.top
        text: root.icon
        font.family: Regovar.theme.icons.name
        font.pixelSize: Regovar.theme.font.size.normal
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: mainColor
        NumberAnimation on rotation
        {
            id: logoAnimation
            duration: 1500
            loops: Animation.Infinite
            from: 0
            to: 360

        }
    }

    TextEdit
    {
        id: message
        anchors.left: logo.right
        anchors.right: root.right
        anchors.top: root.top
        anchors.margins: 5
        anchors.leftMargin: 0
        onContentHeightChanged: root.height = contentHeight + 10
        readOnly: true

        text: root.text
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.darker(root.mainColor)
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        selectByMouse: true
    }
}
