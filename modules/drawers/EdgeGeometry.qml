pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.utils
import qs.modules.bar as Bar

QtObject {
    id: root

    required property Bar.BarWrapper bar
    required property var win
    required property int configPosition
    required property int dashboardPosition
    required property int configUtilitiesPosition
    required property int osdPosition
    required property int sidebarPosition

    readonly property int position: configPosition
    readonly property bool horizontal: position === BarPosition.Top || position === BarPosition.Bottom
    readonly property bool barOnLeft: position === BarPosition.Left
    readonly property bool barOnTop: position === BarPosition.Top
    readonly property bool barOnRight: position === BarPosition.Right
    readonly property bool barOnBottom: position === BarPosition.Bottom
    readonly property int effectiveDashboardPosition: BarLayout.dashboardFor(position, dashboardPosition)
    readonly property int effectiveUtilitiesPosition: BarLayout.utilitiesFor(position, configUtilitiesPosition)
    readonly property bool dashboardOnLeft: effectiveDashboardPosition === DashboardPosition.Left
    readonly property bool dashboardOnTop: effectiveDashboardPosition === DashboardPosition.Top
    readonly property bool dashboardOnRight: effectiveDashboardPosition === DashboardPosition.Right
    readonly property bool osdOnLeft: osdPosition === HorizontalPosition.Left
    readonly property bool osdOnRight: !osdOnLeft
    readonly property bool sidebarOnLeft: sidebarPosition === HorizontalPosition.Left
    readonly property bool sidebarOnRight: !sidebarOnLeft
    readonly property bool utilitiesOnLeft: BarLayout.isCornerOn(effectiveUtilitiesPosition, BarPosition.Left)
    readonly property bool utilitiesOnRight: BarLayout.isCornerOn(effectiveUtilitiesPosition, BarPosition.Right)
    readonly property bool utilitiesOnTop: BarLayout.isCornerOn(effectiveUtilitiesPosition, BarPosition.Top)
    readonly property bool utilitiesOnBottom: BarLayout.isCornerOn(effectiveUtilitiesPosition, BarPosition.Bottom)
    readonly property bool powerTriggersUtilities: BarLayout.powerTriggersUtilities(position, effectiveUtilitiesPosition, bar.powerAtEnd())
    readonly property bool activeWindowHover: BarLayout.activeWindowHoverSupported(position, effectiveDashboardPosition)

    readonly property real barExtent: bar.extent
    readonly property real barClamped: bar.clampedExtent

    function insetLeft(border: real, clamped = false): real {
        return barOnLeft ? (clamped ? barClamped : barExtent) : border;
    }

    function insetRight(border: real, clamped = false): real {
        return barOnRight ? (clamped ? barClamped : barExtent) : border;
    }

    function insetTop(border: real, clamped = false): real {
        return barOnTop ? (clamped ? barClamped : barExtent) : border;
    }

    function insetBottom(border: real, clamped = false): real {
        return barOnBottom ? (clamped ? barClamped : barExtent) : border;
    }

    function barContains(x: real, y: real, clamped = false): bool {
        const extent = clamped ? barClamped : barExtent;
        if (barOnTop)
            return y < extent;
        if (barOnBottom)
            return y > win.height - extent;
        if (barOnRight)
            return x > win.width - extent;
        return x < extent;
    }

    function inwardDrag(dragX: real, dragY: real): real {
        if (barOnTop)
            return dragY;
        if (barOnBottom)
            return -dragY;
        if (barOnRight)
            return -dragX;
        return dragX;
    }

    function axisPos(x: real, y: real): real {
        return horizontal ? x : y;
    }
}
