import QtQuick
import qs.modules.drawers as Drawers

Item {
    id: root

    readonly property Drawers.Panel panel: root.parent as Drawers.Panel

    function containsMouse(x: real, y: real): bool {
        for (const child of root.children) {
            if (!child.visible)
                continue;
            if ("containsMouse" in child && child.containsMouse(x, y))
                return true;
        }
        return false;
    }

    anchors.fill: panel
}
