import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"

Rectangle
{
    id: root
    width: parent.width
    height: header.height + subItemsList.height + footer.height + 10
    implicitHeight: Regovar.theme.font.boxSize.control

    color: "transparent"

    property var model
    property var subItems

    onModelChanged:
    {
        console.log("model changed");
        root.subItems = [1,2,3,4];
    }

    Component.onCompleted:
    {
        console.log(header.height + " " + subItemsList.height + " " + footer.height)
    }





    Rectangle
    {
        id: header
        width: parent.width
        height: Regovar.theme.font.boxSize.control
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 5

        ComboBox
        {
            anchors.top: root.top
            anchors.left: root.left
            model: ["AND", "OR"]

            color: "red"
        }

        Text
        {
            anchors.right: parent.right
            text: "|"
            height: Regovar.theme.font.boxSize.header
            width: Regovar.theme.font.boxSize.header
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Regovar.theme.font.size.header
            // color: loadFilterButton.mouseHover ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.normal
            font.family: Regovar.theme.icons.name
        }
    }



    Rectangle
    {
        anchors.top : header.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5 + Regovar.theme.font.boxSize.header / 2
        height: subItemsList.height
        width: 1
        color: "red" // Regovar.theme.boxColor.border
    }

    Column
    {
        id: subItemsList
        anchors.top : header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 5
        anchors.rightMargin: 5

        Repeater
        {
            model: 10

            Rectangle
            {
                height: Regovar.theme.font.boxSize.control
                width: parent.width
                color: "transparent"


                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    width: Regovar.theme.font.boxSize.header
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    text: "p"
                    font.family: Regovar.theme.icons.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Regovar.theme.font.size.control

                    color: "red"
                }
                Text
                {
                    text:"n°" + index
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 5 + Regovar.theme.font.boxSize.control
                }
            }
        }
    }

    Rectangle
    {
        id: footer
        width: parent.width
        height: Regovar.theme.font.boxSize.control
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 5

        Text
        {
            height: Regovar.theme.font.boxSize.header
            width: Regovar.theme.font.boxSize.header
            text:  "µ"

            font.family: Regovar.theme.icons.name
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Regovar.theme.font.size.control
        }
    }


//        Rectangle
//        {
//            Row
//            {
//                Text
//                {
//                    width: parent.width
//                    height: Regovar.theme.font.boxSize.control
//                    visible: (model == null || model.length ) ? true : false
//                    text:  "p"
//                    font.family: Regovar.theme.icons.name
//                    verticalAlignment: Text.AlignVCenter
//                    font.pixelSize: Regovar.theme.font.size.header
//                }
//            }
//        }

//        Repeater
//        {
//            id: subItemsContainer
//            // visible: (model == null || model.length ) ? false : true
//            model : [1,2,3,4,5] // subItems



//        }

//        Text
//        {
//            width: parent.width
//            height: Regovar.theme.font.boxSize.control
//            visible: (model == null || model.length ) ? true : false
//            text:  "Empty..."
//            verticalAlignment: Text.AlignVCenter
//            font.pixelSize: Regovar.theme.font.size.header
//        }
}
