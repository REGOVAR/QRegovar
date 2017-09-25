import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: filterSavingFormPopup
    modality: Qt.WindowModal

    title: qsTr("Add new filter's condition")

    width: 400
    height: 400
    property FilteringAnalysis model





    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.alt


        Text
        {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: Regovar.theme.font.boxSize.header

            text: qsTr("Choose the type of condition you want to add")
            font.pixelSize: Regovar.theme.font.size.header


        }

        TabView
        {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10

            tabSharedModel: root.model
            onTabSharedModelChanged:
            {
                console.log("===> FilteringPage setting up the shared model of the tabView with its model");
            }

            tabsModel: ListModel
            {
                ListElement
                {
                    title: qsTr("Logical")
                    source: "../Pages/Analysis/Filtering/AdvancedFilter/FilterFormLogical.qml"
                }
                ListElement
                {
                    title: qsTr("Field")
                    source: "../Pages/Analysis/Filtering/AdvancedFilter/FilterFormField.qml"
                }
                ListElement
                {
                    title: qsTr("Set")
                    source: "../Pages/Analysis/Filtering/AdvancedFilter/FilterFormSet.qml"
                }
            }
        }

        Row
        {
            id: footer
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            height: Regovar.theme.font.boxSize.control
            spacing: 10
            layoutDirection: Qt.RightToLeft

            Button
            {
                text: qsTr("Add filter")
            }
            Button
            {
                text: qsTr("Close")
            }
        }


    }
}
