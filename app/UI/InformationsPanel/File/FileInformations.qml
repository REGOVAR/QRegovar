import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var model
    onModelChanged:  if (model) { updateFromModel(model); }



    function updateFromModel(data)
    {
        icon.text = data.filenameUI["icon"];
        title.text = "<h1>" + data.name + "</h1></br>";
        title.text += qsTr("Status") + ": " + data.statusUI["label"] + "</br>";
        title.text += qsTr("Size") + ": " + data.sizeUI + "</br>";
        title.text += qsTr("Last modification") + ": " + Regovar.formatDate(data.updateDate);
    }





    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            id: header
            Layout.fillWidth: true
            Layout.minimumHeight: Regovar.theme.font.boxSize.header
            color: Regovar.theme.primaryColor.back.normal

            Text
            {
                id: icon
                anchors.top: parent.top
                anchors.left: parent.left
                text: "j"
                width: Regovar.theme.font.boxSize.header
                height: Regovar.theme.font.boxSize.header

                font.family: Regovar.theme.icons.name
                color: Regovar.theme.primaryColor.front.normal
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            TextEdit
            {
                id: title
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 5
                anchors.leftMargin: Regovar.theme.font.boxSize.header + 10
                textFormat: TextEdit.RichText
                text: ""
                onPaintedHeightChanged: { header.Layout.minimumHeight = Math.max(Regovar.theme.font.boxSize.header, paintedHeight + 10); }
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.front.normal
                readOnly: true
                selectByMouse: true
                selectByKeyboard: true
                wrapMode: TextEdit.Wrap
            }
        }

        Rectangle
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            TabView
            {
                id: swipeview
                anchors.fill : parent
                tabSharedModel: root.model
                smallHeader: true


                tabsModel: ListModel
                {
                    ListElement
                    {
                        title: qsTr("Informations")
                        icon: "j"
                        source: "../InformationsPanel/File/InfoPanel.qml"
                    }
                    ListElement
                    {
                        title: qsTr("Relations")
                        icon: "ê"
                        source: "../InformationsPanel/Common/RelationsPanel.qml"
                    }
                    ListElement
                    {
                        title: qsTr("Events")
                        icon: "H"
                        source: "../InformationsPanel/Common/EventsPanel.qml"
                    }
                }
            }
        }
    }
}
