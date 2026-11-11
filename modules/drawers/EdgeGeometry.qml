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
        readonly property real extent: root.barWrapper.extent
        readonly property real clampedExtent: root.barWrapper.clampedExtent
        readonly property int position: root.config.bar.position
        readonly property bool horizontal: position === BarPosition.Top || position === BarPosition.Bottom
        readonly property bool onLeft: position === BarPosition.Left
        readonly property bool onTop: position === BarPosition.Top
        readonly property bool onRight: position === BarPosition.Right
        readonly property bool onBottom: position === BarPosition.Bottom
    }

    readonly property var dashboard: QtObject {
        readonly property int position: BarLayout.dashboardFor(root.bar.position, root.config.dashboard.position)
        readonly property bool onLeft: position === DashboardPosition.Left
        readonly property bool onTop: position === DashboardPosition.Top
        readonly property bool onRight: position === DashboardPosition.Right
        readonly property bool activeWindowHover: BarLayout.activeWindowHoverSupported(root.bar.position, position)
        readonly property bool horizontal: position === DashboardPosition.Left || position === DashboardPosition.Right
    }

    readonly property var utilities: QtObject {
        readonly property int position: BarLayout.utilitiesFor(root.bar.position, root.config.utilities.position)
        readonly property bool onLeft: BarLayout.isCornerOn(position, BarPosition.Left)
        readonly property bool onRight: BarLayout.isCornerOn(position, BarPosition.Right)
        readonly property bool onTop: BarLayout.isCornerOn(position, BarPosition.Top)
        readonly property bool onBottom: BarLayout.isCornerOn(position, BarPosition.Bottom)
    }

    readonly property var osd: QtObject {
        readonly property int position: root.config.osd.position
        readonly property bool onLeft: position === HorizontalPosition.Left
        readonly property bool onRight: !onLeft
        readonly property bool besideSidebar: position === root.sidebar.position
        readonly property bool besideSession: position === root.sidebar.position
        readonly property bool besideDashboard: (onLeft && root.dashboard.onLeft) || (onRight && root.dashboard.onRight)
    }

    readonly property var sidebar: QtObject {
        readonly property int position: root.config.sidebar.position
        readonly property bool onLeft: position === HorizontalPosition.Left
        readonly property bool onRight: !onLeft
        readonly property bool besideBar: (onLeft && root.bar.onLeft) || (onRight && root.bar.onRight)
        readonly property bool besideDashboard: (onLeft && root.dashboard.onLeft) || (onRight && root.dashboard.onRight)
        readonly property bool besideSession: onRight
        readonly property bool besideOSD: (onLeft && root.osd.onLeft) || (onRight && root.osd.onRight)
        readonly property bool alongUtilities: (onLeft && root.utilities.onLeft) || (onRight && root.utilities.onRight)
        readonly property bool aboveUtilities: (onLeft && root.utilities.onBottom && root.utilities.onLeft) || (onRight && root.utilities.onBottom && root.utilities.onRight) && root.config.utilities.alsoShowSidebar
        readonly property bool belowUtilities: (onLeft && root.utilities.onTop && root.utilities.onLeft) || (onRight && root.utilities.onTop && root.utilities.onRight) && root.config.utilities.alsoShowSidebar
    }

    readonly property var session: QtObject {
        readonly property bool besideSidebar: true
        readonly property bool besideDashboard: (root.dashboard.onLeft && root.sidebar.onLeft) || (root.dashboard.onRight && root.sidebar.onRight)
    }

    readonly property var notifications: QtObject {
        readonly property bool alongUtilities: ((root.utilities.onLeft && root.sidebar.onLeft) || (root.utilities.onRight && root.sidebar.onRight)) && root.config.utilities.alsoShowSidebar
        readonly property bool besideSidebar: ((root.sidebar.onLeft && root.utilities.onLeft) || (root.sidebar.onRight && root.utilities.onRight)) && !root.config.utilities.alsoShowSidebar
        readonly property bool aboveUtilities: alongUtilities && root.utilities.onBottom
        readonly property bool belowUtilities: alongUtilities && root.utilities.onTop
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
