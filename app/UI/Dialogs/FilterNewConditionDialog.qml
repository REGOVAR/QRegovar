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


        Rectangle
        {
            id: header
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 100

            color: Regovar.theme.primaryColor.back.normal

            Text
            {
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.margins: 10
                width: 80
                height: 80

                text: "3"
                font.pixelSize: 80
                font.family: Regovar.theme.icons.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                color: Regovar.theme.primaryColor.front.normal
                elide: Text.ElideRight
            }

            Text
            {
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 10
                anchors.leftMargin: 100


                text: qsTr("New filter condition")
                font.pixelSize: Regovar.theme.font.size.title
                font.bold: true
                color: Regovar.theme.primaryColor.front.normal
                elide: Text.ElideRight
            }
            Text
            {
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                anchors.topMargin: 15 + Regovar.theme.font.size.title
                anchors.leftMargin: 100
                wrapMode: "WordWrap"
                elide: Text.ElideRight

                text: qsTr("Choose the type of condition you want to add and then configure it.")
                font.pixelSize: Regovar.theme.font.size.control
                color: Regovar.theme.primaryColor.front.normal
            }
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
            onTabSharedModelChanged:
            {
                console.log("===> FilteringPage setting up the shared model of the tabView with its model");
            }

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
                    enabled: false
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
                onClicked:
                {
                    console.log("retrieve model.toJson")
                    tabView.forceUpdateModel();
                    addNewCondition(model.newConditionModel.toJson());
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
