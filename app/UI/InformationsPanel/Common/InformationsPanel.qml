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



    property var updateFromModel: function(model) {  console.log("ERROR : Please you MUST implement updateFromModel(model)"); }
    property bool loading: true
    property bool error: false
    property string icon: "j"
    property string title: "Information"
    property alias tabSharedModel: tabsPanel.tabSharedModel
    property alias tabsModel: tabsPanel.tabsModel
    property var model
    onModelChanged:
    {
        if (model)
        {
            root.error = false;
            updateFromModel(model);
            //tabsPanel.forceRefreshTabs();
        }
        else
        {
            root.error = true;
        }
    }


    function reset()
    {
        root.loading = true;
        root.model = null;
        tabsPanel.clear();
        root.error = false;
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
                text: root.error ? "m" : root.loading ? "/" : root.icon
                onTextChanged:
                {
                    if (text == "/")
                    {
                        iconAnimation.start();
                    }
                    else
                    {
                        iconAnimation.stop();
                        rotation = 0;
                    }
                }

                NumberAnimation on rotation
                {
                    id: iconAnimation
                    duration: 1500
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                }
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
                text: root.error ? "<h1>" + qsTr("Unable to retrieve data") + "</h1>" : root.loading ? "<h1>" + qsTr("Collecting data...") + "</h1>" : root.title
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
                tabsModel: ListModel {}
            }
        }
    }
}
