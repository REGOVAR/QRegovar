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
    id: root
    title : qsTr("Position")
    isEnabled : false
    isExpanded: false

    property bool internalUiUpdate: false


    function checkFinal()
    {
        // Mode
        posAll.checked = (!posExo.checked && !posIntro.checked && !posUtr.checked && !posInter.checked);
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
                id: posAll
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
                            posExo.checked = false;
                            posIntro.checked = false;
                            posUtr.checked = false;
                            posInter.checked = false;
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
                id: posExo
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Exonic")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posAll.checked = false;
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
                id: posIntro
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Intronic")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posAll.checked = false;
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
                id: posUtr
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("UTR")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posAll.checked = false;
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
                id: posInter
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Intergenenic")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posUtr.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }

            }
        }
    }
}