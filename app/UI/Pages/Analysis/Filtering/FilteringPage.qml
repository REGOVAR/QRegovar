import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "../../../MainMenu"

import "Quickfilter"
import org.regovar 1.0

Rectangle
{
    id: root
    property FilteringAnalysis model
//    onModelChanged:
//    {
//        console.log("===> FilteringPage model set up");
//    }

    SplitView
    {
        anchors.fill: parent

        TabView
        {
            id: lefPanel
            width: 250
            tabSharedModel: root.model
            onTabSharedModelChanged:
            {
                console.log("===> FilteringPage setting up the shared model of the tabView with its model");
            }

            tabsModel: ListModel
            {
                ListElement
                {
                    //title: qsTr("Quick filters")
                    icon: "2"
                    source: "../Pages/Analysis/Filtering/QuickFilterPanel.qml"
                }
                ListElement
                {
                    //title: qsTr("Advanced filters")
                    icon: "3"
                    source: "../Pages/Analysis/Filtering/AdvancedFilterPanel.qml"
                }
                ListElement
                {
                    //title: qsTr("Annotations")
                    icon: "o"
                    source: "../Pages/Analysis/Filtering/AnnotationsSelectorPanel.qml"
                }
            }
        }

        ResultsPanel
        {
            id: rightPanel
            model: root.model
            Layout.fillWidth: true
        }
    }


    Connections
    {
        target: model
        onDisplayFilterSavingFormPopup:
        {
            filterSavingFormPopup.filterName = "";
            filterSavingFormPopup.filterDescription = "";
            filterSavingFormPopup.open();
        }
    }


    Dialog
    {
        id: filterSavingFormPopup
        modality: Qt.WindowModal

        title: qsTr("Save your filter")

        width: 300
        height: 200

        property alias filterName: nameField.text
        property alias filterDescription: descriptionField.text




        contentItem: Rectangle
        {
            anchors.fill : parent
            color: Regovar.theme.backgroundColor.main

            ColumnLayout
            {
                anchors.fill : parent
                Rectangle
                {
                    id: header
                    color: Regovar.theme.primaryColor.back.dark
                    height: 50
                    width: parent.width

                    Row
                    {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left

                        Text
                        {
                            text: "5"
                            color: Regovar.theme.primaryColor.front.dark
                            font.family: Regovar.theme.icons.name
                            font.weight: Font.Black
                            font.pointSize: Regovar.theme.font.size.header
                            width: 50
                            height: 50
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment:  Text.AlignHCenter
                        }

                        Text
                        {
                            text: qsTr("Save your filter")
                            color: Regovar.theme.primaryColor.front.dark
                            font.family: "Sans"
                            font.weight: Font.Black
                            font.pointSize: Regovar.theme.font.size.header
                            height: 50
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Grid
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    columns: 2
                    rows:2
                    columnSpacing: 30
                    rowSpacing: 10

                    Text
                    {
                        text: qsTr("Name*")
                        font.weight: Font.Black
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.header
                        font.family: Regovar.theme.font.familly
                        verticalAlignment: Text.AlignVCenter
                        height: 35
                    }
                    TextField
                    {
                        id: nameField
                        Layout.fillWidth: true
                        placeholderText: qsTr("Name of your filter (mandatory)")
                    }
                    Text
                    {
                        text: qsTr("Description")
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.header
                        font.family: Regovar.theme.font.familly
                        verticalAlignment: Text.AlignVCenter
                        height: 35
                    }
                    TextArea
                    {
                        id: descriptionField
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }

                Row
                {
                    spacing: 10
                    anchors.right: parent.right
                    height: cancelButton.height
                    width: cancelButton.width + 10 + okButton.width


                    Button
                    {
                        id: cancelButton
                        text: qsTr("Cancel")

                        onClicked:
                        {
                            filterSavingFormPopup.close();
                        }
                    }

                    Button
                    {
                        id: okButton
                        text: qsTr("Save")

                        onClicked:
                        {
                            model.saveCurrentFilter(filterSavingFormPopup.filterName, filterSavingFormPopup.filterDescription);
                            filterSavingFormPopup.close();
                        }
                    }
                }
            }
        }
    }

}
