import QtQuick 2.7
import QtQuick.Controls 2.0

import "components/mainmenu"
import "pages"
import "regovar.js" as JS

Item
{
    id: root


    // Load root's pages of regovar
    WelcomPage { id: welcomPage }
    ProjectPage { id: projectPage }
    SubjectPage { id: subjectPage }
    SettingsPage { id: settingsPage }
    HelpPage { id: helpPage }
    AboutPage { id: aboutPage }
    DisconnectPage { id: disconnectPage }
    ClosePage { id: closePage }

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

        onSelectedEntryChanged: stack.push( menuPageMapping[mainMenu.selectedEntry])
    }

    StackView {
        id: stack
        z:0
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.left: mainMenu.right
        anchors.right: root.right
    }

        Component.onCompleted: stack.push(welcomPage)


}
