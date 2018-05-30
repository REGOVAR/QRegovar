import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"


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
    Component.onDestruction:
    {
        model.quickfilters.filterChanged.disconnect(updateViewFromModel);
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

            Item { height: 10; width: 25 }
            CheckBox
            {
                id: typAll
                Layout.fillWidth: true
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
            Item { height: 10; width: 25 }
            CheckBox
            {
                id: typMis
                Layout.fillWidth: true
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
            Item { height: 10; width: 25 }
            CheckBox
            {
                id: typStp
                Layout.fillWidth: true
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
            Item { height: 10; width: 25 }
            CheckBox
            {
                id: typSpl
                Layout.fillWidth: true
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
            Item { height: 10; width: 25 }
            CheckBox
            {
                id: typInd
                Layout.fillWidth: true
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
            Item { height: 10; width: 25 }
            CheckBox
            {
                id: typSyn
                Layout.fillWidth: true
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
