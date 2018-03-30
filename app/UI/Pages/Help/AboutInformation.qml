import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Item
{
    id: root

    Item
    {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: girciFrame.top

        Rectangle
        {
            anchors.centerIn: parent
            Layout.alignment: Qt.AlignHCenter
            width: 500
            height: info.height + 20
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            color: Regovar.theme.boxColor.back

            Image
            {
                id: logo
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.margins: 10
                width: 80
                height: 80

                source: "qrc:/logo.png"
            }

            GridLayout
            {
                id: info
                anchors.top: parent.top
                anchors.left: logo.right
                anchors.right: parent.right
                anchors.margins: 10
                anchors.leftMargin: 20

                columns: 2
                rows: 14
                rowSpacing: 5
                columnSpacing: 10

                Text
                {
                    text: qsTr("Regovar")
                    font.pixelSize: Regovar.theme.font.size.title
                    font.bold: true
                    color: Regovar.theme.primaryColor.back.normal
                    Layout.columnSpan: 2
                }


                Text
                {
                    text: qsTr("Server version:")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: regovar.config.serverVersion
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }

                Text
                {
                    text: qsTr("Client version:")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: regovar.config.clientVersion
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }


                Rectangle
                {
                    color: "transparent"
                    Layout.columnSpan: 2
                    height: 15
                    width: 50
                    Rectangle
                    {
                        width: 50
                        height: 1
                        anchors.verticalCenter: parent.verticalCenter
                        color: Regovar.theme.primaryColor.back.normal
                    }
                }



                Text
                {
                    text: qsTr("Website:")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    id: regolink
                    text: "http://regovar.org"
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                    MouseArea
                    {
                        anchors.fill: parent
                        cursorShape: "PointingHandCursor"
                        onClicked: Qt.openUrlExternally("http://regovar.org")
                        hoverEnabled: true
                        onEntered: regolink.color = Regovar.theme.secondaryColor.back.normal
                        onExited:  regolink.color = Regovar.theme.frontColor.normal
                    }
                }

                Text
                {
                    text: qsTr("Github:")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    id: gitlink
                    text: "https://github.com/REGOVAR/Regovar"
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                    MouseArea
                    {
                        anchors.fill: parent
                        cursorShape: "PointingHandCursor"
                        onClicked: Qt.openUrlExternally("https://github.com/REGOVAR/Regovar")
                        hoverEnabled: true
                        onEntered: gitlink.color = Regovar.theme.secondaryColor.back.normal
                        onExited:  gitlink.color = Regovar.theme.frontColor.normal
                    }
                }

                Text
                {
                    text: qsTr("Contact email") + " : "
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                TextEdit
                {
                    text: "dev@regovar.org"
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                    readOnly: true
                    selectByMouse: true
                    selectByKeyboard: true
                }

                Rectangle
                {
                    color: "transparent"
                    Layout.columnSpan: 2
                    height: 15
                    width: 50
                    Rectangle
                    {
                        width: 50
                        height: 1
                        anchors.verticalCenter: parent.verticalCenter
                        color: Regovar.theme.primaryColor.back.normal
                    }
                }

                Text
                {
                    text: qsTr("Next planned release")
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.bold: true
                    color: Regovar.theme.primaryColor.back.normal
                    Layout.columnSpan: 2
                }

                Text
                {
                    text: !regovar.config.release["success"] ? qsTr("Not able to retrieve information.") : ""
                    font.italic: true
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.disable
                    Layout.columnSpan: 2
                    visible: !regovar.config.release["success"]
                }


                Text
                {
                    text: qsTr("Name:")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: regovar.config.release["success"] ? regovar.config.release["title"] : ""
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }

                Text
                {
                    text: qsTr("Due on:")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    text: regovar.config.release["success"] ? parseDate(regovar.config.release["due_on"]) : ""
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal

                    function parseDate(iso)
                    {
                        var date = new Date(iso);
                        var monthNames = [
                            qsTr("january"), qsTr("february"), qsTr("march"),
                            qsTr("april"), qsTr("may"), qsTr("june"), qsTr("july"),
                            qsTr("august"), qsTr("september"), qsTr("october"),
                            qsTr("november"), qsTr("december")
                        ];

                        var day = date.getDate();
                        var monthIndex = date.getMonth();
                        var year = date.getFullYear();
                        return day + ' ' + monthNames[monthIndex] + ' ' + year;
                    }
                }

                Text
                {
                    text: qsTr("Progress:")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                Rectangle
                {
                    width: 150
                    height: Regovar.theme.font.size.normal
                    color: Regovar.theme.backgroundColor.main
                    border.width: 1
                    border.color: Regovar.theme.boxColor.border
                    Rectangle
                    {
                        x: 1
                        y: 1
                        width: (regovar.config.release["success"] ?  regovar.config.release["progress"] : 0) * 148
                        height: parent.height-2
                        color: Regovar.theme.secondaryColor.back.normal
                    }
                }

                Text
                {
                    text: qsTr("Details:")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                }
                Text
                {
                    id: nextlink
                    text: regovar.config.release["success"] ? qsTr("See on Github") : ""
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                    MouseArea
                    {
                        enabled: (regovar.config && regovar.config.release && regovar.config.release["success"]) ? true : false
                        anchors.fill: parent
                        cursorShape: "PointingHandCursor"
                        onClicked: Qt.openUrlExternally(regovar.config.release["html_url"])
                        hoverEnabled: true
                        onEntered: nextlink.color = Regovar.theme.secondaryColor.back.normal
                        onExited:  nextlink.color = Regovar.theme.frontColor.normal
                    }
                }
            }
        }
    }


    Rectangle
    {
        id: girciFrame
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        height: 120 // 100 + 20
        border.width: 1
        border.color: Regovar.theme.boxColor.border
        color: Regovar.theme.boxColor.back

        Image
        {
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.margins: 10
            height: 100
            fillMode: Image.PreserveAspectFit
            source: "qrc:/credits/logo_girci_w360.png"
        }

        Image
        {
            anchors.top : parent.top
            anchors.right: parent.right
            anchors.margins: 10
            height: 100
            fillMode: Image.PreserveAspectFit
            source: "qrc:/credits/logo_hugo_w360.png"
        }

        Text
        {
            id: girciText
            anchors.centerIn: parent
            width: 300
            text: qsTr("Free and open-source PHRCI project funded by GIRCI Grand-Ouest.<br/>(2016-2018)")
            textFormat: TextEdit.RichText
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.normal
            wrapMode: TextEdit.Wrap
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea
        {
            anchors.fill: parent
            cursorShape: "PointingHandCursor"
            onClicked: Qt.openUrlExternally("http://www.girci-go.org/GIRCI_GO/membres.html")
            hoverEnabled: true
            onEntered:
            {
                girciFrame.border.color = Regovar.theme.secondaryColor.back.normal;
                girciText.color = Regovar.theme.secondaryColor.back.normal;
            }
            onExited:
            {
                girciFrame.border.color = Regovar.theme.boxColor.border;
                girciText.color = Regovar.theme.primaryColor.back.normal;
            }

        }
    }


}
