pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.utils
import qs.modules.bar

QtObject {
    id: root

    required property BarWrapper barWrapper
    required property var contentWindow
    required property ShellScreen screen

    readonly property var config: GlobalConfig.forScreen(screen.name)

    readonly property var bar: QtObject {
        property real extent: root.barWrapper.extent
        property real clampedExtent: root.barWrapper.clampedExtent
        property int position: root.config.bar.position
        property bool horizontal: position === BarPosition.Top || position === BarPosition.Bottom
        property bool onLeft: position === BarPosition.Left
        property bool onTop: position === BarPosition.Top
        property bool onRight: position === BarPosition.Right
        property bool onBottom: position === BarPosition.Bottom
        property bool besideSidebar: (onLeft && root.sidebar.position === HorizontalPosition.Left) || (onRight && root.sidebar.position === HorizontalPosition.Right)
    }

    readonly property var dashboard: QtObject {
        property int position: BarLayout.dashboardFor(root.bar.position, root.config.dashboard.position)
        property bool onLeft: position === DashboardPosition.Left
        property bool onTop: position === DashboardPosition.Top
        property bool onRight: position === DashboardPosition.Right
        property bool activeWindowHover: BarLayout.activeWindowHoverSupported(root.bar.position, position)
    }

    readonly property var utilities: QtObject {
        property int position: BarLayout.utilitiesFor(root.bar.position, root.config.utilities.position)
        property bool onLeft: BarLayout.isCornerOn(position, BarPosition.Left)
        property bool onRight: BarLayout.isCornerOn(position, BarPosition.Right)
        property bool onTop: BarLayout.isCornerOn(position, BarPosition.Top)
        property bool onBottom: BarLayout.isCornerOn(position, BarPosition.Bottom)
        property bool powerTriggers: BarLayout.powerTriggersUtilities(root.bar.position, position, root.barWrapper.powerAtEnd())
    }

    readonly property var osd: QtObject {
        property int position: root.config.osd.position
        property bool onLeft: position === HorizontalPosition.Left
        property bool onRight: !onLeft
        property bool besideSidebar: position === root.sidebar.position
        property bool besideSession: position === HorizontalPosition.Right
        property bool besideDashboard: (onLeft && root.dashboard.onLeft) || (onRight && root.dashboard.onRight)
    }

    readonly property var sidebar: QtObject {
        property int position: root.config.sidebar.position
        property bool onLeft: position === HorizontalPosition.Left
        property bool onRight: !onLeft
    }

    readonly property var session: QtObject {
        property bool besideSidebar: root.sidebar.position === HorizontalPosition.Right
        property bool besideDashboard: (root.dashboard.onLeft && root.sidebar.onLeft) || (root.dashboard.onRight && root.sidebar.onRight)
    }

    function insetLeft(border: real, clamped = false): real {
        return root.bar.onLeft ? (clamped ? root.bar.clampedExtent : root.bar.extent) : border;
    }

    function insetRight(border: real, clamped = false): real {
        return root.bar.onRight ? (clamped ? root.bar.clampedExtent : root.bar.extent) : border;
    }

    function insetTop(border: real, clamped = false): real {
        return root.bar.onTop ? (clamped ? root.bar.clampedExtent : root.bar.extent) : border;
    }

    function insetBottom(border: real, clamped = false): real {
        return root.bar.onBottom ? (clamped ? root.bar.clampedExtent : root.bar.extent) : border;
    }

    function barContains(x: real, y: real, clamped = false): bool {
        const extent = clamped ? root.bar.clampedExtent : root.bar.extent;
        if (root.bar.onTop)
            return y < extent;
        if (root.bar.onBottom)
            return y > root.contentWindow.height - extent;
        if (root.bar.onRight)
            return x > root.contentWindow.width - extent;
        return x < extent;
    }

    function inwardDrag(dragX: real, dragY: real): real {
        if (root.bar.onTop)
            return dragY;
        if (root.bar.onBottom)
            return -dragY;
        if (root.bar.onRight)
            return -dragX;
        return dragX;
    }

    function axisPos(x: real, y: real): real {
        return root.bar.horizontal ? x : y;
    }
}
