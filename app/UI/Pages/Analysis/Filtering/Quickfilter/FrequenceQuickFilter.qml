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
    title : qsTr("Allelic frequency")
    isEnabled : false
    isExpanded: false



    property bool internalUiUpdate: false


    function checkFinal()
    {
        // Mode
        var _1000g = (!_100GAll.checked && !_100GAfr.checked && !_100GAmr.checked && !_100GAsn.checked && !_100GEur.checked);
        var exac  = (!exacAll.checked && !exacAdj.checked && !exacAfr.checked && !exacAmr.checked && !exacEas.checked && !exacFin.checked && !exacNfe.checked && !exacSas.checked);
        frqAll.checked = _1000g && exac
        // TODO : send final combination to the model to update the filter
    }

    onModelChanged:
    {
        _100GAll.model = model.quickfilters.frequenceFilter._1000GAll;
        _100GAfr.model = model.quickfilters.frequenceFilter._1000GAfr;
        _100GAmr.model = model.quickfilters.frequenceFilter._1000GAmr;
        _100GAsn.model = model.quickfilters.frequenceFilter._1000GAsn;
        _100GEur.model = model.quickfilters.frequenceFilter._1000GEur;

        exacAll.model = model.quickfilters.frequenceFilter.exacAll;
        exacAfr.model = model.quickfilters.frequenceFilter.exacAfr;
        exacAmr.model = model.quickfilters.frequenceFilter.exacAmr;
        exacAdj.model = model.quickfilters.frequenceFilter.exacAdj;
        exacEas.model = model.quickfilters.frequenceFilter.exacEas;
        exacFin.model = model.quickfilters.frequenceFilter.exacFin;
        exacNfe.model = model.quickfilters.frequenceFilter.exacNfe;
        exacSas.model = model.quickfilters.frequenceFilter.exacSas;
    }

    content: ColumnLayout
    {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 30


        // All
        RowLayout
        {
            Layout.columnSpan: 5
            width: content.width
            CheckBox
            {
                id: frqAll
                anchors.left: parent.left
                anchors.leftMargin: 25
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
                            _100GAll.checked = false;
                            _100GAfr.checked = false;
                            _100GAmr.checked = false;
                            _100GAsn.checked = false;
                            _100GEur.checked = false;

                            exacAll.checked = false;
                            exacAfr.checked = false;
                            exacAmr.checked = false;
                            exacAdj.checked = false;
                            exacEas.checked = false;
                            exacFin.checked = false;
                            exacNfe.checked = false;
                            exacSas.checked = false;
                        }

                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
        }

        // 1000 G ALL
        QuickFilterFieldControl
        {
            id: _100GAll
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // 1000 G AFR
        QuickFilterFieldControl
        {
            id: _100GAfr
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // 1000 G AMR
        QuickFilterFieldControl
        {
            id: _100GAmr
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // 1000 G ASN
        QuickFilterFieldControl
        {
            id: _100GAsn
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // 1000 G EUR
        QuickFilterFieldControl
        {
            id: _100GEur
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }


        // Exac All
        QuickFilterFieldControl
        {
            id: exacAll
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // Exac AFR
        QuickFilterFieldControl
        {
            id: exacAfr
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // Exac AMR
        QuickFilterFieldControl
        {
            id: exacAmr
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // Exac Adj
        QuickFilterFieldControl
        {
            id: exacAdj
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // Exac EAS
        QuickFilterFieldControl
        {
            id: exacEas
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // Exac FIN
        QuickFilterFieldControl
        {
            id: exacFin
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // Exac NFE
        QuickFilterFieldControl
        {
            id: exacNfe
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
        // Exac SAS
        QuickFilterFieldControl
        {
            id: exacSas
            checkBox.onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        frqAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }
    }
}

