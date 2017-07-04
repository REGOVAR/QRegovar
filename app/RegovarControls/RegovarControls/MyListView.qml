import QtQuick 2.7
import QtQuick.Controls 2.0
import RegovarControls 1.0






Rectangle
{
    id: root
    color: Style.boxBackColor
    border.width: 1
    border.color: Style.boxBorderColor

    property alias interactive: content.interactive
    property VisualDataModel vm




    ListView
    {
        id: content
        anchors.fill: root
        anchors.margins: 1
        headerPositioning: ListView.OverlayHeader
        clip:true

        model: root.vm.model
        delegate: ListViewItem
        {
            contentItem: root.vm.delegate
        }


        ScrollBar.vertical: ScrollBar { }

        header: Text
        {
            text: "salut"
        }
    }
}



