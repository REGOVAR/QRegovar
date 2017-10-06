import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true
    onZChanged: checkReady()
    Component.onCompleted: checkReady()
    property real labelColWidth: 100

    function checkReady()
    {
        readyForNext = true; //refField.currentIndex > 0;
    }

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Choose which genome reference must be used for this analysis.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }




    ScrollView
    {
        id: scrollArea
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.topMargin: 30

        Column
        {
            spacing: 5

            RowLayout
            {
                width: scrollArea.viewport.width
                spacing: 10

                Text
                {
                    height: Regovar.theme.font.size.header
                    Layout.minimumWidth: root.labelColWidth
                    text: qsTr("Reference")
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    onTextChanged: checkReady();
                }
                ComboBox
                {
                    Layout.fillWidth: true
                    id: refField
                    model: regovar.references
                    textRole: 'name'
                    currentIndex: regovar.selectedReference
                    onCurrentIndexChanged:
                    {
                        if (currentIndex != regovar.selectedReference)
                        {
                            regovar.selectedReference = currentIndex;
                            checkReady();
                        }
                    }
                    delegate: ItemDelegate
                    {
                        width: refField.width
                        height: Regovar.theme.font.boxSize.normal
                        contentItem: Text
                        {
                            text: modelData.name
                            color: enabled ? Regovar.theme.boxColor.front : Regovar.theme.frontColor.disable
                            font: refField.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }


                        highlighted: refField.highlightedIndex === index
                    }
                }
            }
        }
    }
}
