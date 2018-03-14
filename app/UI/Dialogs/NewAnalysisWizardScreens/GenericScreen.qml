import QtQuick 2.9
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.alt
    clip: true

    property bool readyForNext: false
    property var analysisModel: ({})

    function validate()
    {
        return true;
    }
}
