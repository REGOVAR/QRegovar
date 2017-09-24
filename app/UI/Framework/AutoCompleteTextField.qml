import QtQuick 2.7
import QtQuick.Controls 2.2
import "../Regovar"


Rectangle
{
    id: root
    implicitWidth: 200
    implicitHeight: Regovar.theme.font.boxSize.control
    color: "blue"

    property alias placeholderText: textField.placeholderText
    property var model
    onModelChanged: initModel()


    TextField
    {
        id: textField
        anchors.left: root.left
        anchors.right: indicatorArea.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        onTextEdited: searchFor(text)

    }

    Rectangle
    {
        id: indicatorArea
        anchors.right: root.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Regovar.theme.font.boxSize.control

        color: "red"

        MouseArea
        {
            anchors.fill: parent
            onClicked: if (popup.visible) {popup.close();} else { popup.open();}
        }
    }

    Popup
    {
        id: popup
        x: 0
        y: root.height

        implicitWidth: root.implicitWidth
        height: proposalsList.height
        width: proposalsList.width
        modal: false
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        ListView
        {
            id: proposalsList
            anchors.top: popup.top
            anchors.left: popup.left
            height: maxPopupHeight
            width: 350

            delegate: Text
            {
                text: model.modelData.name + " " + index
            }
        }
    }


    property int maxPopupHeight: 100
    property var searchingList

    function cleanWord(word)
    {
        if (word)
        {
            return word.toLowerCase().trim();
        }
        return "";
    }

    function initModel()
    {
        searchingList = [];
        for (var idx=0; idx<model.length; idx++)
        {
            searchingList.concat(cleanWord(model[idx].note) + " " + cleanWord(model[idx].name));
        }

        proposalsList.model = root.model;
    }

    function searchFor(text)
    {
        var toSearch = cleanWord(text);
        for (var idx=0; idx<searchingList.length; idx++)
        {
            root.model[idx].visible = searchingList[idx].search(toSearch) > -1;
        }
        popup.visible = true;
    }
}
