import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts 1.3

ToolButton {
    property var customColor: Material.Blue
    property var defaultColor: undefined
    property bool activated: false
    id: toolButton
    icon.source: menuItemIcon
    text: qsTr(menuItemName)
    font.family: "Segoe UI"
    //font.bold: true
    antialiasing: true
    display: AbstractButton.TextUnderIcon
    Material.foreground: activated ? customColor : defaultColor
}

