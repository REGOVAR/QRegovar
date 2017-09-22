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
    title : qsTr("In silico prediction")
    isExpanded: false

    property bool internalUiUpdate: false


    function checkFinal()
    {
//        // Mode
//        predAll.checked = (!predSift.checked && !predPoly.checked && !predCadd.checked);
//        // TODO : send final combination to the model to update the filter
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
                anchors.leftMargin: 25
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
            spacing: 10

            CheckBox
            {
                id: predSift
                anchors.left: parent.left
                anchors.leftMargin: 25
                text: qsTr("SIFT")
                onCheckedChanged:
                {
//                    if (!internalUiUpdate)
//                    {
//                        // Update other checkboxes
//                        internalUiUpdate = true;
//                        if (checked)
//                        {
//                            predAll.checked = false;
//                        }
//                        checkFinal();
//                        internalUiUpdate = false;
//                    }
                }
            }

            // FIXME : Weird bug, need to add free space otherwise ComboBox is hover the CheckBox
            Rectangle{ height: root.height; width: 10; color: "transparent"; }

            ComboBox
            {
                Layout.fillWidth: true
                model: [ "Tolerated", "Damaging"] // [ "<", "<=", "==", ">=", ">", "!=" ]
                //currentText: model.quickfilters.qualityFilter.op
            }

            // FIXME : Qt BUG, margin value not take in account when control resize by the Splitter
            Rectangle{ height: root.height; width: 20; color: "transparent"; } // add 10+20px to the right (free space for scrollbar)
        }
        RowLayout
        {
            width: content.width
            spacing: 10
            CheckBox
            {
                id: predPoly
                anchors.left: parent.left
                anchors.leftMargin: 25
                text: qsTr("Polyphen")
                onCheckedChanged:
                {
//                    if (!internalUiUpdate)
//                    {
//                        // Update other checkboxes
//                        internalUiUpdate = true;
//                        if (checked)
//                        {
//                            predAll.checked = false;
//                        }
//                        checkFinal();
//                        internalUiUpdate = false;
//                    }
                }
            }

            // FIXME : Weird bug, need to add free space otherwise ComboBox is hover the CheckBox
            Rectangle{ height: root.height; width: 10; color: "transparent"; }

            ComboBox
            {
                Layout.fillWidth: true
                model: [ "Benign", "Possibly Damaging", "Probably Damaging" ] // [ "<", "<=", "==", ">=", ">", "!=" ]
                //currentText: model.quickfilters.qualityFilter.op
            }

            // FIXME : Qt BUG, margin value not take in account when control resize by the Splitter
            Rectangle{ height: root.height; width: 20; color: "transparent"; } // add 10+20px to the right (free space for scrollbar)
        }

        RowLayout
        {
            width: content.width
            spacing: 10


            property bool initializing: false
            property alias checkBox: fieldCheck
            property alias checked: fieldCheck.checked


            CheckBox
            {
                id: fieldCheck
                anchors.left: parent.left
                anchors.leftMargin: 25
                width: 150
                text: "CADD"
            }
            Binding { target: model; property: "isActive"; value: fieldCheck.checked; }


            // FIXME : Weird bug, need to add free space otherwise ComboBox is hover the CheckBox
            Rectangle{ height: root.height; width: 10; color: "transparent"; }


            ComboBox
            {
                id: fieldOperator
                model: [ "<", "≤", "=", "≥", ">", "≠" ]
                currentIndex: 3
                onCurrentTextChanged:
                {
                    if (root.model != null)
                    {
                        root.model.op = currentText;
                        if (!initializing) fieldCheck.checked = true;
                    }
                }

            }

            TextFieldForm
            {
                id: fieldValue
                Layout.fillWidth: true

                //onTextEdited: fieldCheck.checked = true
                onTextChanged: fieldCheck.checked = true
                text: "10"
            }
            Binding { target: model; property: "value"; value: fieldValue.text; }


            // FIXME : Qt BUG, margin value not take in account when control resize by the Splitter
            Rectangle{ height: root.height; width: 20; color: "transparent"; } // add 10+20px to the right (free space for scrollbar)
        }
    }
}
