pragma Singleton
import QtQuick 2.9
import Qt.labs.settings 1.0
import Regovar.Core 1.0


import "qrc:/qml/MainMenu"
import "qrc:/qml/Pages"

QtObject 
{
    id: uiModel
    /*! This QML model is the global "view model" of the application
     *  It manage only data use for  the UI (like the selected entry in the main menu and so on
     *  The "True" model of the application is done in C++, see /Model/Regovar singleton
     *  accessible in the QML by the id "regovar"
     */




    //! Collection of sub windows
    property var openAnalysisWindows;

    //! The theme applied to the UI
    property Style theme: Style {}

    //! Indicates if need to display help information's box in the UI
    property bool helpInfoBoxDisplayed: true



    property var seqColorMapCss : ({
        'A':'<span style="color:'+ theme.filtering.seqA +'">A</span>',
        'C':'<span style="color:'+ theme.filtering.seqC +'">C</span>',
        'G':'<span style="color:'+ theme.filtering.seqG +'">G</span>',
        'T':'<span style="color:'+ theme.filtering.seqT +'">T</span>'})

    function formatSequence(seq)
    {
        var html = "";
        for (var i=0; i<seq.length; i++)
        {
            html += seqColorMapCss[seq[i]];
        }
        return html;
    }

    function round(number, length)
    {
        if (number)
        {
            var coeff = Math.pow(10,length);
            var rounded = Math.round(number * coeff) / coeff;
            rounded = rounded.toString()
            while (rounded.endsWith("0"))
            {
                rounded = rounded.substr(0,rounded.length-1);
            }
            if (rounded.endsWith("."))
            {
                rounded = rounded.substr(0,rounded.length-1);
            }
            return rounded;
        }
        return 0;
    }


    // SPECIFIC TOOLS

    property var sexToIconMap: ({"male": "9", "female": "<", "2": "9", "1": "<", "Male": "9", "Female": "<"})
    function sexToIcon(sex)
    {
        if (sex in sexToIconMap)
        {
            return sexToIconMap[sex];
        }
        return "b";
    }


} 
