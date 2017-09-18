import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import "../Regovar"
import "../Framework"








Dialog
{
    id: sampleDialog
    title: qsTr("Select your samples")
    standardButtons: Dialog.Ok | Dialog.Cancel

    width: 500
    height: 400

//    property alias localIndex: localFiles.currentIndex
//    property alias localSelection: localFiles.selection
//    property alias remoteSampleTreeModel: remoteSamples.model
//    property alias remoteIndex: remoteSamples.currentIndex
//    property alias remoteSelection: remoteSamples.selection


    onAccepted: console.log("Ok clicked")
    onRejected: console.log("Cancel clicked")

    signal samplesSelected(var samples)



    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main
        anchors.fill: parent

        Rectangle
        {
            id: rootRemoteView
            anchors.fill: root

            Text
            {
                id: remoteLabel
                anchors.top : rootRemoteView.top
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.margins: 10

                text: qsTr("Select samples already on the server")
                font.pixelSize: Regovar.theme.font.size.control
            }

            TextField
            {
                id: remoteFilterField
                anchors.top : remoteLabel.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.margins: 10
                placeholderText: qsTr("Search sample by identifiant or vcf filename, subject's name, birthday, sex, comment, ...")
            }


            TableView
            {
                id: remoteSamples
                anchors.top : remoteFilterField.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.bottom: remoteSwitchButton.top
                anchors.margins: 10

                model: regovar.remoteSamplesList
                selectionMode: SelectionMode.ExtendedSelection
                Component.onCompleted: regovar.loadSampleBrowser(2);
                property var statusIcons: ["m", "/", "n", "h"]

                TableViewColumn { title: qsTr("Sample"); role: "name"; horizontalAlignment: Text.AlignLeft; }
                TableViewColumn
                {
                    title: "Status"
                    role: "statusUI"
                    delegate: Item
                    {

                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: remoteSamples.statusIcons[styleData.value.status]
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.label
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Subject")
                    role: "subjectUI"
                    delegate: Item
                    {

                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.sex == "M" ? "9" : styleData.value.sex == "F" ? "<" : ""
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.lastname + " " + styleData.value.firstname + "(" + styleData.value.age + ")"
                            elide: Text.ElideRight
                        }

                    }
                }
                TableViewColumn
                {
                    title: qsTr("Source")
                    role: "sourceUI"
                    delegate: Item
                    {

                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.icon
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.fill: parent
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.filename
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn { title: qsTr("Comment"); role: "comment" }
            }

            Button
            {
                id: remoteSwitchButton
                anchors.bottom : rootRemoteView.bottom
                anchors.left: rootRemoteView.left
                anchors.margins: 10

                text: qsTr("+ Import sample(s) from local file")
                onClicked:
                {
                    rootRemoteView.visible = false;
                    rootLocalView.visible = true;
                }
            }
        }


        Rectangle
        {
            id: rootLocalView
            color: Regovar.theme.backgroundColor.main

            anchors.fill: root
            visible: false



            Button
            {
                id: localSwitchButton
                anchors.bottom : rootLocalView.bottom
                anchors.left: rootLocalView.left
                anchors.margins: 10

                text: qsTr("< Back to remote samples")
                onClicked:
                {
                    rootLocalView.visible = false;
                    rootRemoteView.visible = true;
                }
            }
        }



        Button
        {
            id: okButton
            anchors.bottom : root.bottom
            anchors.right: root.right
            anchors.margins: 10

            text: qsTr("Ok")
            onClicked:
            {
                var samples=[];
                if (rootRemoteView.visible)
                {
                    remoteSamples.selection.forEach( function(rowIndex)
                    {
                        samples = samples.concat(regovar.remoteSamplesList[rowIndex]);
                    });
                    samplesSelected(samples);
                }
//                if (rootLocalView.visible)
//                {
//                    // First retrieve local files url
//                    for(var i=0; i<localFiles.selection.selectedIndexes.length; i++)
//                    {
//                        var idx = localFiles.selection.selectedIndexes[i];
//                        var url = fileSystemModel.data(idx, FileSystemModel.UrlStringRole);
//                        files = files.concat(url);
//                    }

//                    // Start tus upload for
//                    console.log("Start upload of files : " + files);
//                    regovar.enqueueUploadFile(files);

//                    // Retrieve
//                    // No need to send "fileSelected(files)" signal as the tus upload will auto add it to the inputsList
//                    // TODO : find a better way to manage it to avoid multiuser problem and so on...
//                }


                sampleDialog.accept();
            }
        }

        Button
        {
            id: cancelButton
            anchors.bottom : root.bottom
            anchors.right: okButton.left
            anchors.margins: 10
            text: qsTr("Cancel")
            onClicked: sampleDialog.reject()
        }
    }
}


