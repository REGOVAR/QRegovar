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
    title : qsTr("Panel")
    isExpanded: false

    property bool internalUiUpdate: false


    onModelChanged:
    {
        //root.enabled = model.quickfilters.panelFilter.isVisible();
    }

    function checkFinal()
    {
//        // Mode
//        modeRec.checked = (modeHtz.checked || modeHtzComp.checked);
//        modeAll.checked = (!modeDom.checked && !modeRec.checked && !modeHtz.checked && !modeHtzComp.checked);
//        // Segregation
//        segAll.checked = (!segDen.checked && !segInh.checked);
//        // Localisation
//        locAll.checked = (!locAut.checked && !locMit.checked && !locXlk.checked);

//        // send final combination to the model to update the filter
//        var tm = model.quickfilters.transmissionFilter;
//        tm.setFilter("dom", modeDom.checked);
//        tm.setFilter("rec_hom", modeRec.checked);
//        tm.setFilter("rec_htzcomp", modeHtzComp.checked);
//        tm.setFilter("denovo", segDen.checked);
//        tm.setFilter("inherited", segInh.checked);
//        tm.setFilter("aut", locAut.checked);
//        tm.setFilter("xlk", locXlk.checked);
//        tm.setFilter("mit", locMit.checked);
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
                id: modeAll
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("All")
                checked: true
                onCheckedChanged:
                {
//                    if (!internalUiUpdate)
//                    {
//                        // Update other checkboxes
//                        internalUiUpdate = true;
//                        if (checked)
//                        {
//                            modeDom.checked = false;
//                            modeRec.checked = false;
//                            modeHtz.checked = false;
//                            modeHtzComp.checked = false;
//                        }

//                        checkFinal();
//                        internalUiUpdate = false;
//                    }
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
                text: qsTr("Retina")
                checked: false
                onCheckedChanged:
                {
//                    if (!internalUiUpdate)
//                    {
//                        // Update other checkboxes
//                        internalUiUpdate = true;
//                        if (checked)
//                        {
//                            modeAll.checked = false;
//                        }
//                        checkFinal();
//                        internalUiUpdate = false;
//                    }
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
                text: qsTr("HUGODIMS")
                checked: false
                onCheckedChanged:
                {
//                    if (!internalUiUpdate)
//                    {
//                        // Update other checkboxes
//                        internalUiUpdate = true;
//                        if (checked)
//                        {
//                            modeAll.checked = false;
//                            modeHtz.checked = true;
//                            modeHtzComp.checked = true;
//                        }
//                        else
//                        {
//                            modeHtz.checked = false;
//                            modeHtzComp.checked = false;
//                        }
//                        checkFinal();
//                        internalUiUpdate = false;
//                    }
                }
            }
        }
        RowLayout
        {
            width: content.width
            CheckBox
            {
                id: segAll
                anchors.left: parent.left
                anchors.leftMargin: 30
                text: qsTr("Strasbourg")
                checked: false
                onCheckedChanged:
                {
//                    if (!internalUiUpdate)
//                    {
//                        // Update other checkboxes
//                        internalUiUpdate = true;
//                        if (checked)
//                        {
//                            segDen.checked = false;
//                            segInh.checked = false;
//                        }
//                        checkFinal();
//                        internalUiUpdate = false;
//                    }
                }
            }
        }
    }
}
