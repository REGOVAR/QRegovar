import QtQuick 2.9
import QtQuick.Controls 2.2
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"


Rectangle
{
    id: root
    implicitWidth: 200
    implicitHeight: textField.implicitHeight
    color: "blue"

    property alias text: textField.text
    property alias placeholder: textField.placeholder
    property int proposalContextWidth: 100
    property var model
    property int maxPopupHeight: 200
    onModelChanged: initModel()

    property QtObject selectedItem

    TextField
    {
        id: textField
        anchors.fill: parent

        onTextEdited: searchFor(text)
        iconRight: popup.visible ? "|" : "["

        onFocusChanged:
        {
            if (focus)
            {
                searchFor(text);
            }
        }

        Keys.onPressed:
        {
            if (event.key == Qt.Key_Down)
            {
                proposalsList.forceActiveFocus();
                proposalsList.currentIndex = 0;
                proposalsList.focus = true;
            }
        }

    }

//    Rectangle
//    {
//        id: indicatorArea
//        anchors.right: root.right
//        anchors.top: parent.top
//        anchors.bottom: parent.bottom
//        width: Regovar.theme.font.boxSize.normal

//        color: "transparent" // Regovar.theme.boxColor.back
////        border.width: 1
////        border.color: textField.focus ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.border

////        Text
////        {
////            anchors.centerIn: parent
////            text: popup.visible ? "|" : "["
////            font.family: Regovar.theme.icons.name
////            color: textField.focus ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.front
////        }

//        MouseArea
//        {
//            anchors.fill: parent
//            hoverEnabled: true
//            onEntered: textField.iconRightColor = Regovar.theme.secondaryColor.back.normal
//            onExited: textField.iconRightColor = Regovar.theme.boxColor.front
//            onClicked: if (popup.visible) { popup.close();} else { popup.open();}
//        }
//    }

    Popup
    {
        id: popup
        x: 0
        y: root.height
        padding: 0
        implicitWidth: root.implicitWidth
        height: proposalsList.height+2
        width: proposalsList.width+2
        modal: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent



        //onVisibleChanged: proposalsList.highlightItem = undefined

        ListView
        {
            id: proposalsList
            x:1
            y:1
            height: maxPopupHeight
            width: root.width
            clip: true
            smooth: false

            property int desiredSize: 300
            //onDesiredSizeChanged:  width = Math.max(root.width-2, desiredSize)

            highlight: Rectangle
            {
                color: Regovar.theme.secondaryColor.back.light;
                y: list.currentItem.y
            }

            delegate: Item
            {
                id: delegateItem
                visible: model.modelData.visible
                height: (visible) ? Regovar.theme.font.boxSize.normal : 0
                width: proposalsList.width
                //color: model.modelData.trueIndex % 2 == 0 ? Regovar.theme.backgroundColor.main : Regovar.theme.boxColor.back


                Text
                {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: model.modelData.text
                    verticalAlignment: Text.AlignVCenter
                    onWidthChanged: proposalsList.desiredSize = Math.max(width + root.proposalContextWidth, proposalsList.desiredSize)
                    wrapMode: Text.WordWrap
                }
                Text
                {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    width: root.proposalContextWidth
                    text: model.modelData.context
                    color: Regovar.theme.frontColor.disable
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                }
                MouseArea
                {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: proposalsList.currentIndex = index
                    onClicked:
                    {
                        textField.text = model.modelData.text;
                        popup.close();
                        root.selectedItem = itemFromIndex(index);
                    }
                }
            }
        }
    }

    Component
    {
        id: proposalListElement
        QtObject
        {
            property bool visible: true
            property int index: 0
            property int trueIndex: 0
            property string text: ""
            property string context: ""
            property string searchString: ""
        }
    }


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
        if (model != undefined)
        {
            var lst = [];
            for (var idx=0; idx<model.length; idx++)
            {
                var elmt = proposalListElement.createObject(root, {
                    "index" : idx,
                    "visible" : true,
                    "trueIndex" : idx,
                    "text" : model[idx].name,
                    "context": model[idx].dbName + " " + model[idx].version,
                    "searchString" : cleanWord(model[idx].dbName + "." +  model[idx].name+ " " + model[idx].description)
                });
                lst = lst.concat(elmt);
            }
            proposalsList.model = lst;
        }
    }


    function searchFor(text)
    {
        var toSearch = cleanWord(text);
        var trueIdx = 0;
        for (var idx=0; idx<proposalsList.model.length; idx++)
        {
            if (proposalsList.model[idx].searchString.search(toSearch) > -1)
            {
                proposalsList.model[idx].visible = true;
                proposalsList.model[idx].trueIndex = trueIdx;
                ++trueIdx;
            }
            else
            {
                proposalsList.model[idx].visible = false;
            }
        }
        popup.visible = true;
        textField.forceActiveFocus();
    }

    function itemFromText(text)
    {
        var toSearch = cleanWord(textField.text);
        for (var idx=0; idx<proposalsList.model.length; idx++)
        {
            if (proposalsList.model[idx].searchString.search(toSearch) > -1)
            {
                return model[idx];
            }
        }
        return null;
    }
    function itemFromIndex(idx)
    {
        if (idx >=0 && idx < proposalsList.model.length)
        {
            return model[idx];
        }
        return null;
    }

    function updateSelection()
    {
        if (proposalsList.highlightItem == undefined)
        {
            // 1- If editing (= textfield focus) : check that highlighted item exist in proposal list other select first proposal
            if (textField.focus)
            {

            }
            // 2- If no more editing : if textfield.text doesn't exists in proposal, invalidate it
            else
            {
                //if ()
                root.selectedItem = null;
                textField.color = Regovar.theme.frontColor.danger;
            }
        }
    }
}
