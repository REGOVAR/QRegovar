import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


QuickFilterBox
{
    title : qsTr("Type")
    isEnabled : false
    isExpanded: false
    property bool internalUiUpdate: false


    function checkFinal()
    {
        // Mode
        typAll.checked = (!typMis.checked && !typStp.checked && !typSpl.checked);
        // TODO : send final combination to the model to update the filter
    }

    content: Column
    {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right



        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: typAll
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("All")
                checked: true
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            typMis.checked = false;
                            typStp.checked = false;
                            typSpl.checked = false;
                        }

                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
        }

        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: typMis
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Missense")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            typAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }

            }
        }
        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: typStp
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Nonsense (Stop)")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            typAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }

            }
        }
        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: typSpl
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Splicing")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            typAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }

            }
        }
    }
}
