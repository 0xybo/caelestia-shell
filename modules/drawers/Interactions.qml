import QtQuick
import QtQuick.Controls
import QtQml
import Quickshell
import Caelestia.Config
import qs.services
import qs.components
import qs.components.controls
import qs.modules.bar as Bar
import qs.modules.bar.popouts as BarPopouts
import qs.modules.osd as Osd

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

    function inPanelArea(panel: var, x: real, y: real): bool {
        if (!panel || !panel.trigger)
            return false;

        return panel.trigger.containsMouse(x, y);
    }

    function canDismissPopouts(): bool {
        return !popouts.currentName.startsWith("traymenu") || ((popouts.current as StackView)?.depth ?? 0) <= 1;
    }

    function handleOsd(x: real, y: real): void {
        nextState.osdTemporary = inPanelArea(panels.osd, x, y);

        // Keep the sidebar open
        if (root.geometry.osd.besideSidebar && nextState.osdTemporary && root.screenState.shouldSidebarVisible)
            nextState.sidebarTemporary = true;
    }

    function handleUtilities(x: real, y: real): void {
        const inUtilitiesArea = inPanelArea(panels.utilities, x, y);
        nextState.utilitiesTemporary = inUtilitiesArea;
        if (Config.utilities.alsoShowSidebar && inUtilitiesArea)
            nextState.sidebarTemporary = true;
    }

    function handleSidebar(x: real, y: real): void {
        nextState.sidebarTemporary = inPanelArea(panels.sidebar, x, y);
    }

    function handleDashboard(x: real, y: real, dragX: real, dragY: real): void {
        if (inPanelArea(panels.dashboard, x, y))
            nextState.dashboardTemporary = true;
        else {
            const inOsdArea = (root.geometry.dashboard.onLeft && root.geometry.osd.onLeft || root.geometry.dashboard.onRight) && (nextState.osd || nextState.osdTemporary);

            if (!inOsdArea)
                nextState.dashboardTemporary = false;
        }
    }

    function handleLauncher(x: real, y: real, dragY: real): void {
        nextState.launcherTemporary = inPanelArea(panels.launcher, x, y);
    }

    function handleSession(x: real, y: real): void {
        if (!root.screenState.shouldSessionVisible)
            return;

        // Keep the sidebar open
        if (root.geometry.session.besideSidebar && root.screenState.shouldSidebarVisible && inPanelArea(panels.session, x, y))
            nextState.sidebarTemporary = true;
    }

    function handlePopouts(x: real, y: real): void {
        if (geometry.barContains(x, y))
            bar.checkPopout(geometry.axisPos(x, y));
    }

    function getActivePanels(state: var): list<var> {
        const activePanels = [];

        if (panels.popouts.hasCurrent)
            activePanels.push({
                name: "popouts",
                item: panels.popoutsWrapper,
                close: () => {
                    panels.popouts.hasCurrent = false;
                    bar.closeTray();
                }
            });
        if (state.osd || state.osdTemporary)
            activePanels.push({
                name: "osd",
                item: panels.osd,
                close: () => state.osd = state.osdTemporary = false
            });
        if (state.session || state.sessionTemporary)
            activePanels.push({
                name: "session",
                item: panels.session,
                close: () => state.session = state.sessionTemporary = false
            });
        if (state.dashboard || state.dashboardTemporary)
            activePanels.push({
                name: "dashboard",
                item: panels.dashboard,
                close: () => state.dashboard = state.dashboardTemporary = false
            });
        if (state.utilities || state.utilitiesTemporary)
            activePanels.push({
                name: "utilities",
                item: panels.utilities,
                close: () => state.utilities = state.utilitiesTemporary = false
            });
        if (state.sidebar || state.sidebarTemporary)
            activePanels.push({
                name: "sidebar",
                item: panels.sidebar,
                close: () => state.sidebar = state.sidebarTemporary = false
            });
        if (state.launcher || state.launcherTemporary)
            activePanels.push({
                name: "launcher",
                item: panels.launcher,
                close: () => state.launcher = state.launcherTemporary = false
            });

        return activePanels;
    }

    function fakeOpenedPanel(rect) {
        let {
            left,
            top,
            right,
            bottom
        } = rect;

        if (left < 0) {
            right += -left - (Config.bar.position === BarPosition.Left && Tokens.sizes.bar.innerWidth);
            left = 0;
        } else if (right > Window.window.width) {
            left -= right - Window.window.width + (Config.bar.position === BarPosition.Right && Tokens.sizes.bar.innerWidth);
            right = Window.window.width;
        }

        if (top < 0) {
            bottom += -top - (Config.bar.position === BarPosition.Top && Tokens.sizes.bar.innerWidth);
            top = 0;
        } else if (bottom > Window.window.height) {
            top -= bottom - Window.window.height + (Config.bar.position === BarPosition.Bottom && Tokens.sizes.bar.innerWidth);
            bottom = Window.window.height;
        }

        return Qt.rect(left, top, right - left, bottom - top);
    }

    function handleOverlap(state: var): void {
        if (!state)
            state = screenState;
        const activePanels = getActivePanels(state);

        for (let i = 0; i < activePanels.length; i++) {
            const panel = activePanels[i];
            for (let j = 0; j < activePanels.length; j++) {
                const otherPanel = activePanels[j];

                if (panel === otherPanel)
                    continue;
                if (//
                /*   */panel.name === "osd" && (otherPanel.name === "dashboard" || otherPanel.name === "sidebar" || otherPanel.name === "session") || //
                /*   */otherPanel.name === "osd" && (panel.name === "dashboard" || panel.name === "sidebar" || panel.name === "session")) //
                    continue;
                if ( //
                /*    */Config.utilities.alsoShowSidebar && //
                /*    */panel.name === "sidebar" && otherPanel.name === "utilities" || //
                /*    */panel.name === "utilities" && otherPanel.name === "sidebar" || //
                /*    */panel.name === "session" && (otherPanel.name === "sidebar" || otherPanel.name === "utilities") || //
                /*    */otherPanel.name === "session" && (panel.name === "sidebar" || panel.name === "utilities")) //
                    continue;

                const {
                    left: panelLeft,
                    top: panelTop,
                    right: panelRight,
                    bottom: panelBottom
                } = fakeOpenedPanel(panel.item.mapToItem(Window.window.contentItem, 0, 0, panel.item.width, panel.item.height));
                const {
                    left: otherLeft,
                    top: otherTop,
                    right: otherRight,
                    bottom: otherBottom
                } = fakeOpenedPanel(otherPanel.item.mapToItem(Window.window.contentItem, 0, 0, otherPanel.item.width, otherPanel.item.height));

                if (!(panelRight <= otherLeft || panelLeft >= otherRight || panelBottom <= otherTop || panelTop >= otherBottom)) {
                    otherPanel.close();

                    console.log(`Closed ${otherPanel.name} because it overlapped with ${panel.name}`);
                    // console.log(`panel [${panel.name}]: left=${panelLeft}, top=${panelTop}, right=${panelRight}, bottom=${panelBottom}, height=${panel.item.height}, width=${panel.item.width}`);
                    // console.log(`otherPanel [${otherPanel.name}]: left=${otherLeft}, top=${otherTop}, right=${otherRight}, bottom=${otherBottom}, height=${otherPanel.item.height}, width=${otherPanel.item.width}`);

                    activePanels.splice(j, 1); // Remove the closed panel from the list
                    j--; // Adjust index since we removed an item
                }
            }
        }
    }

    function closeAllTemporaryPanels(): void {
        screenState.osdTemporary = false;
        screenState.dashboardTemporary = false;
        screenState.utilitiesTemporary = false;
        screenState.sidebarTemporary = false;
        screenState.sessionTemporary = false;
        screenState.launcherTemporary = false;
    }

    anchors.fill: parent
    acceptedButtons: fullscreen ? Qt.NoButton : Qt.AllButtons
    hoverEnabled: true

    onPressed: event => dragStart = Qt.point(event.x, event.y)
    onContainsMouseChanged: {
        if (containsMouse)
            return;

        closeAllTemporaryPanels();

        if (canDismissPopouts()) {
            popouts.hasCurrent = false;
            bar.closeTray();
        }

        if (Config.bar.showOnHover)
            bar.isHovered = false;
    }

    onPositionChanged: event => {
        if (popouts.isDetached)
            return;

        if (fullscreen) {
            handleOsd(event.x, event.y);
        } else {
            const dragX = event.x - dragStart.x;
            const dragY = event.y - dragStart.y;

            nextState.reset();

            // handleBar(event.x, event.y, dragX, dragY);
            handleLauncher(event.x, event.y, dragY);
            handleSidebar(event.x, event.y);
            handleUtilities(event.x, event.y);
            handleDashboard(event.x, event.y, dragX, dragY);
            handleOsd(event.x, event.y);
            handleSession(event.x, event.y);
            handlePopouts(event.x, event.y);

            handleOverlap(nextState);

            nextState.apply();
        }

    // console.log(`osd=${screenState.osd ? "✅️" : "❌"}|${screenState.osdTemporary ? "✅️" : "❌"}, dashboard=${screenState.dashboard ? "✅️" : "❌"}|${screenState.dashboardTemporary ? "✅️" : "❌"}, utilities=${screenState.utilities ? "✅️" : "❌"}|${screenState.utilitiesTemporary ? "✅️" : "❌"}, sidebar=${screenState.sidebar ? "✅️" : "❌"}|${screenState.sidebarTemporary ? "✅️" : "❌"}, session=${screenState.session ? "✅️" : "❌"}|${screenState.sessionTemporary ? "✅️" : "❌"}, launcher=${screenState.launcher ? "✅️" : "❌"}|${screenState.launcherTemporary ? "✅️" : "❌"}`);
    }

    QtObject {
        id: nextState

        property bool osd
        property bool osdTemporary
        property bool dashboard
        property bool dashboardTemporary
        property bool utilities
        property bool utilitiesTemporary
        property bool sidebar
        property bool sidebarTemporary
        property bool session
        property bool sessionTemporary
        property bool launcher
        property bool launcherTemporary

        function reset(): void {
            for (const key in nextState)
                if (nextState.hasOwnProperty(key) && typeof nextState[key] === "boolean" && nextState[key] !== root.screenState[key])
                    nextState[key] = root.screenState[key];
        }

        function apply(): void {
            for (const key in nextState)
                if (nextState.hasOwnProperty(key) && typeof nextState[key] === "boolean" && nextState[key] !== root.screenState[key])
                    root.screenState[key] = nextState[key];
        }
    }
}
