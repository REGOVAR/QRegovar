pragma Singleton
import QtQuick 2.5

QtObject {

/*  TEMPORARY.. WILL BE REPLACE BY ATTACHED PROPERTY */

    property color primary : "#0CC2AA"
    property color accent : "#A88ADD"
    property color warn : "#FCC100"
    property color info: "#6887FF"
    property color success : "#6CC788"
    property color warning : "#F77A99"
    property color danger : "#F44455"

    property color dark : "#2E3E4E"
    property color light : "#F8F8F8"
    property color black : "#2A2B3C"



    function lighter(color) {
        return Qt.lighter(color, 1.3)
    }

    function darker(color){
        return Qt.darker(color, 1.3)
    }


}

