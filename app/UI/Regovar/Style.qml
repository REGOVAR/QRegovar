import QtQuick 2.7

QtObject
{
    id: styleRoot

    property string load: "RegovarLight"
    onLoadChanged: loadStyle()




    property string name: "Regovar Light Theme"
    property string description: "The official light theme of the Regovar client"

    property QtObject font: QtObject
    {
        property string familly : "Sans"
        property QtObject size: QtObject
        {
            property int header : 16
            property int control : 12
            property int content : 11
         }
    }

    property QtObject primaryColor: QtObject
    {
        property QtObject back: QtObject
        {
            property color light: "#819ca9"
            property color normal: "#546e7a"
            property color dark: "#29434e"
         }
        property QtObject front: QtObject
        {
            property color light: "#000000"
            property color normal: "#ffffff"
            property color dark: "#ffffff"
         }
    }

    property QtObject secondaryColor: QtObject
    {
        property QtObject back: QtObject
        {
            property color light: "#80d6ff"
            property color normal: "#42a5f5"
            property color dark: "#0077c2"
         }
        property QtObject front: QtObject
        {
            property color normal: "#ffffff"
            property color light: "#000000"
            property color dark: "#ffffff"
         }
    }

    property QtObject boxColor: QtObject
    {
        property color back: "#ffffff"
        property color front: "#000000"
        property color placeholder: "#babdb6"
        property color border: "#d9d9df"
        property color disabled : "#999999"
    }

    property QtObject backgroundColor: QtObject
    {
        property color main: "#efeff1"
        property color alt: "#e4e4e8"
    }

    property QtObject frontColor: QtObject
    {
        property color normal: "#000000"
        property color info: "#6887ff"
        property color success : "#6cc788"
        property color warning : "#f77a99"
        property color danger : "#f44455"
    }





    function lighter(color)
    {
        return Qt.lighter(color, 1.3)
    }

    function darker(color)
    {
        return Qt.darker(color, 1.3)
    }

    function loadStyle()
    {
        console.log(__filename);
    }
}

