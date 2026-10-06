import QtQuick
import QtQuick.Controls
import Quickshell
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.modules.bar as Bar
import qs.modules.bar.popouts as BarPopouts

CustomMouseArea {
    id: root

    required property ShellScreen screen
    required property BarPopouts.Wrapper popouts
    required property ScreenState screenState
    required property Panels panels
    required property Bar.BarWrapper bar
    required property EdgeGeometry geometry
    required property real borderThickness
    required property bool fullscreen

    property point dragStart
    property bool dashboardShortcutActive
    property bool osdShortcutActive
    property bool utilitiesShortcutActive

    function withinPanelHeight(panel: Item, x: real, y: real): bool {
        const panelY = geometry.insetTop(borderThickness) + panel.y;
        return y >= panelY - Config.border.rounding && y <= panelY + panel.height + Config.border.rounding;
    }

    function withinPanelWidth(panel: Item, x: real, y: real): bool {
        const panelX = geometry.insetLeft(borderThickness) + panel.x;
        return x >= panelX - Config.border.rounding && x <= panelX + panel.width + Config.border.rounding;
    }

    function inLeftPanel(panel: Item, x: real, y: real): bool {
        return x < geometry.insetLeft(borderThickness) + panel.x + panel.width && withinPanelHeight(panel, x, y);
    }

    function inPopoutArea(x: real, y: real): bool {
        const panel = panels.popoutsWrapper;
        if (geometry.horizontal)
            return withinPanelWidth(panel, x, y) && withinPanelHeight(panel, x, y);
        if (geometry.barOnRight)
            return x > geometry.insetLeft(borderThickness) + panel.x && withinPanelHeight(panel, x, y);
        return inLeftPanel(panel, x, y);
    }

    function inRightPanel(panel: Item, x: real, y: real): bool {
        return x > Math.min(width - Config.border.minThickness, geometry.insetLeft(borderThickness) + panel.x) && withinPanelHeight(panel, x, y);
    }

    function inOsdArea(x: real, y: real): bool {
        const panel = panels.osdWrapper;
        const panelWidth = panel.width;
        const extent = Math.max(panelWidth, borderThickness);
        const left = geometry.insetLeft(borderThickness) + panel.x;
        const outer = geometry.osdOnLeft ? left : left;
        const inner = geometry.osdOnLeft ? left + extent : left + panelWidth + extent;
        return x >= outer && x <= inner && withinPanelHeight(panel, x, y);
    }

    function inSessionArea(x: real, y: real): bool {
        return geometry.sidebarOnLeft ? inLeftPanel(panels.sessionWrapper, x, y) : inRightPanel(panels.sessionWrapper, x, y);
    }

    function inSidebarArea(x: real, y: real): bool {
        return geometry.sidebarOnLeft ? inLeftPanel(panels.sidebar, x, y) : inRightPanel(panels.sidebar, x, y);
    }

    function pastSidebarStrip(x: real): bool {
        const inner = geometry.insetLeft(borderThickness) + panels.sidebar.x + panels.sidebar.width;
        return geometry.sidebarOnLeft ? x < Math.max(Config.border.minThickness, inner) : x > Math.min(width - Config.border.minThickness, geometry.insetLeft(borderThickness) + panels.sidebar.x);
    }

    function dragTowardCentre(dx: real, threshold: real): bool {
        return geometry.sidebarOnLeft ? dx > threshold : dx < -threshold;
    }

    function inTopPanel(panel: Item, x: real, y: real): bool {
        const panelHeight = panel.height * (1 - (panel.offsetScale ?? 0)); // qmllint disable missing-property
        return y < Math.max(Config.border.minThickness, geometry.insetTop(Config.border.thickness) + panelHeight) && withinPanelWidth(panel, x, y);
    }

    function inBottomPanel(panel: Item, x: real, y: real, isCorner = false): bool {
        const panelHeight = panel.height * (1 - (panel.offsetScale ?? 0)); // qmllint disable missing-property
        return y > height - Math.max(Config.border.minThickness, geometry.insetBottom(Config.border.thickness) + panelHeight) - (isCorner ? Config.border.rounding : 0) && withinPanelWidth(panel, x, y);
    }

    function inDashboardArea(x: real, y: real): bool {
        if (geometry.dashboardOnLeft) {
            if (geometry.barOnLeft && geometry.barContains(x, y))
                return false;
            const panelWidth = panels.dashboard.width * (1 - panels.dashboard.offsetScale);
            return x < Math.max(Config.border.minThickness, geometry.insetLeft(Config.border.thickness) + panelWidth) && withinPanelHeight(panels.dashboard, x, y);
        }
        if (geometry.dashboardOnRight) {
            if (geometry.barOnRight && geometry.barContains(x, y))
                return false;
            const panelWidth = panels.dashboard.width * (1 - panels.dashboard.offsetScale);
            return x > width - Math.max(Config.border.minThickness, geometry.insetRight(Config.border.thickness) + panelWidth) && withinPanelHeight(panels.dashboard, x, y);
        }
        return inTopPanel(panels.dashboard, x, y);
    }

    function inUtilitiesArea(x: real, y: real): bool {
        return (geometry.utilitiesOnTop ? inTopPanel(panels.utilities, x, y) : inBottomPanel(panels.utilities, x, y, true)) || (Config.utilities.alwaysShowNotifications && screenState.utilities && screenState.sidebar && inSidebarArea(x, y));
    }

    function onWheel(event: WheelEvent): void {
        if (fullscreen)
            return;
        if (geometry.barContains(event.x, event.y)) {
            bar.handleWheel(geometry.axisPos(event.x, event.y), event.angleDelta);
        }
    }

    anchors.fill: parent
    acceptedButtons: fullscreen ? Qt.NoButton : Qt.AllButtons
    hoverEnabled: true

    onPressed: event => dragStart = Qt.point(event.x, event.y)
    onContainsMouseChanged: {
        if (!containsMouse) {
            // Only hide if not activated by shortcut
            if (!osdShortcutActive) {
                screenState.osd = false;
                root.panels.osd.hovered = false;
            }

            if (!dashboardShortcutActive)
                screenState.dashboard = false;

            if (!utilitiesShortcutActive)
                screenState.utilities = false;

            if (!popouts.currentName.startsWith("traymenu") || ((popouts.current as StackView)?.depth ?? 0) <= 1) {
                popouts.hasCurrent = false;
                bar.closeTray();
            }

            if (Config.bar.showOnHover)
                bar.isHovered = false;

            if (Config.sidebar.showOnHover)
                screenState.sidebar = false;
        }
    }

    onPositionChanged: event => {
        if (popouts.isDetached)
            return;

        const x = event.x;
        const y = event.y;
        const dragX = x - dragStart.x;
        const dragY = y - dragStart.y;
        const g = geometry;
        const s = screenState;
        const p = panels;
        const b = bar;
        const po = popouts;
        const cfg = Config;

        function canDismissPopouts(): bool {
            return !po.currentName.startsWith("traymenu") || ((po.current as StackView)?.depth ?? 0) <= 1;
        }

        function updateOsdHover(show: bool, keep: bool): void {
            if (p.osd.timerRunning)
                return;
            if (!osdShortcutActive) {
                s.osd = show || keep;
                p.osd.hovered = show || keep;
            } else if (show) {
                osdShortcutActive = false;
                p.osd.hovered = true;
            }
        }

        function updateDashboardHover(show: bool): void {
            if (!dashboardShortcutActive) {
                s.dashboard = show;
            } else if (show) {
                dashboardShortcutActive = false;
            }
        }

        function updateUtilitiesHover(show: bool): void {
            if (!utilitiesShortcutActive) {
                s.utilities = show;
            } else if (show) {
                utilitiesShortcutActive = false;
            }
        }

        const sidebarTriggerY = () => Math.max(cfg.sidebar.minHoverThreshold, p.notifications.y + p.notifications.height + borderThickness);

        if (fullscreen) {
            p.osd.hovered = inOsdArea(x, y);
            return;
        }

        // Show bar in non-exclusive mode on hover
        if (!s.bar && cfg.bar.showOnHover && g.barContains(x, y, true))
            b.isHovered = true;

        // Show/hide bar on drag
        if (pressed && g.barContains(dragStart.x, dragStart.y, true)) {
            const barDrag = g.inwardDrag(dragX, dragY);
            if (barDrag > cfg.bar.dragThreshold)
                s.bar = true;
            else if (barDrag < -cfg.bar.dragThreshold)
                s.bar = false;
        }

        const showOsd = !s.session && inOsdArea(x, y);
        const keepOsd = p.osdWrapper.dashboardOnOsdSide && s.dashboard;
        updateOsdHover(showOsd, keepOsd);

        if (p.sidebar.offsetScale === 1) {
            const showSidebar = pressed && pastSidebarStrip(dragStart.x);

            if (cfg.sidebar.showOnHover && !s.sidebar) {
                const sy = Math.max(cfg.sidebar.minHoverThreshold, p.notifications.y + p.notifications.height + borderThickness);
                const showSidebarHover = pastSidebarStrip(x) && y <= sy;
                if (showSidebarHover)
                    s.sidebar = true;
            }

            // Show/hide session on drag
            if (pressed && inSessionArea(dragStart.x, dragStart.y) && withinPanelHeight(p.sessionWrapper, x, y)) {
                if (dragTowardCentre(dragX, cfg.session.dragThreshold))
                    s.session = true;
                else if (dragTowardCentre(-dragX, cfg.session.dragThreshold))
                    s.session = false;

                // Show sidebar on drag if in session area and session is nearly fully visible
                if (showSidebar && p.session.offsetScale <= 0 && dragTowardCentre(dragX, cfg.sidebar.dragThreshold))
                    s.sidebar = true;
            } else if (showSidebar && dragTowardCentre(dragX, cfg.sidebar.dragThreshold)) {
                // Show sidebar on drag if not in session area
                s.sidebar = true;
            }
        } else {
            const sidebarWidth = p.sidebar.width * (1 - p.sidebar.offsetScale);
            const outOfSidebar = g.sidebarOnLeft ? x > p.sidebar.x + sidebarWidth : x < width - sidebarWidth;

            // Show/hide session on drag
            if (pressed && outOfSidebar && inSessionArea(dragStart.x, dragStart.y) && withinPanelHeight(p.sessionWrapper, x, y)) {
                if (dragTowardCentre(dragX, cfg.session.dragThreshold))
                    s.session = true;
                else if (dragTowardCentre(-dragX, cfg.session.dragThreshold))
                    s.session = false;
            }

            // Show/hide sidebar on hover
            if (cfg.sidebar.showOnHover && !pressed) {
                const sy = Math.max(cfg.sidebar.minHoverThreshold, p.notifications.y + p.notifications.height + borderThickness);
                const showSidebarHover = pastSidebarStrip(x) && y <= sy;
                if (showSidebarHover && !s.sidebar) {
                    s.sidebar = true;
                } else {
                    const inSidebarHoverArea = inSidebarArea(x, y) || inSessionArea(x, y) || (s.sidebarTemporary) || (s.utilities && inUtilitiesArea(x, y));
                    if (!inSidebarHoverArea)
                        s.sidebar = false;
                }
            }

            // Hide sidebar on drag
            if (pressed && inSidebarArea(dragStart.x, 0) && (g.sidebarOnLeft ? dragX < -cfg.sidebar.dragThreshold : dragX > cfg.sidebar.dragThreshold))
                s.sidebar = false;
        }

        // Show launcher on hover, or show/hide on drag if hover is disabled
        if (cfg.launcher.showOnHover) {
            if (!s.launcher && inBottomPanel(p.launcher, x, y) && !(g.barOnBottom && g.barContains(x, y)))
                s.launcher = true;
        } else if (pressed && inBottomPanel(p.launcher, dragStart.x, dragStart.y) && !(g.barOnBottom && g.barContains(dragStart.x, dragStart.y)) && withinPanelWidth(p.launcher, x, y)) {
            if (dragY < -cfg.launcher.dragThreshold)
                s.launcher = true;
            else if (dragY > cfg.launcher.dragThreshold)
                s.launcher = false;
        }
        const showDashboard = !s.sidebarOrSession && cfg.dashboard.showOnHover && !po.hasCurrent && (inDashboardArea(x, y) || (p.osdWrapper.dashboardOnOsdSide && s.dashboard && inOsdArea(x, y)));
        updateDashboardHover(showDashboard);

        // Show/hide dashboard on drag (for touchscreen devices)
        if (pressed && inDashboardArea(dragStart.x, dragStart.y) && (g.dashboardOnTop ? withinPanelWidth(p.dashboard, x, y) : withinPanelHeight(p.dashboard, x, y))) {
            const dashDrag = g.dashboardOnLeft ? dragX : dragY;
            if (dashDrag > cfg.dashboard.dragThreshold)
                s.dashboard = true;
            else if (dashDrag < -cfg.dashboard.dragThreshold)
                s.dashboard = false;
        }

        // Show utilities on hover; when the panel sits next to the power entry it rides that
        let showUtilities;
        if (g.powerTriggersUtilities) {
            const entry = g.barContains(x, y) ? b.entryAt(g.axisPos(x, y)) : "";
            showUtilities = entry === "power" || (s.utilities && !entry && inUtilitiesArea(x, y));
        } else {
            showUtilities = inUtilitiesArea(x, y);
        }
        updateUtilitiesHover(showUtilities);

        // Show popouts on hover
        if (g.barContains(x, y)) {
            b.checkPopout(g.axisPos(x, y));
        } else if (canDismissPopouts() && !inPopoutArea(x, y)) {
            po.hasCurrent = false;
            b.closeTray();
        }
    }

    // Monitor individual visibility changes
    Connections {
        function onLauncherChanged() {
            // If launcher is hidden, clear shortcut flags for dashboard and OSD
            if (!root.screenState.launcher) {
                root.dashboardShortcutActive = false;
                root.osdShortcutActive = false;
                root.utilitiesShortcutActive = false;

                // Also hide dashboard and OSD if they're not being hovered
                const inDashboardArea = root.inDashboardArea(root.mouseX, root.mouseY);
                const inOsdArea = root.inOsdArea(root.mouseX, root.mouseY);

                if (!inDashboardArea) {
                    root.screenState.dashboard = false;
                }
                if (!inOsdArea) {
                    root.screenState.osd = false;
                    root.panels.osd.hovered = false;
                }
            }
        }

        function onDashboardChanged() {
            if (root.screenState.dashboard) {
                // Dashboard became visible, immediately check if this should be shortcut mode
                const inDashboardArea = root.inDashboardArea(root.mouseX, root.mouseY);
                if (!inDashboardArea) {
                    root.dashboardShortcutActive = true;
                }
            } else {
                // Dashboard hidden, clear shortcut flag
                root.dashboardShortcutActive = false;
            }
        }

        function onOsdChanged() {
            if (root.screenState.osd) {
                // OSD became visible, immediately check if this should be shortcut mode
                const inOsdArea = root.inOsdArea(root.mouseX, root.mouseY);
                if (!inOsdArea && !root.panels.osdWrapper.dashboardOnOsdSide) {
                    root.osdShortcutActive = true;
                }
            } else {
                // OSD hidden, clear shortcut flag
                root.osdShortcutActive = false;
            }
        }

        function onUtilitiesChanged() {
            if (root.screenState.utilities) {
                // Utilities became visible, immediately check if this should be shortcut mode
                const inUtilitiesArea = root.inUtilitiesArea(root.mouseX, root.mouseY);
                if (!inUtilitiesArea) {
                    root.utilitiesShortcutActive = true;
                }
            } else {
                // Utilities hidden, clear shortcut flag
                root.utilitiesShortcutActive = false;
            }
        }

        target: root.screenState
    }

    Connections {
        function onHasCurrentChanged() {
            // Bar popouts take precedence over the dashboard
            if (root.popouts.hasCurrent) {
                root.screenState.dashboard = false;
                root.dashboardShortcutActive = false;
            }
        }

        target: root.popouts
    }
}
