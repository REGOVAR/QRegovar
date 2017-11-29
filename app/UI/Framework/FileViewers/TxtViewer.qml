import QtQuick 2.9
import QtQuick.Controls 2.2
import org.regovar 1.0

TextField
{
    id: root
    property File file
    onFileChanged:
    {
        root.text = file.readFile();
    }

}
