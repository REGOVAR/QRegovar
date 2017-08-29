import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"
import "../../../Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        if (model !== undefined)
        {
            addSampleDialog.remoteSampleTreeModel = model.remoteSamples;
        }
    }

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            text: qsTr("Analysis samples configuration")
            font.pixelSize: 20
            font.weight: Font.Black
        }
    }

    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        mainColor: Regovar.theme.frontColor.success
        icon: "f"
        text: qsTr("Add new or existing samples to your analysis. You can also set several attributes to the samples to allow you advanced filtering options.")
    }

    // Side actions button bar
    ColumnLayout
    {
        id: actionsPanel
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            id: addSample
            text: qsTr("Add sample")
            Layout.fillWidth: true
            onClicked:  addSampleDialog.open()
        }

        Button
        {
            id: removeSample
            text: qsTr("Remove sample")
            Layout.fillWidth: true
            onClicked: removeSelectedSample()
        }

        Rectangle
        {
            height:20
            color: "transparent"
            Layout.fillWidth: true
        }

        Button
        {
            id: addAttribute
            enabled: false
            text: qsTr("Add attribute")
            Layout.fillWidth: true
            onClicked: addAttributeDialog.open()
        }

        Button
        {
            id: removeAttribute
            text: qsTr("Remove attribute")
            Layout.fillWidth: true
            onClicked: removeAttributeDialog.open()
        }
    }



    TableView
    {
        anchors.top : Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : root.bottom
        anchors.left: root.left
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10

        model: sampleModel

        TableViewColumn
        {
            role: "identifiant"
            title: qsTr("Identifiant")
            width: 100
        }
        TableViewColumn
        {
            role: "subject"
            title: qsTr("Subject")
            width: 200
        }
        TableViewColumn
        {
            role: "status"
            title: qsTr("Status")
            width: 100
        }
        TableViewColumn
        {
            role: "sex"
            title: qsTr("Sex")
            width: 30
        }
        TableViewColumn
        {
            role: "attr_1"
            title: qsTr("Custom attribute")
            width: 100
        }
    }


    SelectSamplesDialog
    {
        id: addSampleDialog
        visible: false

        onAccepted:
        {
            addSelectedSamples();
        }
    }



    ListModel
    {
        id: sampleModel
        ListElement {
            db_id: 12
            identifiant: "sp_156-32"
            subject: "Michel Dupont (32y)"
            status: "done"
            mother: -1
            father: -1
            sex: "M"
            attr_1: "custom value"
        }
        ListElement {
            db_id: 13
            identifiant: "sp_156-32"
            subject: "Micheline Dupont (32y)"
            status: "done"
            mother:"-"
            father: "-"
            sex: "F"
            attr_1: "custom value"
        }
        ListElement {
            db_id: 14
            identifiant: "sp_156-32"
            subject: "Michou Dupont (M - 3y)"
            status: "importing"
            progress: "0.682"
            mother: 13
            father: 12
            sex: "M"
            attr_1: "custom value"
        }
    }




    //! Add samples selected in the "addSampleDialog" Dialog
    function addSelectedSamples()
    {
        // TODO : manage multiple selection
        var sampleIdRole = Qt.UserRole +1 // enum value of RemoteSampleTreeModel.ColumnRole.sampleIdRole
        var sampleId = model.remoteSamples.data(remoteIndex, sampleIdRole);
        console.log("Add selected sample (" + sampleId + ") to the analysis");
    }

    //! Remove samples selected in the sample tree view
    function removeSelectedSamples()
    {
        // TODO : manage multiple selection
        var sampleIdRole = Qt.UserRole +1 // enum value of RemoteSampleTreeModel.ColumnRole.sampleIdRole
        var sampleId = model.remoteSamples.data(remoteIndex, sampleIdRole);
        console.log("remove selected sample (" + sampleId + ") to the analysis");
    }
}
