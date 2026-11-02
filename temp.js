// function withinPanelHeight(panel: Item, y: real): bool {
//     const panelY = geometry.insetTop(borderThickness) + panel.y;
//     return y >= panelY - Config.border.rounding && y <= panelY + panel.height + Config.border.rounding;
// }

// function withinPanelWidth(panel: Item, x: real): bool {
//     const panelX = geometry.insetLeft(borderThickness) + panel.x;
//     return x >= panelX - Config.border.rounding && x <= panelX + panel.width + Config.border.rounding;
// }

// function inLeftPanel(panel: Item, x: real, y: real): bool {
//     return x < geometry.insetLeft(borderThickness) + panel.x + panel.width && withinPanelHeight(panel, y);
// }

// function inRightPanel(panel: Item, x: real, y: real): bool {
//     return x > Math.min(width - Config.border.minThickness, geometry.insetLeft(borderThickness) + panel.x) && withinPanelHeight(panel, y);
// }

// function inOsdArea(x: real, y: real): bool {
//     const panel = panels.osdWrapper;
//     const panelWidth = panel.width;
//     const extent = Math.max(panelWidth, borderThickness);
//     const left = geometry.insetLeft(borderThickness) + panel.x;
//     const inner = geometry.osdOnLeft ? left + extent : left + panelWidth + extent;
//     return x >= left && x <= inner && withinPanelHeight(panel, y);
// }

// function inSessionArea(x: real, y: real): bool {
//     return geometry.sidebarOnLeft ? inLeftPanel(panels.sessionWrapper, x, y) : inRightPanel(panels.sessionWrapper, x, y);
// }

// function inSidebarArea(x: real, y: real): bool {
//     return geometry.sidebarOnLeft ? inLeftPanel(panels.sidebar, x, y) : inRightPanel(panels.sidebar, x, y);
// }

// function pastSidebarStrip(x: real): bool {
//     const inner = geometry.insetLeft(borderThickness) + panels.sidebar.x + panels.sidebar.width;
//     return geometry.sidebarOnLeft ? x < Math.max(Config.border.minThickness, inner) : x > Math.min(width - Config.border.minThickness, geometry.insetLeft(borderThickness) + panels.sidebar.x);
// }

// function dragTowardCentre(dx: real, threshold: real): bool {
//     return geometry.sidebarOnLeft ? dx > threshold : dx < -threshold;
// }

// function inTopPanel(panel: Item, x: real, y: real): bool {
//     const panelHeight = panel.height * (1 - (panel.offsetScale ?? 0)); // qmllint disable missing-property
//     return y < Math.max(Config.border.minThickness, geometry.insetTop(Config.border.thickness) + panelHeight) && withinPanelWidth(panel, x);
// }

// function inBottomPanel(panel: Item, x: real, y: real, isCorner = false): bool {
//     const panelHeight = panel.height * (1 - (panel.offsetScale ?? 0)); // qmllint disable missing-property
//     return y > height - Math.max(Config.border.minThickness, geometry.insetBottom(Config.border.thickness) + panelHeight) - (isCorner ? Config.border.rounding : 0) && withinPanelWidth(panel, x);
// }

// function inDashboardArea(x: real, y: real): bool {
//     if (geometry.dashboardOnLeft) {
//         if (geometry.barOnLeft && geometry.barContains(x, y))
//             return false;
//         const panelWidth = panels.dashboard.width * (1 - panels.dashboard.offsetScale);
//         return x < Math.max(Config.border.minThickness, geometry.insetLeft(Config.border.thickness) + panelWidth) && withinPanelHeight(panels.dashboard, y);
//     }
//     if (geometry.dashboardOnRight) {
//         if (geometry.barOnRight && geometry.barContains(x, y))
//             return false;
//         const panelWidth = panels.dashboard.width * (1 - panels.dashboard.offsetScale);
//         return x > width - Math.max(Config.border.minThickness, geometry.insetRight(Config.border.thickness) + panelWidth) && withinPanelHeight(panels.dashboard, y);
//     }
//     return inTopPanel(panels.dashboard, x, y);
// }

// function inUtilitiesArea(x: real, y: real): bool {
//     return (geometry.utilitiesOnTop ? inTopPanel(panels.utilities, x, y) : inBottomPanel(panels.utilities, x, y, true)) || (Config.utilities.alsoShowSidebar && screenState.utilities && screenState.sidebar && inSidebarArea(x, y));
// }

// function inBarArea(x: real, y: real): bool {
//     return geometry.barContains(x, y);
// }

