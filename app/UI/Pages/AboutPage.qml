import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "../Regovar"
import "../Framework"

Rectangle
{
    id: root

    color: Regovar.theme.backgroundColor.main




    TreeView
    {
        id: browser
        anchors.fill: parent
        anchors.margins: 10
        model: regovar.currentFilteringAnalysis

        // Default delegate for all column
        itemDelegate: Item
        {
            Text
            {
                anchors.leftMargin: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                text: styleData.value.text
                elide: Text.ElideRight
            }
        }

        TableViewColumn
        {
            role: "b09f180e56409dd4b343e61e36859efe"
            title: "Id"
        }

        TableViewColumn {
            role: "816ce7a58b6918652399342e46143386"
            title: "chr"
        }

        TableViewColumn {
            role: "0ec9783c0c626c928005f05956cb3d7b"
            title: "pos"
        }

        TableViewColumn {
            role: "de2b02e8a7f3c77cf55efd18e0832f22"
            title: "ref"
        }

        TableViewColumn {
            role: "ab1e6b068bd1618d0422a462df93f28b"
            title: "alt"
        }

        TableViewColumn {
            role: "66b71b223a449d2369e7d58ec0c7cd5d"
            title: "samples"
        }

        TableViewColumn {
            role: "6cde5e77baebcc9d98c40a720f6c1b82"
            title: "count"
        }

        TableViewColumn {
            role: "b33e172643f14920cee93d25daaa3c7b"
            title: "GT"
        }

        TableViewColumn {
            role: "3ee42adc14f878158deeb74e16131cf5"
            title: "DP"
        }
    }

}
