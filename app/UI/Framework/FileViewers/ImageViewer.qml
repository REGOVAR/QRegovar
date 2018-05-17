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
        image.source = "file:///" + model.localFilePath;
        // compute min and max zoom scale according to image size
        // - minscale = whole image fit the screen
        // - maxscale = 5x of the image 1:1
        imageContainer.originalWidth = image.width;
        imageContainer.originalHeight = image.height;

        updateZoomScales();
        applyZoom(0, 0, imageContainer.zoomScaleMin);
    }
    onWidthChanged: updateZoomScales()
    onHeightChanged: updateZoomScales()

    function updateZoomScales()
    {
        // get "fit level" coeff
        imageContainer.zoomScaleMin = Math.min(root.width / imageContainer.originalWidth, root.height / imageContainer.originalHeight);
        imageContainer.zoomScaleMax = 5;
    }

    function applyZoom(mouseX, mouseY, scale)
    {
        var checkedScale = scale;
        checkedScale = Math.max(checkedScale, imageContainer.zoomScaleMin);
        checkedScale = Math.min(checkedScale, imageContainer.zoomScaleMax);
        if (!isNaN(checkedScale) && checkedScale != imageContainer.zoomScale)
        {
            var deltaX = mouseX + Math.abs(imageContainer.contentX);
            var deltaY = mouseY + Math.abs(imageContainer.contentY);
            deltaX = deltaX / imageContainer.zoomScale;
            deltaY = deltaY / imageContainer.zoomScale;
            var newDX = deltaX * checkedScale;
            var newDY = deltaY * checkedScale;

            console.log(imageContainer.zoomScale + " => " + checkedScale);
            imageContainer.zoomScale = checkedScale;
            image.width = imageContainer.originalWidth * checkedScale;
            image.height = imageContainer.originalHeight * checkedScale;
            imageContainer.contentX = mouseX - newDX;
            imageContainer.contentY = mouseY - newDY;

        }
    }

    ColumnLayout
    {
        anchors.fill: parent

        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title
            color: Regovar.theme.backgroundColor.alt
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            radius: 2

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text
                {
                    id: fileIcon
                    Layout.minimumWidth: Regovar.theme.font.boxSize.header
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.header
                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.dark
                }
                Text
                {
                    id: fileName
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    elide: Text.ElideRight
                }


                ButtonIcon
                {
                    iconTxt: ""
                    text: qsTr("Fit")
                    onClicked: root.applyZoom(imageContainer.zoomScaleMin);
                }

                ButtonIcon
                {
                    iconTxt: ""
                    text: qsTr("1:1")
                    onClicked: root.applyZoom(0,0, 1.0);
                }

                ButtonIcon
                {
                    iconTxt: "_"
                    text: qsTr("Open externaly")
                    onClicked: Qt.openUrlExternally(0,0, model.localFilePath);
                }
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

                boundsBehavior: Flickable.StopAtBounds

                property int originalWidth: 100
                property int originalHeight: 100
                property real zoomScaleMin: 1.0
                property real zoomScaleMax: 1.0
                property real zoomScale: 1.0

                Image
                {
                    id: image
                }

                MouseArea
                {
                    anchors.fill: parent
                    onWheel:
                    {
                        //if (wheel.modifiers & Qt.ControlModifier)
                        {
                            var wheelStep = wheel.angleDelta.y / 120;
                            applyZoom(wheel.x, wheel.y, imageContainer.zoomScale + wheelStep * 0.1);
                        }
                    }
                }
            }
        }
    }
}
