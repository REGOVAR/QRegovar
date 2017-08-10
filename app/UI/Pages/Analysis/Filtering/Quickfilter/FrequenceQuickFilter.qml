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



    property bool is1000gAllAvailable: true
    property bool is1000gAfrAvailable: true
    property bool is1000gAmrAvailable: true
    property bool is1000gAsnAvailable: true
    property bool is1000gEurAvailable: true

    property bool isExacAllAvailable: true
    property bool isExacAfrAvailable: true
    property bool isExacAmrAvailable: true
    property bool isExacAdjAvailable: true
    property bool isExacEasAvailable: true
    property bool isExacFinAvailable: true
    property bool isExacNfeAvailable: true
    property bool isExacSasAvailable: true


    content: GridLayout
    {
        columns: 3
        anchors.fill: parent

        // 1000 G ALL
        CheckBox
        {
            visible: is1000gAllAvailable
            text: qsTr("1000G All")
            onCheckedChanged: model.quickfilters.frequenceFilter.setFilter(2, checked)
        }
        ComboBox
        {
            visible: is1000gAllAvailable
            width: 30
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 2
        }
        TextField
        {
            visible: is1000gAllAvailable
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: "0.01"
        }

        // 1000 G AFR
        CheckBox
        {
            checked:false
            visible: is1000gAfrAvailable
            text: qsTr("1000G Africa")
            onCheckedChanged: model.quickfilters.frequenceFilter.setFilter(3, checked)
        }
        ComboBox
        {
            visible: is1000gAfrAvailable
            width: 30
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
            currentIndex: 2
        }
        TextField
        {
            visible: is1000gAfrAvailable
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        // 1000 G AMR
        CheckBox
        {
            visible: is1000gAmrAvailable
            text: qsTr("1000G America")
            onCheckedChanged: model.quickfilters.frequenceFilter.setFilter(4, checked)
        }
        ComboBox
        {
            visible: is1000gAmrAvailable
            width: 30
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
        }
        TextField
        {
            visible: is1000gAmrAvailable
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        CheckBox
        {
            Layout.fillWidth: true
            text: qsTr("1000G Asia")
            onCheckedChanged: model.quickfilters.frequenceFilter.setFilter(5, checked)
        }
        ComboBox
        {
            width: 50
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
        }
        TextField
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        CheckBox
        {
            Layout.fillWidth: true
            text: qsTr("1000G Europa")
            onCheckedChanged: model.quickfilters.frequenceFilter.setFilter(0, checked)
        }
        ComboBox
        {
            width: 50
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
        }
        TextField
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        CheckBox
        {
            Layout.fillWidth: true
            text: qsTr("Exac AM")
            onCheckedChanged: model.quickfilters.frequenceFilter.setFilter(1, checked)
        }
        ComboBox
        {
            width: 50
            model: [ "<", "≤", "=", "≥", ">", "≠" ]
        }
        TextField
        {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }
    }
}

