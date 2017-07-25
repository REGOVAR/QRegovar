import QtQuick 2.7

QtObject
{
    id: styleRoot

    property string themeId: "RegovarLightTheme"
    onThemeIdChanged: loadStyle()
    Component.onCompleted: loadStyle()



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



    function addTransparency(color, opacity)
    {
        // remove
        color = color.replace(/^#/, '');
        opacity = Math.floor(opacity == 1.0 ? 255 : opacity * 256.0);
        return "#" + opacity.toString(16) + color;
    }


//    function lighter(color)
//    {
//        return Qt.lighter(color, 1.3)
//    }

//    function darker(color)
//    {
//        return Qt.darker(color, 1.3)
//    }


    function loadStyle()
    {
        var xhr = new XMLHttpRequest;
        var path = Qt.resolvedUrl(".") + "Themes/" + styleRoot.themeId + ".js";
        console.log("Loading theme " + styleRoot.themeId + " : " + path);
        xhr.open("GET", path);
        xhr.onreadystatechange = function()
        {
            if (xhr.readyState === XMLHttpRequest.DONE)
            {
                var themeData = JSON.parse(xhr.responseText);

                styleRoot.name = themeData.name;
                styleRoot.description = themeData.description;

                styleRoot.font.familly = themeData.font.familly;
                styleRoot.font.size.header = themeData.font.size.header;
                styleRoot.font.size.control = themeData.font.size.control;
                styleRoot.font.size.content = themeData.font.size.content;

                styleRoot.primaryColor.back.light = themeData.primaryColor.back.light;
                styleRoot.primaryColor.back.normal = themeData.primaryColor.back.normal;
                styleRoot.primaryColor.back.dark = themeData.primaryColor.back.dark;
                styleRoot.primaryColor.front.light = themeData.primaryColor.front.light;
                styleRoot.primaryColor.front.normal = themeData.primaryColor.front.normal;
                styleRoot.primaryColor.front.dark = themeData.primaryColor.front.dark;

                styleRoot.secondaryColor.back.light = themeData.secondaryColor.back.light;
                styleRoot.secondaryColor.back.normal = themeData.secondaryColor.back.normal;
                styleRoot.secondaryColor.back.dark = themeData.secondaryColor.back.dark;
                styleRoot.secondaryColor.front.light = themeData.secondaryColor.front.light;
                styleRoot.secondaryColor.front.normal = themeData.secondaryColor.front.normal;
                styleRoot.secondaryColor.front.dark = themeData.secondaryColor.front.dark;

                styleRoot.boxColor.back = themeData.boxColor.back;
                styleRoot.boxColor.front = themeData.boxColor.front;
                styleRoot.boxColor.placeholder = themeData.boxColor.placeholder;
                styleRoot.boxColor.border = themeData.boxColor.border;
                styleRoot.boxColor.disabled = themeData.boxColor.disabled;

                styleRoot.backgroundColor.main = themeData.backgroundColor.main;
                styleRoot.backgroundColor.alt = themeData.backgroundColor.alt;

                styleRoot.frontColor.normal = themeData.frontColor.normal;
                styleRoot.frontColor.info = themeData.frontColor.info;
                styleRoot.frontColor.success = themeData.frontColor.success;
                styleRoot.frontColor.warning = themeData.frontColor.warning;
                styleRoot.frontColor.danger = themeData.frontColor.danger;

            }
        }
        xhr.send();
    }
}

