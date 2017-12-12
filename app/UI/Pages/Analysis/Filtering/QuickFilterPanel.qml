import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "Quickfilter"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        // We set manually the model to be able to call *after* the reset of the control
        // otherwise with binding, this order may not be respect, and init of UI is not good.
        console.log("reset all quick filter panel")
        for (var i = 0; i < container.children.length; ++i)
        {
            var item = container.children[i];
            if (item.objectName == "qf")
            {
                item.model = model;
                item.reset();
            }
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            height: Regovar.theme.font.size.header + 20 // 20 = 2*10 to add spacing top+bottom
            Layout.fillWidth: true
            color: Regovar.theme.backgroundColor.main

            Text
            {
                id: textHeader
                anchors.fill: parent
                anchors.margins: 10

                text: qsTr("Quick filter")
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                elide: Text.ElideRight
            }

            Rectangle
            {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Regovar.theme.primaryColor.back.light
            }
        }

        ScrollView
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                id: container
                Rectangle { width: root.width; height: 5; color: "transparent" }
                TransmissionQuickForm { objectName: "qf"; width: root.width; }
                QualityQuickForm { objectName: "qf"; width: root.width; }
                PositionQuickFilter { objectName: "qf"; width: root.width; }
                TypeQuickFilter { objectName: "qf"; width: root.width; }
                FrequenceQuickFilter { objectName: "qf"; width: root.width; }
                SilicoPredQuickFilter { objectName: "qf"; width: root.width; }
                PanelQuickForm { objectName: "qf"; width: root.width; }
                OntologyQuickFilter { objectName: "qf"; width: root.width; }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: Regovar.theme.primaryColor.back.light
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: applyButton.height + 20
            color: "transparent"

            ButtonIcon
            {
                id: applyButton
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                text: qsTr("Apply filter")
                icon: "x"
                onClicked:
                {
                    var qf = model.quickfilters.toJson();
                    model.currentFilterName = "";
                    model.results.applyFilter(qf);
                    model.advancedfilter.forceRefresh = true;
                    model.advancedfilter.loadJson(qf);
                }
            }
            ButtonIcon
            {
                id: saveButton
                anchors.top: parent.top
                anchors.left: applyButton.right
                anchors.margins: 10
                text: qsTr("Save filter")
                icon: "5"
                enabled: model && model.currentFilterName == ""
                onClicked:
                {
                    model.emitDisplayFilterSavingFormPopup();
                }
            }
        }
    }
}
