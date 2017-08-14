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
    title : qsTr("Frequence")
    isEnabled : false
    isExpanded: false



    property bool internalUiUpdate: false


    function checkFinal()
    {
        // Mode
        var _1000g = (!_100GAll.checked && !_100GAfr.checked && !_100GAmr.checked && !_100GAsn.checked && !_100GEur.checked);
        var exac  = (!exacAll.checked && !exacAdj.checked && !exacAfr.checked && !exacAmr.checked && !exacEas.checked && !exacFin.checked && !exacNfe.checked && !exacSas.checked);
        frqAll.checked = _1000g && exac
        // TODO : send final combination to the model to update the filter
    }

    content: GridLayout
    {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 30

        columns: 3
        rows: 14


        // All
        RowLayout
        {
            Layout.columnSpan: 3
            width: content.width
            CheckBox
            {
                id: frqAll
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
                            posExo.checked = false;
                            posIntro.checked = false;
                            posUtr.checked = false;
                            posInter.checked = false;
                        }

                        checkFinal();
                        internalUiUpdate = false;
                    }
                }
            }
        }

        // 1000 G ALL
        CheckBox
        {
            id: _100GAll
            width: 150
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("1000G All")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // 1000 G AFR
        CheckBox
        {
            id: _100GAfr
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("1000G AFR")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // 1000 G AMR
        CheckBox
        {
            id: _100GAmr
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("1000G AMR")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // 1000 G ASN
        CheckBox
        {
            id: _100GAsn
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("1000G ASN")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // 1000 G EUR
        CheckBox
        {
            id: _100GEur
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("1000G EUR")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // Exac All
        CheckBox
        {
            id: exacAll
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Exac All")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // Exac AFR
        CheckBox
        {
            id: exacAfr
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Exac AFR")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // Exac AMR
        CheckBox
        {
            id: exacAmr
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Exac AMR")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // Exac Adj
        CheckBox
        {
            id: exacAdj
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Exac ADJ")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // Exac EAS
        CheckBox
        {
            id: exacEas
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Exac EAS")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // Exac FIN
        CheckBox
        {
            id: exacFin
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Exac FIN")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // Exac NFE
        CheckBox
        {
            id: exacNfe
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Exac NFE")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // Exac SAS
        CheckBox
        {
            id: exacSas
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Exac SAS")
            checked: false
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
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 1
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }
    }
}

