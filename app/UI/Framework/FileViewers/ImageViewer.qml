import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"

Item
{
    id: root
    anchors.fill: parent

    property File model
    onModelChanged:
    {
        fileName.text = model.name;
        image.source = "file://" + model.localFilePath;
        // compute min and max zoom scale according to image size
        // - minscale = whole image fit the screen
        // - maxscale = 5x of the image 1:1
        imageContainer.originalWidth = image.width;
        imageContainer.originalHeight = image.height;

        imageContainer.zoomScaleMin = 0.5;
        imageContainer.zoomScaleMax = 5;
        imageContainer.zoomScale = 1.0;
    }

    ColumnLayout
    {
        anchors.fill: parent

        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            RowLayout
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10

                Text
                {
                    id: fileName
                    Layout.fillWidth: true
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    elide: Text.ElideRight
                }

                ButtonInline
                {
                    iconTxt: ""
                    text: qsTr("Restore Zoom")
                    onClicked: Qt.openUrlExternally(model.localFilePath);
                }

                ButtonInline
                {
                    iconTxt: "_"
                    text: qsTr("Open externaly")
                    onClicked: Qt.openUrlExternally(model.localFilePath);
                }
            }



            Rectangle
            {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: parent.width
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }
        }


        Rectangle
        {
            id: fileContent
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: "black"
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            clip: true

            Flickable
            {
                id: imageContainer
                anchors.fill: parent
                anchors.margins: 1
                contentWidth: image.width
                contentHeight: image.height

                property int originalWidth: 100
                property int originalHeight: 100
                property real zoomScaleMin: 1.0
                property real zoomScaleMax: 1.0
                property real zoomScale: 1.0
                onZoomScaleChanged:
                {
                    var newWidth = originalWidth * zoomScale;
                    var newHeight = originalHeight * zoomScale;
                    image.width = newWidth;
                    image.height = newHeight;
                    console.log(zoomScale);
                }

                Image
                {
                    id: image
                }

                MouseArea
                {
                    anchors.fill: parent
                    onWheel:
                    {
                        if (wheel.modifiers & Qt.ControlModifier)
                        {
                            var wheelStep = wheel.angleDelta.y / 120;
                            imageContainer.zoomScale += wheelStep * 0.1;
                            imageContainer.zoomScale = Math.max(imageContainer.zoomScale, imageContainer.zoomScaleMin);
                            imageContainer.zoomScale = Math.min(imageContainer.zoomScale, imageContainer.zoomScaleMax);

                        }
                    }
                }
            }
        }
    }
}
