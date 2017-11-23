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
    Component.onCompleted: readyForNext = true;
    property real labelColWidth: 100
    property int selectedRefId: -1
    onZChanged:
    {
        if (z == 0) // = button next clicked
        {
            regovar.resetnewFilteringWizard(selectedRefId);
        }
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
                    Layout.alignment: Qt.AlignTop
                    Layout.minimumWidth: root.labelColWidth
                    height: Regovar.theme.font.size.header
                    text: qsTr("Reference")
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    Component.onCompleted: root.labelColWidth = Math.max(root.labelColWidth, width)
                    onTextChanged: checkReady();
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
