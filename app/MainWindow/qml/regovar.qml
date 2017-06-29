import QtQuick 2.0
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
        "Welcom": 0,
        "Project": 1,
        "Subject": 2,
        "Settings": 3,
        "Help": 4,
        "About": 5,
        "Disconnect" : 6,
        "Close": 7
    }

    Component.onCompleted: {
        stack.addItem(welcomPage)
        stack.addItem(projectPage)
        stack.addItem(subjectPage)
        stack.addItem(settingsPage)
        stack.addItem(helpPage)
        stack.addItem(aboutPage)
        stack.addItem(disconnectPage)
        stack.addItem(closePage)
        stack.setCurrentIndex(0)
        console.log(stack.count)
    }


    MainMenu
    {
        id: mainMenu
        z: 10
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.left: root.left
        width: 300

        onSelectedEntryChanged: stack.currentIndex = menuPageMapping[mainMenu.selectedEntry]
    }

    SwipeView  {
        id: stack
        z:0
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.left: mainMenu.right
        anchors.right: root.right
        interactive: false
    }



}
