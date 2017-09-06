import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "AdvancedFilter"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model

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

                text: qsTr("Advanced filter")
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

            onWidthChanged: advancedFilterEditor.width = viewport.width - 10
            Component.onCompleted: advancedFilterEditor.width = viewport.width - 10

            GenericBlock
            {
                id:advancedFilterEditor
                model: root.model.filterJson
                x: 5
                y: 5
            }
        }

//        TextArea
//        {
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            id: advancedFilterTextEditor
//            // text: root.model.filter
//        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: Regovar.theme.primaryColor.back.light
        }


        ButtonWelcom
        {
            Layout.fillWidth: true
            text: qsTr("Apply current filter")
            iconText: "x"
            onClicked:
            {

                model.loadFilter(model.quickfilters.getFilter());
                model.results.reset();
            }
        }
        ButtonWelcom
        {
            Layout.fillWidth: true
            text: qsTr("Save current filter")
            iconText: "5"
            onClicked:
            {
                model.emitDisplayFilterSavingFormPopup();
            }
        }
    }
}
