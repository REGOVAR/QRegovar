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
    title : qsTr("Region")
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
        if (model && model.quickfilters && model.quickfilters.positionFilter)
        {
            root.enabled = model.quickfilters.positionFilter.isVisible();
        }
    }

    function checkFinal()
    {
        // Mode
        posAll.checked = (!posExo.checked && !posIntro.checked && !posUtr.checked && !posInter.checked && !posSpl.checked);

        // send final combination to the model to update the filter
        var pf = model.quickfilters.positionFilter;
        pf.exonic.isActive = posExo.checked;
        pf.intronic.isActive = posIntro.checked;
        pf.utr.isActive = posUtr.checked;
        pf.intergenic.isActive = posInter.checked;
        pf.splice.isActive = posSpl.checked;
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
                id: posAll
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
                            posExo.checked = false;
                            posIntro.checked = false;
                            posUtr.checked = false;
                            posInter.checked = false;
                            posSpl.checked = false;
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
                id: posExo
                Layout.fillWidth: true
                text: qsTr("Exonic")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posAll.checked = false;
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
                id: posIntro
                Layout.fillWidth: true
                text: qsTr("Intronic")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posAll.checked = false;
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
                id: posUtr
                Layout.fillWidth: true
                text: qsTr("UTR")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posAll.checked = false;
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
                id: posInter
                Layout.fillWidth: true
                text: qsTr("Intergenic")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posAll.checked = false;
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
                id: posSpl
                Layout.fillWidth: true
                text: qsTr("Splice")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            posAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
        }
    }
}
