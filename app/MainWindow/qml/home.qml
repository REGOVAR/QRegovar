import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item
{
    id: root

    LinearGradient
    {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(0, 600)
        gradient: Gradient
        {
            GradientStop { position: 0.0; color: "#00FFFFFF" }
            GradientStop { position: 1.0; color: "#DDDDDDFF" }
        }
    }


    Text
    {
       text: "Welcome " + regovar.currentUser.firstname
       color: "#55999999"
       font.family: "Sans"
       font.weight: Font.Black
       font.pointSize: 24
       anchors.left: parent.left
       anchors.top: parent.top
       anchors.leftMargin: 30
    }
    Text
    {
       text: "Your sandbox"
       color: "#55999999"
       font.family: "Sans"
       font.weight: Font.Black
       font.pointSize: 24
       anchors.left: parent.left
       anchors.top: parent.top
       anchors.leftMargin: 30
       anchors.topMargin: 30
    }

    RowLayout
    {
        anchors.centerIn: parent

        Button
        {
            text: "Import raw data"
            onClicked: main.about()
            width: 100
            height: 100
        }

        Button
        {
            text: "Analyse imported data"
            onClicked: main.about()
            width: 100
            height: 100
        }

        Button
        {
            text: "Generate report"
            onClicked: main.about()
            width: 100
            height: 100
        }
    }







    Item
    {
        id: logo
        width: 300
        height: 100

        Image
        {
            source: "qrc:///img/sandbox.png"
            height: 100
            width: 300
            anchors.left: logo.left
            anchors.bottom: logo.bottom
            anchors.bottomMargin: 7
        }
        anchors.right: root.right
        anchors.rightMargin: 10
        anchors.bottom: root.bottom
        anchors.bottomMargin: 10
    }

}
