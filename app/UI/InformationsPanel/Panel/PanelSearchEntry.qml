import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"

Row
{
    id: root
    spacing: 10

    property var model
    signal added()
    signal showDetails()


    ButtonInline
    {
        icon: "à"
        text: ""
        onClicked: root.added()
    }
    ButtonInline
    {
        icon: "z"
        text: ""
        onClicked: root.showDetails()
    }

    Text
    {
        text: ("symbol" in root.model) ? root.model["symbol"] : root.model["label"]
    }


}
