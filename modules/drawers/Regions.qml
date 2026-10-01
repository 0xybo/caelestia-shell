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
        x: root.geometry.dashboardOnRight ? root.win.width - width : root.geometry.dashboardOnLeft ? 0 : panel.x + root.geometry.insetLeft(root.borderThickness)
        y: root.geometry.dashboardOnTop ? 0 : panel.y + root.geometry.insetTop(root.borderThickness)
        width: root.geometry.dashboardOnTop ? panel.width : panel.width * (1 - root.panels.dashboard.offsetScale) + (root.geometry.dashboardOnLeft ? root.geometry.insetLeft(root.borderThickness) : root.geometry.insetRight(root.borderThickness))
        height: root.geometry.dashboardOnTop ? panel.height * (1 - root.panels.dashboard.offsetScale) + root.geometry.insetTop(root.borderThickness) : panel.height
    }

    R {
        panel: root.panels.launcher
        y: root.win.height - height
        height: panel.height * (1 - root.panels.launcher.offsetScale) + root.geometry.insetBottom(root.borderThickness)
    }

    R {
        id: sessionRegion

        panel: root.panels.sessionWrapper
        x: root.geometry.sidebarOnLeft ? 0 : root.win.width - width
        width: panel.width * (1 - root.panels.session.offsetScale) + root.borderThickness + sidebarRegion.width
    }

    R {
        id: sidebarRegion

        panel: root.panels.sidebar
        x: root.geometry.sidebarOnLeft ? 0 : root.win.width - width
        width: panel.width * (1 - root.panels.sidebar.offsetScale) + root.borderThickness
    }

    R {
        panel: root.panels.osdWrapper
        x: root.geometry.osdOnLeft ? 0 : root.win.width - width
        width: panel.width * (1 - root.panels.osd.offsetScale) + root.borderThickness + (root.geometry.osdOnLeft ? sidebarRegion.width : sessionRegion.width)
    }

    R {
        panel: root.panels.notifications
        y: 0
        height: panel.height + root.geometry.insetTop(root.borderThickness)
    }

    R {
        panel: root.panels.utilities
    }

    R {
        panel: root.panels.popoutsWrapper
        width: root.geometry.horizontal ? panel.width : panel.width * (1 - root.panels.popoutsWrapper.offsetScale)
        height: root.geometry.horizontal ? panel.height * (1 - root.panels.popoutsWrapper.offsetScale) : panel.height
    }

    component R: Region {
        required property Item panel

        x: panel.x + root.geometry.insetLeft(root.borderThickness)
        y: panel.y + root.geometry.insetTop(root.borderThickness)
        width: panel.width
        height: panel.height
        intersection: Intersection.Subtract
    }
}
