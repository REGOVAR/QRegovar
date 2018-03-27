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
        applyZoom(imageContainer.zoomScaleMin);
    }
    onWidthChanged: updateZoomScales()
    onHeightChanged: updateZoomScales()

    function updateZoomScales()
    {
        // get "fit level" coeff
        imageContainer.zoomScaleMin = Math.min(root.width / imageContainer.originalWidth, root.height / imageContainer.originalHeight);
        imageContainer.zoomScaleMax = 5;
    }

    function applyZoom(scale)
    {
        var checkedScale = scale;
        checkedScale = Math.max(checkedScale, imageContainer.zoomScaleMin);
        checkedScale = Math.min(checkedScale, imageContainer.zoomScaleMax);
        if (checkedScale != imageContainer.zoomScale)
        {
            imageContainer.zoomScale = checkedScale;
            image.width = imageContainer.originalWidth * checkedScale;
            image.height = imageContainer.originalHeight * checkedScale;
        }
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
                    text: qsTr("Fit")
                    onClicked: root.applyZoom(imageContainer.zoomScaleMin);
                }

                ButtonInline
                {
                    iconTxt: ""
                    text: qsTr("1:1")
                    onClicked: root.applyZoom(1.0);
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
                onZoomScaleChanged: applyZoom(zoomScale)

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
                            applyZoom(imageContainer.zoomScale += wheelStep * 0.1);
                        }
                    }
                }
            }
        }
    }
}
