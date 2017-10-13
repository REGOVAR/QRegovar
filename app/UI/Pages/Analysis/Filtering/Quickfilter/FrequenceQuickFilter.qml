import QtQuick 2.7
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
    title : qsTr("Population frequency")
    isExpanded: false





    property bool internalUiUpdate: false
    property real labelWidth: 50
    onLabelWidthChanged: console.log("labelWidth = " + labelWidth)


    function checkFinal()
    {
//        // Mode
//        var _1000g = (!_100GAll.checked && !_100GAfr.checked && !_100GAmr.checked && !_100GAsn.checked && !_100GEur.checked);
//        var exac  = (!exacAll.checked && !exacAdj.checked && !exacAfr.checked && !exacAmr.checked && !exacEas.checked && !exacFin.checked && !exacNfe.checked && !exacSas.checked);
//        frqAll.checked = _1000g && exac
    }

    onModelChanged:
    {
        //        _100GAll.model = model.quickfilters.frequenceFilter._1000GAll;
        //        _100GAfr.model = model.quickfilters.frequenceFilter._1000GAfr;
        //        _100GAmr.model = model.quickfilters.frequenceFilter._1000GAmr;
        //        _100GAsn.model = model.quickfilters.frequenceFilter._1000GAsn;
        //        _100GEur.model = model.quickfilters.frequenceFilter._1000GEur;

        //        exacAll.model = model.quickfilters.frequenceFilter.exacAll;
        //        exacAfr.model = model.quickfilters.frequenceFilter.exacAfr;
        //        exacAmr.model = model.quickfilters.frequenceFilter.exacAmr;
        //        exacAdj.model = model.quickfilters.frequenceFilter.exacAdj;
        //        exacEas.model = model.quickfilters.frequenceFilter.exacEas;
        //        exacFin.model = model.quickfilters.frequenceFilter.exacFin;
        //        exacNfe.model = model.quickfilters.frequenceFilter.exacNfe;
        //        exacSas.model = model.quickfilters.frequenceFilter.exacSas;

        if (model)
        {
            root.enabled = model.quickfilters.frequenceFilter.isVisible();
            gRepeater.model = model.quickfilters.frequenceFilter._1000G;
            exacRepeater.model = model.quickfilters.frequenceFilter.exac;
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
                if (!internalUiUpdate)
                {
                    // Update other checkboxes
                    internalUiUpdate = true;
                    if (checked)
                    {
//                        _100GAll.checked = false;
//                        _100GAfr.checked = false;
//                        _100GAmr.checked = false;
//                        _100GAsn.checked = false;
//                        _100GEur.checked = false;

//                        exacAll.checked = false;
//                        exacAfr.checked = false;
//                        exacAmr.checked = false;
//                        exacAdj.checked = false;
//                        exacEas.checked = false;
//                        exacFin.checked = false;
//                        exacNfe.checked = false;
//                        exacSas.checked = false;
                    }

                    checkFinal();
                    internalUiUpdate = false;
                }
            }
        }


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
                width: content.width
                model: modelData
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
                width: content.width
                model: modelData
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

