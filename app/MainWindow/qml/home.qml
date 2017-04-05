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
       color: "red"
       font.family: "Sans"
       font.weight: Font.Black
       font.pointSize: 24
       anchors.centerIn: parent
       anchors.verticalCenterOffset: -100 // on decalle depuis le centre


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
        width: 178
        height: 50

        Image
        {
            source: "https://avatars1.githubusercontent.com/u/18222880?v=3&s=200"
            height: 50
            width: 50
            anchors.left: logo.left
            anchors.bottom: logo.bottom
            anchors.bottomMargin: 7
        }
        Text
        {
           text: "egovar"
           color: "#55000000"
           font.family: "Sans"
           font.weight: Font.Black
           font.pointSize: 24
           anchors.right: logo.right
           anchors.bottom: logo.bottom
        }
        anchors.right: root.right
        anchors.rightMargin: 10
        anchors.bottom: root.bottom
        anchors.bottomMargin: 10
    }

}
