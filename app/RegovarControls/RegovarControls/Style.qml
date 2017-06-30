pragma Singleton
import QtQuick 2.7

QtObject
{
    //  TEMPORARY.. WILL BE REPLACE BY ATTACHED PROPERTY

    property string fontFamilly : "Sans"
    property int fontSizeHeader : 16
    property int fontSizeControl : 12
    property int fontSizeContent : 10

    property color primaryBackColor: "#546e7a"
    property color primaryFrontColor: "#ffffff"
    property color primaryLightBackColor: "#819ca9"
    property color primaryLightFrontColor: "#000000"
    property color primaryDarkBackColor: "#29434e"
    property color primaryDarkFrontColor: "#ffffff"

    property color secondaryBackColor: "#42a5f5"
    property color secondaryFrontColor: "#ffffff"
    property color secondaryLightBackColor: "#80d6ff"
    property color secondaryLightFrontColor: "#000000"
    property color secondaryDarkBackColor: "#0077c2"
    property color secondaryDarkFrontColor: "#ffffff"

    property color backgroundColor: "#efeff1"
    property color background2Color: "#e4e4e8"
    property color mainFontColor: "#000000"

    property color boxBackColor: "#ffffff"
    property color boxFrontColor: "#000000"
    property color boxPlaceholderColor: "#babdb6"
    property color boxBorderColor: "#d9d9df"


    property color infoColor: "#6887FF"
    property color successColor : "#6CC788"
    property color warningColor : "#F77A99"
    property color dangerColor : "#F44455"

    function lighter(color) {
        return Qt.lighter(color, 1.3)
    }

    function darker(color){
        return Qt.darker(color, 1.3)
    }
}

