import QtQuick
import qs.modules.drawers as Drawers

Item {
    id: root

    property bool debug: false
    property bool active: true

    readonly property Drawers.Trigger trigger: root.parent as Drawers.Trigger
    readonly property Drawers.Panel panel: root.trigger.panel as Drawers.Panel

    function containsMouse(x: real, y: real): bool {
        return x >= root.x && x <= root.x + root.width && y >= root.y && y <= root.y + root.height;
    }

    visible: active

    Loader {
        active: root.debug

        anchors.fill: parent

        sourceComponent: Item {
            Rectangle {
                anchors.fill: parent
                color: '#32ff00ff'
            }
        }
    }
}
