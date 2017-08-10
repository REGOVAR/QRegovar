import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtWebView 1.1
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
                title: "Informations"
                source: "../Pages/Help/AboutInformations.qml"
            }
            ListElement
            {
                title: "License"
                source: "../Pages/Help/AboutLicense.qml"
            }
            ListElement
            {
                title: "Credits"
                source: "../Pages/Help/AboutCredits.qml"
            }
        }
    }
}
