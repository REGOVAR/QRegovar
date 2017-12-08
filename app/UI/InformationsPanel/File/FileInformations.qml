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

    property File model
    onModelChanged: setFileModel(model)

    function setFileModel(file)
    {
        if (file)
        {
            file.dataRefreshed.connect(updateFromModel);
            updateFromModel();
        }
    }


    function updateFromModel()
    {
        if (model && model.loaded)
        {
            icon.text = model.filenameUI["icon"];
            title.text = "<h1>" + model.name + "</h1></br>";
            title.text += qsTr("Status") + ": " + model.statusUI["label"] + "</br>";
            title.text += qsTr("Size") + ": " + model.sizeUI + "</br>";
            title.text += qsTr("Last modification") + ": " + Regovar.formatDate(model.updateDate);
        }
    }






    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            id: header
            Layout.fillWidth: true
            Layout.minimumHeight: 100 // icon : 80 + 2*10
            color: Regovar.theme.primaryColor.back.normal

            Text
            {
                id: icon
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                width: 80
                height: 80
                font.pixelSize: 80
                font.family: Regovar.theme.icons.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.primaryColor.front.normal
            }
            TextEdit
            {
                id: title
                anchors.top: parent.top
                anchors.left: icon.right
                anchors.right: parent.right
                anchors.margins: 10
                textFormat: TextEdit.RichText
                onPaintedHeightChanged: { header.Layout.minimumHeight = Math.max(100, paintedHeight + 20); }
                font.pixelSize: Regovar.theme.font.size.normal
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
                id: tabsPanel
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
