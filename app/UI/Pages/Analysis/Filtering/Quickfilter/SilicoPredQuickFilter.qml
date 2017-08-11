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
    title : qsTr("In silico prediction")
    isEnabled : false
    isExpanded: false

    property bool internalUiUpdate: false


    function checkFinal()
    {
        // Mode
        predAll.checked = (!predSift.checked && !predPoly.checked && !predCadd.checked);
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
                id: predAll
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
                            predSift.checked = false;
                            predPoly.checked = false;
                            predCadd.checked = false;
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
                id: predSift
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("SIFT")
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            predAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
                ComboBox
                {
                    model: [ "Tolerated", "Damaging"] // [ "<", "<=", "==", ">=", ">", "!=" ]
                    //currentText: model.quickfilters.qualityFilter.op
                }

            }
        }
        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: predPoly
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Polyphen")
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            predAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
            ComboBox
            {
                model: [ "Benign", "Possibly Damaging", "Probably Damaging" ] // [ "<", "<=", "==", ">=", ">", "!=" ]
                //currentText: model.quickfilters.qualityFilter.op
            }
        }
        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: predCadd
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("CADD")
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            predAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
            ComboBox
            {
                model: [ "<", "≤", "=", "≥", ">", "≠" ] // [ "<", "<=", "==", ">=", ">", "!=" ]
                currentIndex: 4
            }
            TextFieldForm
            {
                Layout.fillWidth: true
                text: "10" // model.quickfilters.qualityFilter.value
            }
        }
    }
}