// function onWheel(event: WheelEvent): void {
//     if (fullscreen)
//         return;
//     if (geometry.barContains(event.x, event.y)) {
//         bar.handleWheel(geometry.axisPos(event.x, event.y), event.angleDelta);
//     }
// }

// // A panel opened by shortcut stays open until the pointer reaches its area, at which
// // point hover takes over. Returns the updated latch state.
// function nextHoverLatch(show: bool, latched: bool): bool {
//     return latched && !show;
// }

// function updateOsdHover(show: bool, keep: bool): void {
//     if (panels.osd.timerRunning)
//         return;
//     if (!osdShortcutActive) {
//         screenState.osd = show || keep;
//         panels.osd.hovered = show || keep;
//     } else if (show) {
//         osdShortcutActive = false;
//         panels.osd.hovered = true;
//     }
// }

// function sidebarTriggerY(): real {
//     return Math.max(Config.sidebar.minHoverThreshold, panels.notifications.y + panels.notifications.height + borderThickness);
// }

// function inSidebarHoverArea(x: real, y: real): bool {
//     // (inSidebarArea(x, y) && (geometry.sidebarOnLeft && x < geometry.insetLeft(borderThickness) ? y < sidebarTriggerY() : true)) || (screenState.session && inSessionArea(x, y)) || (screenState.osd && inOsdArea(x, y)) || screenState.sidebar || (screenState.utilities && inUtilitiesArea(x, y));
//     return pastSidebarStrip(x) && (y <= sidebarTriggerY() || geometry.panelContains(panels.sidebar, x, y));
// }

// function handleBar(x: real, y: real, dragX: real, dragY: real): void {
//     // Show bar in non-exclusive mode on hover
//     if (!screenState.bar && Config.bar.showOnHover && geometry.barContains(x, y, true))
//         bar.isHovered = true;

//     // Show/hide bar on drag
//     if (pressed && geometry.barContains(dragStart.x, dragStart.y, true)) {
//         const barDrag = geometry.inwardDrag(dragX, dragY);
//         if (barDrag > Config.bar.dragThreshold)
//             screenState.bar = true;
//         else if (barDrag < -Config.bar.dragThreshold)
//             screenState.bar = false;
//     }
// }

// function handleOsd(x: real, y: real): void {
//     updateOsdHover(!screenState.session && inOsdArea(x, y), panels.osdWrapper.dashboardOnOsdSide && screenState.dashboard);
// }

// function handleSidebarSession(x: real, y: real, dragX: real): void {
//     if (panels.sidebar.offsetScale === 1) {
//         const showSidebar = pressed && pastSidebarStrip(dragStart.x);

//         // Show sidebar on hover (edge corner, bounded by notification panel height)
//         if (Config.sidebar.showOnHover && !screenState.sidebar && pastSidebarStrip(x) && y <= sidebarTriggerY())
//             screenState.sidebarTemporary = true;

//         // Show/hide session on drag
//         if (pressed && inSessionArea(dragStart.x, dragStart.y) && withinPanelHeight(panels.sessionWrapper, y)) {
//             if (dragTowardCentre(dragX, Config.session.dragThreshold))
//                 screenState.session = true;
//             else if (dragTowardCentre(-dragX, Config.session.dragThreshold))
//                 screenState.session = false;

//             // Show sidebar on drag if in session area and session is nearly fully visible
//             if (showSidebar && panels.session.offsetScale <= 0 && dragTowardCentre(dragX, Config.sidebar.dragThreshold))
//                 screenState.sidebar = true;
//         } else if (showSidebar && dragTowardCentre(dragX, Config.sidebar.dragThreshold)) {
//             // Show sidebar on drag if not in session area
//             screenState.sidebar = true;
//         }
//     } else {
//         const sidebarWidth = panels.sidebar.width * (1 - panels.sidebar.offsetScale);
//         const sidebarLeft = geometry.insetLeft(borderThickness) + panels.sidebar.x;
//         const outOfSidebar = geometry.sidebarOnLeft ? x > sidebarLeft + sidebarWidth : x < sidebarLeft;

//         // Show/hide session on drag
//         if (pressed && outOfSidebar && inSessionArea(dragStart.x, dragStart.y) && withinPanelHeight(panels.sessionWrapper, y)) {
//             if (dragTowardCentre(dragX, Config.session.dragThreshold))
//                 screenState.session = true;
//             else if (dragTowardCentre(-dragX, Config.session.dragThreshold))
//                 screenState.session = false;
//         }

