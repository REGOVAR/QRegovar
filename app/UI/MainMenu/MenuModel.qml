import QtQuick 2.7

QtObject
{
    //! Menu page index contains the three levels of the menu
    property var selectedIndex: [0, -1, -1]

    property bool menuCollapsed: false

    property bool subLevelPanelDisplayed: false
    property bool _subLevelPanelDisplayed: false // to store current state when need to quickly/temporarly switch the level2 display on mousehover


    property var model // MUST contains the list of item in the menu. See init in xxxWindow.qml files

    property string mainTitle: model[selectedIndex[0]]["label"]
    onSelectedIndexChanged:
    {
        // Store selected subindexes to be able to restore it next
        var lvl0 = selectedIndex[0];
        var lvl1 = selectedIndex[1];
        var lvl2 = selectedIndex[2];
        model[lvl0]["subindex"] = lvl1;
        if (lvl1 >= 0)
        {
            model[lvl0]["sublevel"][lvl1]["subindex"] = lvl2;
        }

        // Update main title according to the selected section
        mainTitle = model[lvl0]["label"];
    }

    // Update selectedIndex property according to the model
    function select(level, index)
    {
        var lvl0 = -1;
        var lvl1 = -1;
        var lvl2 = -1;

        if(level === 0)
        {
            lvl0 = index;
            lvl1 = model[lvl0]["subindex"];
            if (lvl1 >= 0)
            {
                lvl2 = model[lvl0]["sublevel"][lvl1]["subindex"];
            }
        }
        else if (level === 1)
        {
            lvl0 = selectedIndex[0];
            lvl1 = index;
            if (lvl1 >= 0)
            {
                lvl2 = model[lvl0]["sublevel"][lvl1]["subindex"];
            }
        }
        else if (level === 2)
        {
            lvl0 = selectedIndex[0];
            lvl1 = selectedIndex[1];
            lvl2 = index;
        }
        else
        {
            console.log("Menu Unknow level " + level);
        }

        selectedIndex = [lvl0, lvl1, lvl2];
    }
}
