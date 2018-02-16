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
    id: root
    title : qsTr("Type")
    isExpanded: false
    property bool internalUiUpdate: false

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
        if (model && model.quickfilters && model.quickfilters.typeFilter)
        {
            root.enabled = model.quickfilters.typeFilter.isVisible();
        }
    }

    function checkFinal()
    {
        // Mode
        typAll.checked = (!typMis.checked && !typStp.checked && !typSpl.checked && !typInd.checked && !typSyn.checked);
        // send final combination to the model to update the filter
        var tf = model.quickfilters.typeFilter;
        tf.missense.isActive = typMis.checked;
        tf.nonsense.isActive = typStp.checked;
        tf.splicing.isActive = typSpl.checked;
        tf.indel.isActive = typInd.checked;
        tf.synonymous.isActive = typSyn.checked;
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
                            typInd.checked = false;
                            typSyn.checked = false;
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
                text: qsTr("Nonsense")
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
        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: typInd
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Indel")
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
                id: typSyn
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Synonymous")
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
