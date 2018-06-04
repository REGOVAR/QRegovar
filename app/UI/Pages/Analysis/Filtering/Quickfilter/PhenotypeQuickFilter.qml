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
    title : qsTr("Phenotype (HPO)")
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
        if (model && model.quickfilters && model.quickfilters.phenotypeFilter)
        {
            root.enabled = model.quickfilters.phenotypeFilter.isVisible();


            panelRepeater.model = model.quickfilters.phenotypeFilter.panelsList;
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
            var item = container.children[i];
            if (item && item.objectName === "QuickFilterFieldControl")
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


        // All
        RowLayout
        {
            spacing: 0
            width: content.width
            Item { height: 10; width: Regovar.theme.font.boxSize.header - 5 }
            CheckBox
            {
                id: panelAll
                Layout.fillWidth: true
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
                            if (item && item.objectName === "QuickFilterFieldControl")
                            {
                                item.checked = false;
                            }
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
        }

        RowLayout
        {
            spacing: 0
            width: content.width
            Item { height: 10; width: Regovar.theme.font.boxSize.header - 5}
            Rectangle
            {
                Layout.fillWidth: true
                height: 200
                border.width: 1
                border.color: Regovar.theme.boxColor.border
                color: Regovar.theme.boxColor.back
                visible: false

                ListView
                {
                    model: ["OMIM:15454 Disease 1", "Microcephaly"]
                    anchors.fill: parent
                    anchors.margins: 5

                    delegate: RowLayout
                    {
                        width: content.width
                        CheckBox
                        {
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

                        ButtonInline
                        {
                            iconTxt: "z"
                            text: ""
                            onClicked: regovar.getPanelInfo(modelData.id)
                        }
                    }
                }
            }
        }


        Item
        {
            id: newPanelButton
            width: content.width
            height: Regovar.theme.font.boxSize.normal
            property bool hovered: false
            RowLayout
            {
                anchors.fill: parent
                Item { height: 10; width: Regovar.theme.font.boxSize.header }
                Text
                {
                    text: "à"
                    width: Regovar.theme.font.boxSize.normal
                    font.family: Regovar.theme.icons.name
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: newPanelButton.hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.normal
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    Layout.fillWidth: true
                    text: qsTr("Add phenotypes or diseases")
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: newPanelButton.hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.normal
                    verticalAlignment: Text.AlignVCenter
                }
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

