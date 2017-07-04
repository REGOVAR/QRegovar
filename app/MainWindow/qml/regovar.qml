import QtQuick 2.7
import QtQuick.Controls 2.0

import "components/mainmenu"
import "pages"
import "regovar.js" as JS

Item
{
    id: root


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

    property variant menuPageMapping: {
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
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.left: root.left
        width: 300

        onSelectedEntryChanged:
        {
            stack.sourceComponent = menuPageMapping[mainMenu.selectedEntry]
        }
    }

    Loader {
        id: stack
        z:0
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.left: mainMenu.right
        anchors.right: root.right

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
            duration: 500
        }

    }

       // Component.onCompleted: stack.push(welcomPage)


}
