import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../Regovar"

Rectangle
{
    id: root
    implicitWidth: 300
    height: 100

    property alias iconText: icon.text
    property alias iconImage: image.source
    property alias title: title.text
    property alias text: text.text


    color: Regovar.theme.primaryColor.back.normal

    Text
    {
        id: icon
        anchors.top : parent.top
        anchors.left: parent.left
        anchors.margins: 10
        width: 80
        height: 80
        font.pixelSize: 80
        font.family: Regovar.theme.icons.name
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        color: Regovar.theme.primaryColor.front.normal

        visible: text != ""
    }
    Image
    {
        id: image
        anchors.top : parent.top
        anchors.left: parent.left
        anchors.margins: 10
        width: 80
        height: 80


        ColorOverlay
        {
            anchors.fill: parent
            color: Regovar.theme.primaryColor.front.normal
            source: image
        }
        visible: source != ""
    }

    Text
    {
        id: title
        anchors.top : parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.leftMargin: 100
        font.pixelSize: Regovar.theme.font.size.title
        font.bold: true
        color: Regovar.theme.primaryColor.front.normal
        elide: Text.ElideRight
    }
    Text
    {
        id: text
        anchors.top : parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        anchors.topMargin: 15 + Regovar.theme.font.size.title
        anchors.leftMargin: 100
        wrapMode: "WordWrap"
        elide: Text.ElideRight
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.front.normal
    }
}
