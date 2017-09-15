import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text:  qsTr("This step is optional.\nYou can link samples to subjects. It will be easier to retrieve their samples and analyses later.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.control
        color: Regovar.theme.primaryColor.back.normal
    }


    ColumnLayout
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10

        Text
        {
            text: qsTr("Selected samples")
            font.pixelSize: Regovar.theme.font.size.control
            color: Regovar.theme.frontColor.normal
        }

        TableView
        {
            id: samplesList
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: ListModel
            {
                ListElement {
                    name: "Hp-4456223"
                    firstname: "Michel"
                    lastname: "DUPONT"
                    sex: "Male"
                    birthdate: "1954-06-12 (63y)"

                }
                ListElement {
                    name: "Hp-4177789"
                    firstname: "Micheline"
                    lastname: "DUPONT"
                    sex: "Female"
                    birthdate: "1960-02-02 (57y)"
                }
                ListElement {
                    name: "Hp-4177789"
                    firstname: "Michou"
                    lastname: "DUPONT"
                    sex: "Male"
                    birthdate: "1999-10-23 (18y)"
                }
            }



            TableViewColumn
            {
                title: qsTr("Name")
                role: "name"
                delegate: Item
                {
                    Text
                    {
                        anchors.fill: parent
                        anchors.verticalCenter: parent.verticalCenter
                        text: model.name
                    }
                    Text
                    {
                        anchors.rightMargin: 5
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: styleData.textAlignment
                        font.pixelSize: Regovar.theme.font.size.control
                        text: "z"
                        font.family: Regovar.theme.icons.name
                    }
                }
            }
            TableViewColumn
            {
                title: qsTr("First name")
                role: "firstname"
            }
            TableViewColumn
            {
                title: qsTr("Last name")
                role: "lastname"
            }
            TableViewColumn { title: "Sex"; role: "sex" }
            TableViewColumn { title: "Date of birth"; role: "birthdate" }
        }
    }
}
