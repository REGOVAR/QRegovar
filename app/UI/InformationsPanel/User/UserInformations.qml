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


    property string varId
    onVarIdChanged:
    {
        if (varId)
        {
            // Display loading feedback

            // request informations

        }
        else
        {
            // Display help message
        }
    }

    function updateFromModel(data)
    {
        var variant = "chr" + data["chr"] + ":" + data["pos"] + " " + data["ref"] + ">" + data["alt"];
        var gene = data["genename"];
        var ref = data["reference"];
        title.text = "<span style=\"font-family: monospace;\">" + variant + "</span><br/><br/><i>Ref: </i>" + ref + "&nbsp;&nbsp;&nbsp;</span>\n\n<i>Gene: </i>" + gene;
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
                        title: qsTr("Online Tools")
                        icon: "è"
                        source: "../InformationsPanel/User/InfoPanel.qml"
                    }
                    ListElement
                    {
                        title: qsTr("Regovar statistics")
                        icon: "^"
                        source: "../InformationsPanel/User/StatsPanel.qml"
                    }
                    ListElement
                    {
                        title: qsTr("Events")
                        icon: "è"
                        source: "../InformationsPanel/Common/EventsPanel.qml"
                    }
                }
            }
        }
    }

}
