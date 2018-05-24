import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Item
{
    id: root

    FontLoader { id: iconsFont; source: "../../Icons.ttf" }

    ColumnLayout
    {
        spacing: 10
        anchors.fill: parent
        anchors.margins: 10




        GridLayout
        {
            id: headerGrid
            Layout.fillWidth: true
            rows: 2
            columns: 4
            columnSpacing: 10
            rowSpacing: 5


            Row
            {
                spacing: 10
                Text
                {
                    text: "M"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.disable
                    font.pixelSize: 22
                    height: 35
                    width: 30
                }
                Text
                {
                    text: qsTr("GNU Affero General Public License v3.0")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.header
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
            }

            Text
            {
                text: qsTr("Permissions")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.header
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            Text
            {
                text: qsTr("Limitations")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.header
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            Text
            {
                text: qsTr("Conditions")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.header
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextArea
            {
                Layout.fillWidth: true
                readOnly: true
                text: qsTr("Permissions of this strongest copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights. When a modified version is used to provide a service over a network, the complete source code of the modified version must be made available.")
            }

            Grid
            {
                rows:6
                columns: 2
                Layout.alignment: Qt.AlignTop

                Text
                {
                    text: "n"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.success
                    width: 20
                }
                Text
                {
                    text: qsTr("Commercial use")
                }
                Text
                {
                    text: "n"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.success
                    width: 20
                }
                Text
                {
                    text: qsTr("Modification")
                }
                Text
                {
                    text: "n"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.success
                    width: 20
                }
                Text
                {
                    text: qsTr("Distribution")
                }
                Text
                {
                    text: "n"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.success
                    width: 20
                }
                Text
                {
                    text: qsTr("Patent use")
                }
                Text
                {
                    text: "n"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.success
                    width: 20
                }
                Text
                {
                    text: qsTr("Private use")
                }
                Rectangle
                {
                    color: "transparent"
                    Layout.fillHeight: true
                }
            }

            Grid
            {
                rows:3
                columns: 2
                Layout.alignment: Qt.AlignTop

                Text
                {
                    text: "h"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.danger
                    width: 20
                }
                Text
                {
                    text: qsTr("Liability")
                }
                Text
                {
                    text: "h"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.danger
                    width: 20
                }
                Text
                {
                    text: qsTr("Warranty")
                }
                Rectangle
                {
                    color: "transparent"
                    Layout.fillHeight: true
                }
            }

            Grid
            {
                rows:6
                columns: 2
                Layout.alignment: Qt.AlignTop

                Text
                {
                    text: "j"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.info
                    width: 20
                }
                Text
                {
                    text: qsTr("License and copyright notice")
                }
                Text
                {
                    text: "j"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.info
                    width: 20
                }
                Text
                {
                    text: qsTr("State changes")
                }
                Text
                {
                    text: "j"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.info
                    width: 20
                }
                Text
                {
                    text: qsTr("Disclose source")
                }
                Text
                {
                    text: "j"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.info
                    width: 20
                }
                Text
                {
                    text: qsTr("Network use is distribution")
                }
                Text
                {
                    text: "j"
                    font.family: iconsFont.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.frontColor.info
                    width: 20
                }
                Text
                {
                    text: qsTr("Same license")
                }
                Rectangle
                {
                    color: "transparent"
                    Layout.fillHeight: true
                }
            }
        }

        Rectangle
        {
            id: licenseBox
            Layout.fillHeight: true
            Layout.fillWidth: true
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            radius: 2
            color: Regovar.theme.boxColor.back

            Flickable
            {
                id: scrollView

                anchors.fill: parent
                anchors.margins: 5

                contentWidth: scrollView.width - 10
                contentHeight: license.height
                clip: true
                onContentYChanged: vbar.position = contentY / license.height;

                Behavior on contentY
                {
                    NumberAnimation
                    {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }

                TextEdit
                {
                    id: license
                    width: scrollView.width - 30
                    text: regovar.config.license
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                    readOnly: true
                    selectByMouse: true
                    selectByKeyboard: true
                    wrapMode: TextEdit.Wrap
                }
            }

            ScrollBar
            {
                id: vbar
                hoverEnabled: true
                orientation: Qt.Vertical
                size: root.height / license.height
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                policy: ScrollBar.AlwaysOn
                onPositionChanged: if (pressed)
                {
                    scrollView.contentY = vbar.position * license.height;
                }
            }
        }
    }
}
