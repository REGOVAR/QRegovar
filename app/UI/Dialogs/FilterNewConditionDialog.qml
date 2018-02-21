import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: filterSavingFormPopup
    modality: Qt.WindowModal

    title: qsTr("Add new filter's condition")

    width: 600
    height: 500
    property FilteringAnalysis model

    signal addNewCondition(var conditionJson)


    onVisibleChanged:
    {
        if (visible)
        {
            tabView.currentIndex = 0;
            model.newConditionModel.clear();
        }
    }



    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.alt


        DialogHeader
        {
            id: header
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            iconText: "3"
            title: qsTr("New filter condition")
            text: qsTr("Choose the type of condition you want to add and then configure it.")
        }

        TabView
        {
            id: tabView
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10

            tabSharedModel: root.model

            tabsModel: ListModel
            {
                ListElement
                {
                    enabled: true
                    title: qsTr("Logical")
                    source: "../Pages/Analysis/Filtering/AdvancedFilter/FilterFormLogical.qml"
                }
                ListElement
                {
                    enabled: true
                    title: qsTr("Field")
                    source: "../Pages/Analysis/Filtering/AdvancedFilter/FilterFormField.qml"
                }
                ListElement
                {
                    enabled: true
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

            height: Regovar.theme.font.boxSize.normal
            spacing: 10
            layoutDirection: Qt.RightToLeft

            Button
            {
                text: qsTr("Add filter")
                onClicked:
                {
                    console.log("retrieve model.toJson")
                    tabView.forceUpdateModel();
                    var json = model.newConditionModel.toJson();
                    if (json)
                    {
                        addNewCondition(model.newConditionModel.toJson());
                    }
                    else
                    {
                        // Todo display error
                    }


                }
            }
            Button
            {
                text: qsTr("Close")
                onClicked: filterSavingFormPopup.close()
            }
        }
    }
}
