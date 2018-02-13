import QtQuick 2.9
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
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("Choose which genome reference must be used for this analysis.")
    }

    ScrollView
    {
        id: scrollArea
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : parent.top
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? 10 : 0
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom

        Column
        {
            spacing: 5

            RowLayout
            {
                width: scrollArea.viewport.width
                spacing: 10

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    Layout.minimumWidth: root.labelColWidth
                    height: Regovar.theme.font.size.helpInfoBox
                    text: qsTr("Reference")
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                }

                Column
                {
                    Layout.fillWidth: true
                    id: refField

                    ExclusiveGroup
                    {
                        id: referenceGroup
                        onCurrentChanged: selectedRefId = current.objectName
                    }

                    Repeater
                    {
                        model: regovar.references

                        RadioButton
                        {
                            text: modelData.name
                            exclusiveGroup: referenceGroup
                            objectName: modelData.id
                            checked: modelData.id === regovar.samplesManager.referencialId
                        }
                    }
                }
            }
        }
    }
}
