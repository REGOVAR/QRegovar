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


        for (var i = 0; i < container.children.length; ++i)
        {
            var row = container.children[i];
            for (var j = 0; j < row.children.length; ++j)
            {
                var item = row.children[i];
                if (item.objectName === "QuickFilterFieldControl")
                {
                     finalCheck = finalCheck || item.checked;
                }
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
            CheckBox
            {
                id: panelAll
                anchors.left: parent.left
                anchors.leftMargin: 30
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
                            var row = container.children[i];
                            for (var j = 0; j < row.children.length; ++j)
                            {
                                var item = row.children[i];
                                if (item.objectName === "QuickFilterFieldControl")
                                {
                                    item.checked = false;
                                }
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
                Item { height: 10; width: 25 }
                CheckBox
                {
                    id: gItem
                    Layout.fillWidth: true
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

        RowLayout
        {
            width: content.width
            property bool hovered: false

            Item { height: 10; width: 25 }
            Text
            {
                Layout.fillWidth: true
                text: "à"
                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.normal
                color: hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.dark
                verticalAlignment: Text.AlignVCenter
            }
            Text
            {
                Layout.fillWidth: true
                text: qsTr("Add panel")
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.normal
                color: hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.dark
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea
            {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: console.log("Not yet implemented")
            }
        }
    }
}
