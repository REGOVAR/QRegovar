import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import "Framework"
import "MainMenu"
import "Pages"
import "Regovar"

ApplicationWindow {
    visible: true
    title: qsTr("Regovar")
    id: root
    width: 800
    height: 600

    Settings
    {
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }

    // Load root's pages of regovar
    Component {
        id: welcomPage
        WelcomPage {}
    }
    Component {
        id: projectPage
        ProjectPage {}
    }
    Component {
        id: subjectPage
        SubjectPage {}
    }
    Component {
        id: settingsPage
        SettingsPage {}
    }
    Component {
        id: helpPage
        HelpPage {}
    }
    Component {
        id: aboutPage
        AboutPage {}
    }
    Component {
        id: disconnectPage
        DisconnectPage {}
    }
    Component {
        id: closePage
        ClosePage {}
    }

    property variant menuPageMapping:
    {
        "Welcom": welcomPage,
        "Project": projectPage,
        "Subject": subjectPage,
        "Settings": settingsPage,
        "Help": helpPage,
        "About": aboutPage,
        "Disconnect" : disconnectPage,
        "Close": closePage
    }

    MainMenu
    {
        id: mainMenu
        z: 10
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 300

        onSelectedEntryChanged:
        {
            stack.sourceComponent = menuPageMapping[mainMenu.selectedEntry]
        }
    }

    Loader {
        id: stack
        z:0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: mainMenu.right
        anchors.right: parent.right

        sourceComponent: welcomPage
        onSourceComponentChanged:
        {
            anim.start()
        }

        NumberAnimation
        {
            id: anim
            target: stack
            property: "opacity"
            easing.type: Easing.OutQuad
            from: 0
            to: 1
            duration: 250
        }

    }
}
