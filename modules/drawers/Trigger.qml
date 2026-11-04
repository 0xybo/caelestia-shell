pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.modules.drawers as Drawers

Item {
    id: root

    readonly property Drawers.Panel panel: parent as Drawers.Panel

    function containsMouse(x: real, y: real): bool {
        const win = QsWindow.window as QsWindow;
        if (!win)
            return false;

        const pos = root.mapFromItem(win.contentItem, x, y);

        let contains = false;
        for (const child of root.children) {
            if (!(child instanceof Drawers.TriggerPart))
                continue;

            if (!child.active)
                continue;
            if (child.containsMouse(pos.x, pos.y))
                if (child.invert)
                    return false;
                else
                    contains = true;
        }

        return contains;
    }

    anchors.fill: parent
}
