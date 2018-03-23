import QtQuick 2.9
import QtQuick.Window 2.3
import Qt.labs.settings 1.0

QtObject
{
    id: styleRoot




    property int themeId: 0
    onThemeIdChanged: loadTheme()
    Component.onCompleted: loadTheme()




    property string name: "Regovar Light Theme"
    property string description: "The official light theme of the Regovar client"

    property FontLoader icons: FontLoader { source: "../Icons.ttf" }
    property real fontSizeCoeff: 1.0

    property QtObject font: QtObject
    {
        property string family : "Sans"

        property QtObject size: QtObject
        {
            property real title : 5.0 * Screen.pixelDensity * fontSizeCoeff
            property real header : 4.0 * Screen.pixelDensity * fontSizeCoeff
            property real normal : 3.0 * Screen.pixelDensity * fontSizeCoeff
            property real small : 2.5 * Screen.pixelDensity * fontSizeCoeff
        }
        property QtObject boxSize: QtObject
        {
            property real title : 5.0 * Screen.pixelDensity * 2 * fontSizeCoeff
            property real header : 4.0 * Screen.pixelDensity * 2 * fontSizeCoeff
            property real normal : 3.0 * Screen.pixelDensity * 2 * fontSizeCoeff
            property real small : 2.5 * Screen.pixelDensity * 2 * fontSizeCoeff
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
        property color alt: "#e7e7e7"
        property color header1: "#fcfcfd"
        property color header2: "#e7e7e7"
        property color front: "#000000"
        property color placeholder: "#babdb6"
        property color border: "#d9d9df"
        property color disabled : "#999999"
    }

    property QtObject backgroundColor: QtObject
    {
        property color main: "#efeff1"
        property color alt: "#e4e4e8"
        property color overlay: "#aaffffff"
    }

    property QtObject frontColor: QtObject
    {
        property color normal: "#000000"
        property color disable: "#999999"
        property color info: "#6887ff"
        property color success : "#6cc788"
        property color warning : "#ff9b28"
        property color danger : "#f44455"
    }

    property QtObject logo: QtObject
    {
        property color color1: "#80d6ff"
        property color color2: "#0077c2"
    }

    property QtObject filtering: QtObject
    {
        property color seqA: "#3264C8"
        property color seqC: "#C85050"
        property color seqG: "#64C878"
        property color seqT: "#E6A03C"
        property color filterAND: "#3770cc"
        property color filterOR: "#37cc77"
        property color filterXOR: "#cc3737"
    }




    onFontSizeCoeffChanged:
    {
        // TODO / FIXME : why only font.size.title is auto updated onchanged ?
        // need to reset manually other value...
        font.size.header = 4.0 * Screen.pixelDensity * fontSizeCoeff;
        font.size.normal = 3.0 * Screen.pixelDensity * fontSizeCoeff;
        font.size.small = 2.5 * Screen.pixelDensity * fontSizeCoeff;
    }





    function addTransparency(color, opacity)
    {
        // remove
        color = color.replace(/^#/, '');
        opacity = Math.floor(opacity == 1.0 ? 255 : opacity * 256.0);
        return "#" + opacity.toString(16) + color;
    }


    function lighter(color, coeff)
    {
        var trueCoeff = (typeof coeff !== 'undefined') ? coeff : 1.5;
        return Qt.lighter(color, trueCoeff)
    }

    function darker(color, coeff)
    {
        var trueCoeff = (typeof coeff !== 'undefined') ? coeff : 1.5;
        return Qt.darker(color, trueCoeff)
    }



    function loadTheme()
    {
        var xhr = new XMLHttpRequest;
        var themes = ["RegovarLightTheme.js", "RegovarDarkTheme.js", "HalloweenTheme.js"];
        var path = Qt.resolvedUrl(".") + "Themes/" + themes[styleRoot.themeId];
        console.log("Loading theme " + styleRoot.themeId + " : " + path);
        xhr.open("GET", path);
        xhr.onreadystatechange = function()
        {
            if (xhr.readyState === XMLHttpRequest.DONE)
            {
                var themeData = JSON.parse(xhr.responseText);

                styleRoot.name = themeData.name;
                styleRoot.description = themeData.description;

                styleRoot.font.family = themeData.font.family;

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
                styleRoot.boxColor.alt = themeData.boxColor.alt;
                styleRoot.boxColor.header1 = themeData.boxColor.header1;
                styleRoot.boxColor.header2 = themeData.boxColor.header2;
                styleRoot.boxColor.front = themeData.boxColor.front;
                styleRoot.boxColor.placeholder = themeData.boxColor.placeholder;
                styleRoot.boxColor.border = themeData.boxColor.border;
                styleRoot.boxColor.disabled = themeData.boxColor.disabled;

                styleRoot.backgroundColor.main = themeData.backgroundColor.main;
                styleRoot.backgroundColor.alt = themeData.backgroundColor.alt;
                styleRoot.backgroundColor.overlay = themeData.backgroundColor.overlay;

                styleRoot.frontColor.normal = themeData.frontColor.normal;
                styleRoot.frontColor.disable = themeData.frontColor.disable;
                styleRoot.frontColor.info = themeData.frontColor.info;
                styleRoot.frontColor.success = themeData.frontColor.success;
                styleRoot.frontColor.warning = themeData.frontColor.warning;
                styleRoot.frontColor.danger = themeData.frontColor.danger;

                styleRoot.logo.color1 = themeData.logo.color1;
                styleRoot.logo.color2 = themeData.logo.color2;

                styleRoot.filtering.seqA = themeData.filtering.seqA;
                styleRoot.filtering.seqC = themeData.filtering.seqC;
                styleRoot.filtering.seqG = themeData.filtering.seqG;
                styleRoot.filtering.seqT = themeData.filtering.seqT;
                styleRoot.filtering.filterAND = themeData.filtering.filterAND;
                styleRoot.filtering.filterOR = themeData.filtering.filterOR;
                styleRoot.filtering.filterXOR = themeData.filtering.filterXOR;
            }
        }
        xhr.send();
    }
}

