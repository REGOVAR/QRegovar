import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "../Regovar"

BusyIndicator
{
    width: 100
    height: 100

    id: style

    property real indicatorSize: 100
    property int lines: 11
    property real length: 50    // % of the width of the control
    property real indicatorWidth: 10     // % of the height of the control
    property real radius: 20    // % of the width of the control
    property real corner: 1     // between 0 and 1
    property real speed: 100    // smaller is faster
    property real trail: 0.6    // between 0 and 1
    property bool clockWise: true

    property string color: "transparent" // Regovar.theme.primaryColor.back.normal
    property string highlightColor: Regovar.theme.secondaryColor.back.light
    property string bgColor: Regovar.theme.boxColor.back

    style: BusyIndicatorStyle
    {


        indicator: Rectangle
        {
            color: "transparent"
            visible: control.running


            Repeater
            {
                id: repeat
                anchors.centerIn: parent
                model: style.lines
                Rectangle
                {
                    property real factor: style.indicatorSize / 200
                    color: style.color
                    opacity: 0.7
                    Behavior on color
                    {
                        ColorAnimation
                        {
                            from: style.highlightColor
                            duration: style.speed * style.lines * style.trail
                        }
                    }
                    radius: style.corner * height / 2
                    width: style.length * factor
                    height: style.indicatorWidth * factor
                    x: style.indicatorSize / 2 + style.radius * factor
                    y: style.indicatorSize / 2 - height / 2
                    transform: Rotation {
                        origin.x: -style.radius * factor
                        origin.y: height / 2
                        angle: index * (360 / repeat.count)
                    }
                    Timer {
                        id: reset
                        interval: style.speed * (style.clockWise ? index : style.lines - index)
                        onTriggered: {
                            parent.opacity = 1
                            parent.color = style.highlightColor
                            reset2.start()
                        }
                    }
                    Timer {
                        id: reset2
                        interval: style.speed
                        onTriggered: {
                            parent.opacity = 0.7
                            parent.color = style.color
                        }
                    }
                    Timer {
                        id: globalTimer // for a complete cycle
                        interval: style.speed * style.lines
                        onTriggered: {
                            reset.start()
                        }
                        triggeredOnStart: true
                        repeat: true
                    }
                    Component.onCompleted: {
                        globalTimer.start()
                    }
                }
            }
        }
    }
}
