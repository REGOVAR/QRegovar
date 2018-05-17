import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    anchors.fill: parent
    color: Regovar.theme.backgroundColor.main

    property File model
    onModelChanged:
    {
        if (model)
        {
            mediaplayer.source = "file://" + model.localFilePath;
            timeline.maximumValue = mediaplayer.duration;


            if (model.extensionToIco(model.type) == "Z")
            {
                preview.visible = true;
                video.source = mediaplayer;
            }
        }
    }

    MediaPlayer
    {
        id: mediaplayer
        autoPlay: true
        onPositionChanged:
        {
            timeline.value = position;
            timelineLabel.text = regovar.formatDuration(position) + " / " + regovar.formatDuration(duration);
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
                    iconTxt: "_"
                    text: qsTr("Open externaly")
                    onClicked: Qt.openUrlExternally(model.localFilePath);
                }
            }
        }


        Rectangle
        {
            id: preview
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "black"
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            visible: false

            VideoOutput
            {
                id: video
                anchors.fill: parent
                anchors.margins: 1

                MouseArea
                {
                    id: playArea
                    anchors.fill: parent
                    onPressed:
                    {
                        if (mediaplayer.playbackState == MediaPlayer.PlayingState)
                        {
                            mediaplayer.pause();
                        }
                        else
                        {
                            mediaplayer.play();
                        }
                    }
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                ButtonInline
                {
                    iconTxt: mediaplayer.playbackState == MediaPlayer.PlayingState ? "y" : "x"
                    text: ""
                    onClicked:
                    {
                        if (mediaplayer.playbackState == MediaPlayer.PlayingState)
                        {
                            mediaplayer.pause();
                        }
                        else
                        {
                            mediaplayer.play();
                        }
                    }
                }
                ButtonInline
                {
                    iconTxt: "w"
                    text: ""
                    onClicked: mediaplayer.stop();
                }

                Rectangle
                {
                    width: 1
                    Layout.fillHeight: true
                    color: Regovar.theme.primaryColor.back.normal
                }
                Text
                {
                    id: timelineLabel
                    width: 75
                    horizontalAlignment: Text.AlignRight
                    font.family: fixedFont
                }

                Slider
                {
                    Layout.fillWidth: true
                    id: timeline
                    stepSize: 1
                }
            }
        }
    }



}
