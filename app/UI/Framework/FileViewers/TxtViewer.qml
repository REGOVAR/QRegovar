import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0
import "../../Regovar"

Rectangle
{
    id: root
    property File file
    onFileChanged:
    {
        edit.text = file.readFile();
    }
    clip: true

    color: Regovar.theme.boxColor.back
    border.width: 1
    border.color: Regovar.theme.boxColor.border


    ScrollView
    {
        anchors.fill: parent
        TextEdit
        {
            id: edit
            width: root.width - 30
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
            readOnly: true
            selectByMouse: true
            selectByKeyboard: true
            wrapMode: TextEdit.Wrap
            font.family: "monospace"
        }
    }

    Button
    {
        anchors.bottom: root.bottom
        anchors.right: root.right
        text: qsTr("Open externaly")
        onClicked: Qt.openUrlExternally(file.localeFilePath);
    }
}
