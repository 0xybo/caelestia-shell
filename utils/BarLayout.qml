pragma Singleton

import QtQuick
import Quickshell
import Caelestia.Config

Singleton {
    id: root

    readonly property var barPositionValues: [BarPosition.Top, BarPosition.Bottom, BarPosition.Left, BarPosition.Right]

    function dashboardPositions(barPosition: int): var {
        if (barPosition === BarPosition.Left)
            return [DashboardPosition.Top, DashboardPosition.Right, DashboardPosition.Left];
        if (barPosition === BarPosition.Right)
            return [DashboardPosition.Top, DashboardPosition.Left, DashboardPosition.Right];
        return [DashboardPosition.Left, DashboardPosition.Right, DashboardPosition.Top];
    }

    function utilitiesPositions(barPosition: int): var {
        if (barPosition === BarPosition.Left)
            return [UtilitiesPosition.BottomRight, UtilitiesPosition.TopRight, UtilitiesPosition.BottomLeft];
        if (barPosition === BarPosition.Right)
            return [UtilitiesPosition.BottomLeft, UtilitiesPosition.TopLeft, UtilitiesPosition.TopRight];
        if (barPosition === BarPosition.Bottom)
            return [UtilitiesPosition.TopLeft, UtilitiesPosition.TopRight, UtilitiesPosition.BottomRight];
        return [UtilitiesPosition.BottomLeft, UtilitiesPosition.BottomRight, UtilitiesPosition.TopRight];
    }

    function dashboardFor(barPosition: int, position: int): int {
        const allowed = dashboardPositions(barPosition);
        return allowed.includes(position) ? position : allowed[0];
    }

    function utilitiesFor(barPosition: int, position: int): int {
        const allowed = utilitiesPositions(barPosition);
        return allowed.includes(position) ? position : allowed[0];
    }

    function barEdgeAsDashboard(barPosition: int): int {
        if (barPosition === BarPosition.Top)
            return DashboardPosition.Top;
        if (barPosition === BarPosition.Left)
            return DashboardPosition.Left;
        if (barPosition === BarPosition.Right)
            return DashboardPosition.Right;
        return -1;
    }

    function activeWindowHoverSupported(barPosition: int, dashboardPosition: int): bool {
        return dashboardFor(barPosition, dashboardPosition) !== barEdgeAsDashboard(barPosition);
    }

    function powerCorner(barPosition: int, powerAtEnd: bool): int {
        if (barPosition === BarPosition.Top)
            return powerAtEnd ? UtilitiesPosition.TopRight : UtilitiesPosition.TopLeft;
        if (barPosition === BarPosition.Bottom)
            return powerAtEnd ? UtilitiesPosition.BottomRight : UtilitiesPosition.BottomLeft;
        if (barPosition === BarPosition.Left)
            return powerAtEnd ? UtilitiesPosition.BottomLeft : UtilitiesPosition.TopLeft;
        return powerAtEnd ? UtilitiesPosition.BottomRight : UtilitiesPosition.TopRight;
    }

    function powerTriggersUtilities(barPosition: int, corner: int, powerAtEnd: bool): bool {
        return corner === powerCorner(barPosition, powerAtEnd);
    }

    function isCornerOn(corner: int, edge: int): bool {
        if (edge === BarPosition.Left)
            return corner === UtilitiesPosition.TopLeft || corner === UtilitiesPosition.BottomLeft;
        if (edge === BarPosition.Right)
            return corner === UtilitiesPosition.TopRight || corner === UtilitiesPosition.BottomRight;
        if (edge === BarPosition.Top)
            return corner === UtilitiesPosition.TopLeft || corner === UtilitiesPosition.TopRight;
        return corner === UtilitiesPosition.BottomLeft || corner === UtilitiesPosition.BottomRight;
    }
}
