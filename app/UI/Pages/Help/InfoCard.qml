import QtQuick 2.9
import QtQuick.Layouts 1.3
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"


Rectangle
{
    id: root
    height: 70
    width: 150
    clip: true

    color: Regovar.theme.boxColor.back
    border.width: 1
    border.color: Regovar.theme.boxColor.border

    property alias iconSource: icon.source
    property alias title: title.text
    property alias text: comment.text
    property string url: ""

    Image
    {
        id: icon
        width: 50
        height: 50
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        fillMode: Image.PreserveAspectFit
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        anchors.leftMargin: 70
        spacing: 4

        Text
        {
            id: title
            Layout.fillWidth: true
            Layout.maximumHeight: 3 * Regovar.theme.font.size.header
            text: "-"
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.normal
            wrapMode: Text.Wrap
            elide: Text.ElideRight
        }

        Text
        {
            id: comment
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: ""
            font.italic: true
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.disable
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }
    MouseArea
    {
        anchors.fill: parent
        enabled: url
        cursorShape: (url) ? "PointingHandCursor" : "ArrowCursor"
        onClicked: Qt.openUrlExternally(url);
        hoverEnabled: true
        onEntered: root.border.color = Regovar.theme.secondaryColor.back.light
        onExited: root.border.color = Regovar.theme.boxColor.border
    }
}
