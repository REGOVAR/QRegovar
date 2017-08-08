import QtQuick 2.7
import QtQuick.Window 2.3

import "Regovar"

GenericWindow
{
    id: root
    width: 800
    height: 600

    menuModel: RegovarAnalysis{}
    title: mainModel.title

}
