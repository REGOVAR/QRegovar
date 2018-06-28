import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"


GenericScreen
{
    id: root

    readyForNext: true
    Component.onCompleted: readyForNext = true;
    property real labelColWidth: 100
    property int selectedRefId: regovar.analysesManager.newFiltering.refId
    onZChanged:
    {
        if (z == 0) // = button next clicked
        {
            regovar.analysesManager.resetNewFiltering(selectedRefId);
        }
    }


    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("Choose which genome reference must be used for this analysis.")
    }

    Item
    {
        id: scrollArea
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : parent.top
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? 10 : 0
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom

        Column
        {
            anchors.centerIn: parent
            width: 200
            spacing: 5

            Repeater
            {
                model: regovar.references

                Rectangle
                {
                    id: itemRoot
                    height: Regovar.theme.font.boxSize.header
                    width: 200
                    property bool hovered: false
                    border.width: 1
                    border.color: Regovar.theme.boxColor.border
                    color: hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.back
                    radius: 2


                        Text
                        {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            width: Regovar.theme.font.boxSize.header
                            text: root.selectedRefId === modelData.id ? "n" : " "
                            color: hovered ? Regovar.theme.secondaryColor.front.normal : Regovar.theme.primaryColor.back.normal
                            font.pixelSize: Regovar.theme.font.size.header
                            font.family: Regovar.theme.icons.name
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Text
                        {
                            anchors.fill: parent
                            text: modelData.name
                            color: hovered ? Regovar.theme.secondaryColor.front.normal : Regovar.theme.primaryColor.back.normal
                            font.pixelSize: Regovar.theme.font.size.header
                            font.family: Regovar.theme.font.family
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: selectedRefId = modelData.id;
                        hoverEnabled: true
                        onEntered: itemRoot.hovered = true
                        onExited: itemRoot.hovered = false
                        // modelData.id === regovar.samplesManager.referencialId
                    }
                }
            }
        }
    }
}
