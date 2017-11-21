import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"
import "../Quickfilter"


QuickFilterBox
{
    id: root
    title : qsTr("Export")
    isExpanded: false

    property bool internalUiUpdate: false

    onModelChanged:
    {
        root.enabled = model.quickfilters.transmissionFilter.isVisible();
    }

    content: Column
    {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right


        Text
        {
            anchors.left: parent.left
            anchors.leftMargin: 5

            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.dark
            text: qsTr("Mode")
        }



        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: modeAll
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
                            modeDom.checked = false;
                            modeRec.checked = false;
                            modeHtz.checked = false;
                            modeHtzComp.checked = false;
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
                id: modeDom
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Dominant")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            modeAll.checked = false;
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
                id: modeRec
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Recessive")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            modeAll.checked = false;
                            modeHtz.checked = true;
                            modeHtzComp.checked = true;
                        }
                        else
                        {
                            modeHtz.checked = false;
                            modeHtzComp.checked = false;
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
                id: modeHtz
                anchors.left: parent.left
                anchors.leftMargin: 50
                text: qsTr("Homozygous")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            modeAll.checked = false;
                            modeRec.checked = modeHtz.checked && modeHtzComp.checked;
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
                id: modeHtzComp
                anchors.left: parent.left
                anchors.leftMargin: 50
                text: qsTr("Compound heterozygous")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            modeAll.checked = false;
                            modeRec.checked = modeHtz.checked && modeHtzComp.checked;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
        }


        Text
        {
            anchors.left: parent.left
            anchors.leftMargin: 5

            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.dark
            text: qsTr("Segregation")
        }
        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: segAll
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
                            segDen.checked = false;
                            segInh.checked = false;
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
                id: segDen
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("De novo")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            segAll.checked = false;
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
                id: segInh
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Inherited")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            segAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
        }


        Text
        {
            anchors.left: parent.left
            anchors.leftMargin: 5

            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.dark
            text: qsTr("Localisation")
        }
        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: locAll
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
                            locAut.checked = false;
                            locXlk.checked = false;
                            locMit.checked = false;
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
                id: locAut
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Autosomal")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            locAll.checked = false;
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
                id: locXlk
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("X-linked")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            locAll.checked = false;
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
                id: locMit
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Mitochondrial")
                checked: false
                onCheckedChanged:
                {
                    if (!internalUiUpdate)
                    {
                        // Update other checkboxes
                        internalUiUpdate = true;
                        if (checked)
                        {
                            locAll.checked = false;
                        }
                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
        }
    }
}
