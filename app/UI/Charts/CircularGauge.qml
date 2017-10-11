import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import "../Regovar"



Rectangle
{
    id: root
    width: 200
    height: 200
    color: "transparent"

    property real danger: 90
    property alias value: gauge.value
    property string valueLabel: gauge.value + "%"

    CircularGauge
    {
        id: gauge
        anchors.fill: parent



        style: CircularGaugeStyle
        {
            minimumValueAngle: -120
            maximumValueAngle: 120

            // Ticks
            tickmark: Rectangle
            {
                visible: styleData.value % 10 == 0
                implicitWidth: outerRadius * 0.02
                antialiasing: true
                implicitHeight: outerRadius * 0.06
                color: Regovar.theme.boxColor.back
            }

            minorTickmark: Rectangle
            {
                visible: styleData.value < 80
                implicitWidth: outerRadius * 0.01
                antialiasing: true
                implicitHeight: outerRadius * 0.03
                color: Regovar.theme.boxColor.back
            }

            tickmarkLabel:  Text
            {
                visible: styleData.value > gauge.minimumValue && styleData.value < gauge.maximumValue
                font.pixelSize: Math.max(6, outerRadius * 0.1)
                text: styleData.value
                color: Regovar.theme.boxColor.back
                antialiasing: true
            }



            // The indicator component
            needle: Rectangle
            {
                //y: outerRadius * 0.15
                implicitWidth: 2 // outerRadius * 0.03
                implicitHeight: outerRadius * 0.7
                antialiasing: true
                color: Regovar.theme.boxColor.back
            }
            foreground: Item
            {
                Rectangle
                {
                    width: 75 // outerRadius * 0.2
                    height: width
                    radius: width / 2
                    color: Regovar.theme.boxColor.border
                    anchors.centerIn: parent

                    Rectangle
                    {
                        width: parent.width - 6
                        height: width
                        radius: width / 2
                        color: root.value < root.danger ? Regovar.theme.frontColor.success :  Regovar.theme.frontColor.danger
                        anchors.centerIn: parent

                        Text
                        {
                            anchors.centerIn: parent
                            text: root.valueLabel
                            font.bold: true
                            color: Regovar.theme.primaryColor.front.dark
                            font.pixelSize: Regovar.theme.font.size.header
                        }
                    }
                }

            }

            // circular background
            function degreesToRadians(degrees)
            {
                return degrees * (Math.PI / 180);
            }

            background: Canvas
            {
                onPaint:
                {
                    var strockeWidth = 60; // outerRadius * 0.02;
                    var ctx = getContext("2d");
                    ctx.reset();

                    ctx.beginPath();
                    ctx.strokeStyle = Regovar.theme.frontColor.success;
                    ctx.lineWidth = strockeWidth;
                    ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2, degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(root.danger) - 90));
                    ctx.stroke();

                    ctx.beginPath();
                    ctx.strokeStyle = Regovar.theme.frontColor.danger;
                    ctx.lineWidth = strockeWidth;
                    ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2, degreesToRadians(valueToAngle(root.danger) - 90), degreesToRadians(valueToAngle(100) - 90));
                    ctx.stroke();


//                    ctx.beginPath();
//                    ctx.strokeStyle = Regovar.theme.darker(Regovar.theme.frontColor.success);
//                    ctx.lineWidth = strockeWidth * 0.5;
//                    ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2, degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(Math.min(root.value, root.danger)) - 90));
//                    ctx.stroke();

//                    if (root.value > root.danger)
//                    {
//                        ctx.beginPath();
//                        ctx.strokeStyle = Regovar.theme.darker(Regovar.theme.frontColor.danger);
//                        ctx.lineWidth = strockeWidth * 0.5;
//                        ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2, degreesToRadians(valueToAngle(root.danger) - 90), degreesToRadians(valueToAngle(root.value) - 90));
//                        ctx.stroke();
//                    }
                }
            }
        }
    }
}
