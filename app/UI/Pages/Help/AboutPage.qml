import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model


    TabView
    {
        id: swipeview
        anchors.fill : root
        tabSharedModel: root.model

        tabsModel: ListModel
        {
            ListElement
            {
                title: qsTr("Information")
                source: "../Pages/Help/AboutInformation.qml"
            }
            ListElement
            {
                title: qsTr("License")
                source: "../Pages/Help/AboutLicense.qml"
            }
            ListElement
            {
                title: qsTr("Credits")
                source: "../Pages/Help/AboutCredits.qml"
            }
        }
    }


    ConnectionStatus
    {
        anchors.top: root.top
        anchors.right: root.right
        height: 40 // = header.height - 2x5 margins
        anchors.margins: 5
        anchors.rightMargin: 10
    }
}
