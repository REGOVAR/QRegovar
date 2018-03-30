import QtQuick 2.9
import QtGraphicalEffects 1.0
import Regovar.Core 1.0
import "../Regovar"

Item
{
    id: root
    height: logoImage.height + 20
    width: logoImage.width + 20

    Image
    {
        id: logoImage
        anchors.centerIn: parent
        source: "qrc:/regovar.png"
        sourceSize.height: 125
    }


    Glow
    {
        anchors.fill: logoImage
        radius: 8
        samples: 17
        color: Regovar.theme.darker(Regovar.theme.backgroundColor.main, 1.25)
        source: logoImage
        visible: regovar.networkManager.status != 0 || regovar.usersManager.user.id <= 0
    }
    ColorOverlay
    {
        anchors.fill: logoImage
        source: logoImage
        color: Regovar.theme.backgroundColor.alt
        visible: regovar.networkManager.status != 0 || regovar.usersManager.user.id <= 0
    }
    LinearGradient
    {
        anchors.fill: logoImage
        start: Qt.point(0, logoImage.height / 3)
        end: Qt.point(0, logoImage.height)
        gradient: Gradient
        {
            GradientStop { position: 0.0; color: Regovar.theme.logo.color1 }
            GradientStop { position: 1.0; color: Regovar.theme.logo.color2 }
        }
        source: logoImage

        visible: regovar.networkManager.status == 0 && regovar.usersManager.user.id >= 0
    }
}
