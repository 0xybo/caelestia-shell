pragma ComponentBehavior: Bound

import QtQuick
import qs.services
import qs.modules.drawers as Drawers

Item {
    id: root

    readonly property Drawers.Trigger trigger: parent as Drawers.Trigger
    readonly property Drawers.Panel panel: trigger.panel

    property bool debug: ShellState.debug
    property bool active: true
    property bool invert: false

    function containsMouse(x: real, y: real): bool {
        return x >= root.x && x <= root.x + root.width && y >= root.y && y <= root.y + root.height;
    }

    visible: root.active

    Loader {
        active: root.debug && root.active

        anchors.fill: parent

        sourceComponent: Rectangle {
            anchors.fill: parent
            color: {
                // generate a color based on the trigger name so that each trigger has a unique color (random with seed based on the trigger name)
                // Invert the color if the trigger is inverted so that it is easier to see the difference between the two
                const triggerName = root.panel.name;
                const hash = triggerName.split('').reduce((hash, char) => {
                    return char.charCodeAt(0) + ((hash << 5) - hash);
                }, 0);
                const r = (hash & 0xFF0000) >> 16;
                const g = (hash & 0x00FF00) >> 8;
                const b = hash & 0x0000FF;

                if (root.invert)
                    return Qt.rgba(1 - r / 255, 1 - g / 255, 1 - b / 255, 0.25);
                return Qt.rgba(r / 255, g / 255, b / 255, 0.25);
            }
        }
    }
}
