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
    title : qsTr("Quality")
    isExpanded: false
    property bool internalUiUpdate: false
    property real labelWidth: 50
    property real headLabelWidth: 50

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
        if (model && model.quickfilters && model.quickfilters.qualityFilter)
        {
            root.enabled = model.quickfilters.qualityFilter.isVisible();
            depth.model = model.quickfilters.qualityFilter.depth;
            vaf.model = model.quickfilters.qualityFilter.vaf;
        }
    }


    function reset()
    {
        // force the call of the checkUpdate true for "All"
        qlAll.checked = false;
        qlAll.checked = true;
    }

    function checkFinal()
    {
        // Mode
        qlAll.checked = (!depth.checked && !vaf.checked);
        // send final combination to the model to update the filter
        var qf = model.quickfilters.qualityFilter;
        qf.depth.isActive = depth.checked;
        qf.vaf.isActive = vaf.checked;
    }

    content: Column
    {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right


        // All
        CheckBox
        {
            id: qlAll
            anchors.left: parent.left
            anchors.leftMargin: 25
            width: content.width
            text: qsTr("All")
            checked: true
            onCheckedChanged:
            {
                // Update other checkboxes
                if (!internalUiUpdate && checked)
                {
                    internalUiUpdate = true;
                    depth.checked = false;
                    vaf.checked = false;
                    internalUiUpdate = false;
                }

                checkFinal();
            }
        }

        QuickFilterFieldControl
        {
            id: depth
            width: content.width
            onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        qlAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
            onLabelWidthChanged:
            {
                root.headLabelWidth = Math.max(labelWidth, root.headLabelWidth);
                labelWidth = root.headLabelWidth;
            }
            Binding { target: depth; property: "labelWidth"; value: root.headLabelWidth; }
        }
        QuickFilterFieldControl
        {
            id: vaf
            width: content.width
            onCheckedChanged:
            {
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
                        qlAll.checked = false;
                    }
                    checkFinal();
                    internalUiUpdate = false;
                }
            }
            onLabelWidthChanged:
            {
                root.headLabelWidth = Math.max(labelWidth, root.headLabelWidth);
                labelWidth = root.headLabelWidth;
            }
            Binding { target: vaf; property: "labelWidth"; value: root.headLabelWidth; }
        }
    }
}
