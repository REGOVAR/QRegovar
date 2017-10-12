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
    isExpanded: false
    property bool internalUiUpdate: false


    function checkFinal()
    {
        // Mode
        predAll.checked = (!predSift.checked && !predPoly.checked && !predCadd.checked);
        // send final combination to the model to update the filter
        var pf = model.quickfilters.inSilicoPredFilter;
        pf.sift.isActive = predSift.checked;
        pf.polyphen.isActive = predPoly.checked;
        pf.cadd.isActive = predCadd.checked;
    }

    onModelChanged:
    {
        if (model)
        {
            var m = model.quickfilters.inSilicoPredFilter;
            predSift.enabled = m.sift.isDisplayed;
            predPoly.enabled = m.polyphen.isDisplayed;
            predCadd.enabled = m.cadd.isDisplayed;
        }
    }

    content: Row
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        // FIXME : Qt BUG, margin value not take in account when panel resized by the Splitter
        Rectangle { width:30; height: 10; color: "transparent"; }

        GridLayout
        {
            id: content
            width: parent.width-60
            rows: 4
            columns: 3
            columnSpacing: 10



            CheckBox
            {
                Layout.columnSpan: 3
                id: predAll
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


            CheckBox
            {
                id: predSift
                text: qsTr("SIFT")
                checked: false
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
                enabled: predSift.enabled
                Layout.columnSpan: 2
                Layout.fillWidth: true
                model: [ qsTr("Tolerated"), qsTr("Deleterious")]
                onCurrentTextChanged: if (root.model) predSift.checked = true
            }


            CheckBox
            {
                id: predPoly
                text: qsTr("Polyphen")
                checked: false
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
                enabled: predPoly.enabled
                Layout.columnSpan: 2
                Layout.fillWidth: true
                model: [ "Benign", "Possibly Damaging", "Probably Damaging", "Damaging", "Unknow" ]
                onCurrentTextChanged: if (root.model) predPoly.checked = true
            }


            CheckBox
            {
                id: predCadd
                text: "CADD"
                checked: false
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
                id: caddOperator
                enabled: predCadd.enabled
                model: [ "<", "≤", "=", "≥", ">", "≠" ]
                currentIndex: 3
                onCurrentTextChanged: if (root.model) predCadd.checked = true
            }
            TextFieldForm
            {
                id: caddValue
                enabled: predCadd.enabled
                Layout.fillWidth: true
                onTextEdited: predCadd.checked = true
                onTextChanged:predCadd.checked = true
                text: "10"
            }
        }
        // FIXME : Qt BUG, margin value not take in account when panel resized by the Splitter
        Rectangle { width:20; height: 10; color: "transparent"; }
    }
}
