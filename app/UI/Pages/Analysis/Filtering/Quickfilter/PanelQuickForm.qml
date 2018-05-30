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
    title : qsTr("Panel")
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
        if (model && model.quickfilters && model.quickfilters.panelFilter)
        {
            root.enabled = model.quickfilters.panelFilter.isVisible();


            panelRepeater.model = model.quickfilters.panelFilter.panelsList;
            panelAll.visible = panelRepeater.model.length > 1;
            if (!panelAll.visible)
            {
                panelAll.height = 0;
            }
        }
    }


    function checkFinal()
    {
        // Compute the final checked status of the "All" button
        var finalCheck = false;

        for (var i = 0; i < content.children.length; ++i)
        {
            var item = content.children[i];
            if (item.objectName == "QuickFilterFieldControl")
            {
                finalCheck = finalCheck || item.checked;
            }
        }

        internalUiUpdate = true;
        panelAll.checked = !finalCheck;
        internalUiUpdate = false;
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

            Item { height: 10; width: 30 }
            CheckBox
            {
                id: panelAll
                text: qsTr("All")
                checked: true
                onCheckedChanged:
                {
                    // Update other checkboxes
                    if (!internalUiUpdate && checked)
                    {
                        internalUiUpdate = true;
                        for (var i = 0; i < container.children.length; ++i)
                        {
                            var item = container.children[i];
                            if (item.objectName == "QuickFilterFieldControl")
                            {
                                item.checked = false;
                            }
                        }
                        internalUiUpdate = false;
                    }

                    checkFinal();
                }
            }
        }

        Repeater
        {
            id: panelRepeater

            RowLayout
            {
                width: content.width

                CheckBox
                {
                    id: gItem
                    objectName: "QuickFilterFieldControl"
                    width: container.width
                    text: modelData.label
                    checked: modelData.isActive
                    onCheckedChanged:
                    {
                        modelData.isActive = checked
                        if (!internalUiUpdate)
                        {
                            // Update other checkboxes
                            internalUiUpdate = true;
                            if (checked)
                            {
                                panelAll.checked = false;
                            }
                            checkFinal();
                            internalUiUpdate = false;
                        }
                    }
                }
            }
        }

        ButtonInline
        {
            iconTxt: "à"
            text: qsTr("Add panel")
        }
    }
}
