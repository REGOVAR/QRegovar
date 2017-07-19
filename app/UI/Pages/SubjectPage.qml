import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as OLD
import QtQml.Models 2.2


import "../Regovar"
import "../Framework"
import "../Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main



    SelectFilesDialog
    {
        id: filePopup
        visible: false

        onAccepted:
        {
            console.log(filePopup.localSelection)
        }
    }


    Button
    {
        text: "click"
        onClicked:
        {
            filePopup.open()
        }
    }





}

