import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtWebView 1.1
import "../../Regovar"

Item
{
    ColumnLayout
    {
        spacing: 10


        Rectangle
        {
            Layout.fillWidth: true
            height: 150

            color: Regovar.theme.boxColor.back

            Text
            {
                anchors.centerIn: parent
                text: "License header like on github."
            }
        }

        WebView
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            url: "https://raw.githubusercontent.com/REGOVAR/Regovar/master/LICENSE"
        }
    }
}
