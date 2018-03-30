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
    title : qsTr("Population frequency")
    isExpanded: false

    function reset()
    {
        // force the call of the checkUpdate true for "All"
        frqAll.checked = false;
        frqAll.checked = true;
    }


    property bool internalUiUpdate: false
    property real labelWidth: 50
    property real headLabelWidth: 50

    property bool detailsExpanded: false


    function checkFinal()
    {
        // Compute the final checked status of the "All" button
        var finalCheck = gAll.checked;
        finalCheck = finalCheck || exacAll.checked;

        for (var i = 0; i < container.children.length; ++i)
        {
            var item = container.children[i];
            if (item.objectName == "QuickFilterFieldControl")
            {
                finalCheck = finalCheck || item.checked;
            }
        }

        internalUiUpdate = true;
        frqAll.checked = !finalCheck;
        internalUiUpdate = false;
    }


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
        if (model && model.quickfilters && model.quickfilters.frequenceFilter)
        {
            root.enabled = model.quickfilters.frequenceFilter.isVisible();
            gAll.model =  model.quickfilters.frequenceFilter._1000GAll;
            exacAll.model = model.quickfilters.frequenceFilter.exacAll;

            gRepeater.model = model.quickfilters.frequenceFilter._1000G;
            exacRepeater.model = model.quickfilters.frequenceFilter.exac;

            frqAll.checked = true;
        }
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
            id: frqAll
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
                    gAll.checked = false;
                    exacAll.checked = false;
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

        QuickFilterFieldControl
        {
            id: gAll
            width: content.width
            onCheckedChanged:
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
            onLabelWidthChanged:
            {
                root.headLabelWidth = Math.max(labelWidth, root.headLabelWidth);
                labelWidth = root.headLabelWidth;
            }
            Binding { target: gAll; property: "labelWidth"; value: root.headLabelWidth; }
        }
        QuickFilterFieldControl
        {
            id: exacAll
            width: content.width
            onCheckedChanged:
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
            onLabelWidthChanged:
            {
                root.headLabelWidth = Math.max(labelWidth, root.headLabelWidth);
                labelWidth = root.headLabelWidth;
            }
            Binding { target: exacAll; property: "labelWidth"; value: root.headLabelWidth; }
        }


        Rectangle
        {
            width: content.width
            height: Regovar.theme.font.boxSize.normal
            color: "transparent"

            Text
            {
                id: collapseIcon
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 5
                width: Regovar.theme.font.boxSize.normal
                height: Regovar.theme.font.boxSize.normal
                text: "{"
                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.normal
                color: root.enabled ? Regovar.theme.primaryColor.back.dark : Regovar.theme.frontColor.disable
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                rotation: detailsExpanded ? 90 : 0
            }

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 25
                text: qsTr("More popuplations frequencies...")
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.normal
                color: root.enabled ? Regovar.theme.primaryColor.back.dark : Regovar.theme.frontColor.disable
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea
            {
                enabled: root.enabled
                anchors.fill: parent
                cursorShape: "PointingHandCursor"
                onClicked:
                {
                    detailsExpanded = !detailsExpanded
                }
            }
        }

        Column
        {
            id: container
            width: content.width
            visible: root.enabled && root.detailsExpanded

            // 1000 G
            Text
            {
                anchors.left: parent.left
                anchors.leftMargin: 5

                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.dark
                text: qsTr("1000 G")
            }
            Repeater
            {
                id: gRepeater

                QuickFilterFieldControl
                {
                    id: gItem
                    objectName: "QuickFilterFieldControl"
                    width: container.width
                    model: modelData
                    indentation: 25
                    onCheckedChanged:
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
                    onLabelWidthChanged:
                    {
                        root.labelWidth = Math.max(labelWidth, root.labelWidth);
                        labelWidth = root.labelWidth;
                    }
                    Binding { target: gItem; property: "labelWidth"; value: root.labelWidth; }
                }
            }



            // Exac
            Text
            {
                anchors.left: parent.left
                anchors.leftMargin: 5

                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.dark
                text: qsTr("Exac")
            }
            Repeater
            {
                id: exacRepeater

                QuickFilterFieldControl
                {
                    id: exacItem
                    objectName: "QuickFilterFieldControl"
                    width: container.width
                    model: modelData
                    indentation: 25
                    onCheckedChanged:
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
                    onLabelWidthChanged:
                    {
                        root.labelWidth = Math.max(labelWidth, root.labelWidth);
                        labelWidth = root.labelWidth;
                    }
                    Binding { target: exacItem; property: "labelWidth"; value: root.labelWidth; }
                }
            }
        }
    }
}

