import QtQuick 2.9
import QtQuick.Layouts 1.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Row
{
    id: root
    spacing: 10

    property alias label: label.text
    signal added()
    signal showDetails()


    ButtonInline
    {
        iconTxt: "à"
        text: ""
        onClicked: root.added()
    }
    ButtonInline
    {
        iconTxt: "z"
        text: ""
        onClicked: root.showDetails()
    }

    Text
    {
        id: label
    }
}