//         // Show/hide sidebar on hover
//         if (Config.sidebar.showOnHover && !pressed) {
//             if (pastSidebarStrip(x) && y <= sidebarTriggerY()) {
//                 if (!screenState.sidebar)
//                     screenState.sidebarTemporary = true;
//             } else if (!inSidebarHoverArea(x, y))
//                 screenState.sidebarTemporary = false;
//         }

//         // Hide sidebar on drag
//         if (pressed && inSidebarArea(dragStart.x, 0) && (geometry.sidebarOnLeft ? dragX < -Config.sidebar.dragThreshold : dragX > Config.sidebar.dragThreshold))
//             screenState.sidebar = false;
//     }
// }

// function handleLauncher(x: real, y: real, dragY: real): void {
//     // Show launcher on hover, or show/hide on drag if hover is disabled
//     if (Config.launcher.showOnHover) {
//         if (!screenState.launcher && inBottomPanel(panels.launcher, x, y) && !(geometry.barOnBottom && geometry.barContains(x, y)))
//             screenState.launcher = true;
//     } else if (pressed && inBottomPanel(panels.launcher, dragStart.x, dragStart.y) && !(geometry.barOnBottom && geometry.barContains(dragStart.x, dragStart.y)) && withinPanelWidth(panels.launcher, x)) {
//         if (dragY < -Config.launcher.dragThreshold)
//             screenState.launcher = true;
//         else if (dragY > Config.launcher.dragThreshold)
//             screenState.launcher = false;
//     }
// }

// function handleDashboard(x: real, y: real, dragX: real, dragY: real): void {
//     // Show dashboard on hover (bar popouts take precedence over the dashboard), unless the
//     // sidebar or the session drawer is taking the edge. When the OSD shares the dashboard's
//     // edge the two sit side by side, so the OSD's band keeps the dashboard open too:
//     // otherwise the dashboard closes the moment the pointer crosses over, and the OSD
//     // slides away with it before it can be reached.
//     const showDashboard = !screenState.sidebarOrSession && Config.dashboard.showOnHover && !popouts.hasCurrent && (inDashboardArea(x, y) || (panels.osdWrapper.dashboardOnOsdSide && screenState.dashboard && inOsdArea(x, y)));
//     if (!dashboardShortcutActive)
//         screenState.dashboard = showDashboard;
//     dashboardShortcutActive = nextHoverLatch(showDashboard, dashboardShortcutActive);

//     // Show/hide dashboard on drag (for touchscreen devices)
//     if (pressed && inDashboardArea(dragStart.x, dragStart.y) && (geometry.dashboardOnTop ? withinPanelWidth(panels.dashboard, x) : withinPanelHeight(panels.dashboard, y))) {
//         const dashDrag = geometry.dashboardOnLeft ? dragX : dragY;
//         if (dashDrag > Config.dashboard.dragThreshold)
//             screenState.dashboard = true;
//         else if (dashDrag < -Config.dashboard.dragThreshold)
//             screenState.dashboard = false;
//     }
// }

// function handleUtilities(x: real, y: real): void {
//     // Show utilities on hover; when the panel sits next to the power entry it rides that
//     // entry instead of an edge zone
//     let showUtilities;
//     if (geometry.powerTriggersUtilities) {
//         const entry = geometry.barContains(x, y) ? bar.entryAt(geometry.axisPos(x, y)) : "";
//         showUtilities = entry === "power" || (screenState.utilities && !entry && inUtilitiesArea(x, y));
//     } else {
//         showUtilities = inUtilitiesArea(x, y);
//     }
//     if (!utilitiesShortcutActive)
//         screenState.utilities = showUtilities;
//     utilitiesShortcutActive = nextHoverLatch(showUtilities, utilitiesShortcutActive);
//     if (Config.utilities.alsoShowSidebar && screenState.utilities && !screenState.sidebar && !screenState.sidebarTemporary)
//         screenState.sidebarTemporary = true;
// }

// function inPopoutArea(x: real, y: real): bool {
//     const panel = panels.popoutsWrapper;
//     if (geometry.horizontal)
//         return withinPanelWidth(panel, x) && withinPanelHeight(panel, y);
//     if (geometry.barOnRight)
//         return x > geometry.insetLeft(borderThickness) + panel.x && withinPanelHeight(panel, y);
//     return inLeftPanel(panel, x, y);
// }

// function handlePopouts(x: real, y: real): void {
//     // Show popouts on hover
//     if (geometry.barContains(x, y)) {
//         bar.checkPopout(geometry.axisPos(x, y));
//     } else if (canDismissPopouts() && !inPopoutArea(x, y)) {
//         popouts.hasCurrent = false;
//         bar.closeTray();
//     }
// }
