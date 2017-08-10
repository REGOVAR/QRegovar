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
    title : qsTr("Transmission mode")
    isEnabled : false
    isExpanded: false

    content: Column
    {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Text
        {
            text: qsTr("Mode")
        }

        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("All")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("Dominant")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("Recessive")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 60 }
            CheckBox
            {
                text: qsTr("Heterozygous")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 60 }
            CheckBox
            {
                text: qsTr("Compound heterozygous")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }


        Text
        {
            text: qsTr("Segregation")
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("All")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("De novo")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("Inherited")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }

        Text
        {
            text: qsTr("Localisation")
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("All")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("Autosomal")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("X-linked")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
        Row
        {
            Rectangle { width: 30 }
            CheckBox
            {
                text: qsTr("Mitochondrial")
                checked: true
                onCheckedChanged: model.quickfilters.transmissionFilter.setFilter(0, checked)
            }
        }
    }
}
