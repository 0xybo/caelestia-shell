pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config

Region {
    id: root

    required property EdgeGeometry geometry
    required property Panels panels
    required property var win

    readonly property real borderThickness: win.contentItem.Config.border.thickness
    readonly property real clampedThickness: win.contentItem.Config.border.clampedThickness

    x: geometry.insetLeft(clampedThickness, true) + win.dragMaskPadding
    y: geometry.insetTop(clampedThickness, true) + win.dragMaskPadding
    width: win.width - geometry.insetLeft(clampedThickness, true) - geometry.insetRight(clampedThickness, true) - clampedThickness - win.dragMaskPadding * 2
    height: win.height - geometry.insetTop(clampedThickness, true) - geometry.insetBottom(clampedThickness, true) - win.dragMaskPadding * 2
    intersection: Intersection.Xor

    R {
        panel: root.panels.dashboard
    }

    R {
        panel: root.panels.launcher
    }

    R {
        panel: root.panels.session
    }

    R {
        panel: root.panels.sidebar
    }

    R {
        panel: root.panels.osd
    }

    R {
        panel: root.panels.notifications
    }

    R {
        panel: root.panels.utilities
    }

    R {
        panel: root.panels.popoutsWrapper
    }

    component R: Region {
        required property Item panel

        x: panel.x + root.geometry.insetLeft(root.clampedThickness, true)
        y: panel.y + root.geometry.insetTop(root.clampedThickness, true)
        width: panel.width
        height: panel.height
        intersection: Intersection.Subtract
    }
}
