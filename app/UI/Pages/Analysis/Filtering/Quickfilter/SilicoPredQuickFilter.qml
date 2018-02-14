import QtQuick 2.9
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
        predAll.checked = (!predSift.checked && !predPoly.checked && !predCadd.checked && !predImpact.checked);
        // send final combination to the model to update the filter
        var pf = model.quickfilters.inSilicoPredFilter;
        pf.sift.isActive = predSift.checked;
        pf.polyphen.isActive = predPoly.checked;
        pf.cadd.isActive = predCadd.checked;
        pf.impact.isActive = predImpact.checked;
    }

    onModelChanged:
    {
        if (model)
        {
            model.quickfilters.filterChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }

    function updateViewFromModel()
    {
        if (model && model.quickfilters && model.quickfilters.inSilicoPredFilter)
        {
            var m = model.quickfilters.inSilicoPredFilter;
            predSift.enabled = m.sift.isDisplayed;
            predPoly.enabled = m.polyphen.isDisplayed;
            predCadd.enabled = m.cadd.isDisplayed;
            predImpact.enabled = m.impact.isDisplayed;

            root.enabled = model.quickfilters.inSilicoPredFilter.isVisible();
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
            rows: 5
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
                model: ["tolerated", "deleterious"]
                onCurrentTextChanged:
                {
                    if (root.model)
                    {
                        predSift.checked = true;
                        root.model.quickfilters.inSilicoPredFilter.sift.value = currentText;
                    }
                }
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
                model: ["benign", "possibly_damaging", "probably_damaging", "damaging", "unknown"]
                onCurrentTextChanged:
                {
                    if (root.model)
                    {
                        predPoly.checked = true;
                        root.model.quickfilters.inSilicoPredFilter.polyphen.value = currentText;
                    }
                }
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
                currentIndex: 3
                model: [ "<", "≤", "=", "≥", ">", "≠" ]
                onCurrentTextChanged:
                {
                    if (root.model)
                    {
                        predCadd.checked = true;
                        root.model.quickfilters.inSilicoPredFilter.cadd.op = currentText;
                    }
                }
            }
            TextFieldForm
            {
                id: caddValue
                enabled: predCadd.enabled
                Layout.fillWidth: true
                onTextEdited: predCadd.checked = true
                onTextChanged:
                {
                    predCadd.checked = true;
                    root.model.quickfilters.inSilicoPredFilter.cadd.value = text;
                }
                text: "10"
            }


            CheckBox
            {
                id: predImpact
                text: qsTr("Impact")
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
                enabled: predImpact.enabled
                Layout.columnSpan: 2
                Layout.fillWidth: true
                model: ["modifier", "low", "moderate", "high"]
                onCurrentTextChanged:
                {
                    if (root.model)
                    {
                        predImpact.checked = true;
                        root.model.quickfilters.inSilicoPredFilter.impact.value = currentText;
                    }
                }
            }
        }

        // FIXME : Qt BUG, margin value not take in account when panel resized by the Splitter
        Rectangle { width:20; height: 10; color: "transparent"; }
    }
}
