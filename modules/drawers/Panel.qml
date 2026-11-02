import QtQuick
import qs.modules.drawers as Drawers

Item {
    id: root

    required property string name
    required property Item content
    required property Drawers.Trigger trigger
    required property real offsetScale

    // readonly property Item content: root.children[0] as Item
    // readonly property Trigger trigger: root.children[1] as Trigger
    // readonly property real offsetScale: content.offsetScale
    readonly property bool opened: root.offsetScale === 0
    readonly property bool closed: root.offsetScale === 1

    function isVisible(yes: var, no: var): var {
        return !root.closed ? yes : no;
    }
}
