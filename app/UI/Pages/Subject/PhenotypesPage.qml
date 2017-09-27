import QtQuick 2.7
import "../../Regovar"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model
    onModelChanged:
    {
        if (model != undefined)
        {
            nameLabel.text = model.name;
        }
    }

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            id: nameLabel
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter

            text: "-"
        }
    }


    Image
    {
        anchors.top: header.bottom
        anchors.left: root.left

        source: "qrc:/a231 Subject Phenotype.png"
    }
//    Text
//    {
//       text: "PHENOTYPES & CHARACTERISTICS"
//       font.pixelSize: 24
//       anchors.centerIn: parent
//    }
}
