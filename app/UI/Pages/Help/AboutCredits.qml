import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../../Regovar"

Item
{
    id: root


    ListModel
    {
        id: thanksToModel

        ListElement
        {
            name: "Anne-Sophie DENOMMÉ-PICHON"
            comment: qsTr("Doctor, Geneticist, Bioinformaticist, Developper")
            icon: "qrc:/credits/u_asdp.jpg"
            url: "https://github.com/Oodnadatta"
        }
        ListElement {
            name: "David GOUDEGÈNE"
            comment: qsTr("Bioinformaticist, Developper")
            icon: "qrc:/credits/u_dg.jpg"
            url: "https://github.com/dooguypapua"
        }
        ListElement {
            name: "Jérémie ROQUET"
            comment: qsTr("Computer scientist, Linux guru, Developper")
            icon: "qrc:/credits/u_jr.jpg"
            url: "https://github.com/Arkanosis"
        }
        ListElement {
            name: "June SALLOU"
            comment: qsTr("Bioinformaticist, Developper")
            icon: "qrc:/credits/u_js.jpg"
            url: "https://github.com/Jnsll"
        }
        ListElement {
            name: "Olivier GUEUDELOT"
            comment: qsTr("Computer scientist, Developper")
            icon: "qrc:/credits/u_og.png"
            url: "https://github.com/ikit"
        }
        ListElement {
            name: "Sacha SCHUTZ"
            comment: qsTr("Doctor, Geneticist, Bioinformaticist, Developper")
            icon: "qrc:/credits/u_ss.jpg"
            url: "https://github.com/dridk"
        }
    }
    ListModel
    {
        id: toolsModel

        ListElement
        {
            name: "Github"
            comment: qsTr("Web-based Git version control repository")
            icon: "qrc:/credits/t_git.png"
            url: "https://github.com/REGOVAR"
        }
        ListElement {
            name: "HGNC"
            comment: qsTr("HUGO Gene Nomenclature Committee")
            icon: "qrc:/credits/t_hgnc.png"
            url: "https://www.genenames.org/"
        }
        ListElement {
            name: "HPO"
            comment: qsTr("Human Phenotype Ontology")
            icon: "qrc:/credits/t_hpo.png"
            url: "http://human-phenotype-ontology.github.io/"
        }
        ListElement {
            name: "OMIM"
            comment: qsTr("Online Mendelian Inheritance in Man")
            icon: "qrc:/credits/t_omim.jpg"
            url: "https://www.omim.org/"
        }
        ListElement {
            name: "ORPHANET"
            comment: qsTr("Maladies rares et médicaments orphelins")
            icon: "qrc:/credits/t_orphanet.jpg"
            url: "http://www.orpha.net/"
        }
    }
    ListModel
    {
        id: technologiesModel

        ListElement
        {
            name: "C++ 11"
            comment: qsTr("Regovar client application")
            icon: "qrc:/credits/t_cpp.png"
            url: "http://www.cplusplus.com/"
        }
        ListElement
        {
            name: "PostgresSQL 9.6"
            comment: qsTr("Regovar server database")
            icon: "qrc:/credits/t_postgresql.png"
            url: "https://www.postgresql.org/"
        }
        ListElement {
            name: "Python 3.6"
            comment: qsTr("Regovar server application")
            icon: "qrc:/credits/t_python.png"
            url: "https://www.python.org/"
        }
        ListElement {
            name: "Qt 5.9 / QML"
            comment: qsTr("Regovar client UI framework")
            icon: "qrc:/credits/t_qt.png"
            url: "https://www.qt.io/"
        }
    }





    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5


        Text
        {
            height: Regovar.theme.font.boxSize.header
            text: qsTr("Thanks to")
            font.pixelSize: Regovar.theme.font.size.header
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
        }

        GridView
        {
            id: thanksToGrid
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: thanksToModel
            cellWidth: 300
            cellHeight: 80

            delegate: Item
            {
                width: thanksToGrid.cellWidth
                height: thanksToGrid.cellHeight
                InfoCard
                {
                    anchors.fill: parent
                    anchors.margins: 5

                    title: name
                    text: comment
                    iconSource: icon
                    url: model.url
                }
            }
        }

        Rectangle
        {
            color: "transparent"
            Layout.columnSpan: 2
            height: 15
            width: 50
            Rectangle
            {
                width: 50
                height: 1
                anchors.verticalCenter: parent.verticalCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }


        Text
        {
            height: Regovar.theme.font.boxSize.header
            text: qsTr("Tools")
            font.pixelSize: Regovar.theme.font.size.header
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
        }

        GridView
        {
            id: toolsGrid
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: toolsModel
            cellWidth: 300
            cellHeight: 80

            delegate: Item
            {
                width: toolsGrid.cellWidth
                height: toolsGrid.cellHeight
                InfoCard
                {
                    anchors.fill: parent
                    anchors.margins: 5

                    title: name
                    text: comment
                    iconSource: icon
                    url: model.url
                }
            }
        }


        Rectangle
        {
            color: "transparent"
            Layout.columnSpan: 2
            height: 15
            width: 50
            Rectangle
            {
                width: 50
                height: 1
                anchors.verticalCenter: parent.verticalCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }

        Text
        {
            height: Regovar.theme.font.boxSize.header
            text: qsTr("Technologies")
            font.pixelSize: Regovar.theme.font.size.header
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
        }

        GridView
        {
            id: technologieGrid
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: technologiesModel
            cellWidth: 300
            cellHeight: 80

            delegate: Item
            {
                width: technologieGrid.cellWidth
                height: technologieGrid.cellHeight
                InfoCard
                {
                    anchors.fill: parent
                    anchors.margins: 5

                    title: name
                    text: comment
                    iconSource: icon
                    url: model.url
                }
            }
        }
    }
}
