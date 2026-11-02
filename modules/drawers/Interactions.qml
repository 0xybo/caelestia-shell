import QtQml
import QtQuick
import QtQuick.Controls
import Quickshell
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.modules.bar as Bar
import qs.modules.bar.popouts as BarPopouts
import qs.modules.drawers as Drawers

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

    function inPanelArea(panel: Drawers.Panel, x: real, y: real): bool {
        // for (let child of (panel.children.length ? panel.children : [panel])) {
        //     if (!child.visible)
        //         continue;

        //     // console.log(`Child=${child}, isLoader=${child instanceof Loader}, sourceComponent=${child.sourceComponent}, item=${child.item}`);

        //     // If Loader, check the loaded item instead
        //     // if (child instanceof Loader && child.item)
        //     //     child = child.item;

        //     const childPos = child.mapToItem(Window.window.contentItem, 0, 0);

        //     if (x >= childPos.x && x <= childPos.x + child.width && y >= childPos.y && y <= childPos.y + child.height)
        //         return "inverted" in child ? !child.inverted : true;
        // }
        // return false;
        const contains = panel.trigger.containsMouse(x, y);
        console.log(`Checking if point (${Math.round(x)}, ${Math.round(y)}) is in panel area of ${panel.name}: ${contains ? "✅️" : "❌"}`);
        return contains;
    }

    function canDismissPopouts(): bool {
        return !popouts.currentName.startsWith("traymenu") || ((popouts.current as StackView)?.depth ?? 0) <= 1;
    }

    function handleOsd(x: real, y: real): void {
        if (panels.osd.timerRunning)
            return;

        nextScreenState.osdTemporary = inPanelArea(panels.osdTrigger, x, y);
    }

    function handleUtilities(x: real, y: real): void {
        const inUtilitiesArea = inPanelArea(panels.utilitiesTrigger, x, y);
        nextScreenState.utilitiesTemporary = inUtilitiesArea;
        if (Config.utilities.alsoShowSidebar && inUtilitiesArea)
            nextScreenState.sidebarTemporary = true;
    }

    function handleSidebar(x: real, y: real): void {
        if (inPanelArea(panels.sidebar, x, y))
            nextScreenState.sidebarTemporary = true;
        else {
            const inOsdArea = Config.sidebar.position === Config.osd.position && (nextScreenState.osd || nextScreenState.osdTemporary);
            const inSessionArea = Config.sidebar.position === HorizontalPosition.Right && (nextScreenState.session || nextScreenState.sessionTemporary);

            if (!inOsdArea && !inSessionArea)
                nextScreenState.sidebarTemporary = false;
        }
    }

    function handleDashboard(x: real, y: real, dragX: real, dragY: real): void {
        if (inPanelArea(panels.dashboardTrigger, x, y))
            nextScreenState.dashboardTemporary = true;
        else {
            const inOsdArea = ((Config.dashboard.position === DashboardPosition.Left && Config.osd.position === HorizontalPosition.Left) || (Config.dashboard.position === DashboardPosition.Right)) && nextScreenState.osd || nextScreenState.osdTemporary;

            if (!inOsdArea)
                nextScreenState.dashboardTemporary = false;
        }
    }

    function handleLauncher(x: real, y: real, dragY: real): void {
        nextScreenState.launcherTemporary = inPanelArea(panels.launcherTrigger, x, y);
    }

    function handlePopouts(x: real, y: real): void {
        if (geometry.barContains(x, y))
            bar.checkPopout(geometry.axisPos(x, y));
    }

    function getActivePanels() {
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
        if (nextScreenState.session || nextScreenState.sessionTemporary)
            activePanels.push({
                name: "session",
                item: panels.sessionWrapper,
                close: () => nextScreenState.session = nextScreenState.sessionTemporary = false
            });
        if (nextScreenState.dashboard || nextScreenState.dashboardTemporary)
            activePanels.push({
                name: "dashboard",
                item: panels.dashboardTrigger,
                close: () => nextScreenState.dashboard = nextScreenState.dashboardTemporary = false
            });
        if (nextScreenState.utilities || nextScreenState.utilitiesTemporary)
            activePanels.push({
                name: "utilities",
                item: panels.utilitiesTrigger,
                close: () => nextScreenState.utilities = nextScreenState.utilitiesTemporary = false
            });
        if (nextScreenState.sidebar || nextScreenState.sidebarTemporary)
            activePanels.push({
                name: "sidebar",
                item: panels.sidebarTrigger,
                close: () => nextScreenState.sidebar = nextScreenState.sidebarTemporary = false
            });
        if (nextScreenState.launcher || nextScreenState.launcherTemporary)
            activePanels.push({
                name: "launcher",
                item: panels.launcherTrigger,
                close: () => nextScreenState.launcher = nextScreenState.launcherTemporary = false
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

    function handleOverlap(): void {
        const activePanels = getActivePanels();

        for (let i = 0; i < activePanels.length; i++) {
            const panel = activePanels[i];
            for (let j = 0; j < activePanels.length; j++) {
                const otherPanel = activePanels[j];

                if (panel === otherPanel)
                    continue;
                if (Config.utilities.alsoShowSidebar && //
                panel.name === "sidebar" && otherPanel.name === "utilities" || //
                panel.name === "utilities" && otherPanel.name === "sidebar" || //
                panel.name === "session" && (otherPanel.name === "sidebar" || otherPanel.name === "utilities") || //
                otherPanel.name === "session" && (panel.name === "sidebar" || panel.name === "utilities")) //
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

                if (!(//
                    panelRight <= otherLeft || //
                    panelLeft >= otherRight || //
                    panelBottom <= otherTop || //
                    panelTop >= otherBottom //
                )) {
                    // console.log(`Closing ${otherPanel.name} due to overlap with ${panel.name}`);
                    // console.debug(`Panel ${panel.name} geometry: left=${Math.round(panelLeft)}, top=${Math.round(panelTop)}, right=${Math.round(panelRight)}, bottom=${Math.round(panelBottom)}`);
                    // console.debug(`Panel ${otherPanel.name} geometry: left=${Math.round(otherLeft)}, top=${Math.round(otherTop)}, right=${Math.round(otherRight)}, bottom=${Math.round(otherBottom)}`);
                    // console.log(`Current mouse position: x=${root.mouseX}, y=${root.mouseY}`);

                    otherPanel.close();

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

        nextScreenState.reset();

        if (fullscreen) {
            handleOsd(event.x, event.y);
        } else {
            const dragX = event.x - dragStart.x;
            const dragY = event.y - dragStart.y;

            // handleBar(event.x, event.y, dragX, dragY);
            // handleOsd(event.x, event.y);
            // handleLauncher(event.x, event.y, dragY);
            // handleDashboard(event.x, event.y, dragX, dragY);
            handleSidebar(event.x, event.y);
            // handleUtilities(event.x, event.y);
            // handlePopouts(event.x, event.y);

            // handleOverlap();
        }

        // console.log(`osd=${nextScreenState.osd ? "✅️" : "❌"}|${nextScreenState.osdTemporary ? "✅️" : "❌"}, dashboard=${nextScreenState.dashboard ? "✅️" : "❌"}|${nextScreenState.dashboardTemporary ? "✅️" : "❌"}, utilities=${nextScreenState.utilities ? "✅️" : "❌"}|${nextScreenState.utilitiesTemporary ? "✅️" : "❌"}, sidebar=${nextScreenState.sidebar ? "✅️" : "❌"}|${nextScreenState.sidebarTemporary ? "✅️" : "❌"}, session=${nextScreenState.session ? "✅️" : "❌"}|${nextScreenState.sessionTemporary ? "✅️" : "❌"}, launcher=${nextScreenState.launcher ? "✅️" : "❌"}|${nextScreenState.launcherTemporary ? "✅️" : "❌"}`);

        nextScreenState.apply();
    }

    QtObject {
        id: nextScreenState

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

        property list<variant> properties: [ //
            ["osd", [root.screenState, "osd"]] //
            , ["osdTemporary", [root.screenState, "osdTemporary"]] //
            , ["dashboard", [root.screenState, "dashboard"]] //
            , ["dashboardTemporary", [root.screenState, "dashboardTemporary"]] //
            , ["utilities", [root.screenState, "utilities"]] //
            , ["utilitiesTemporary", [root.screenState, "utilitiesTemporary"]] //
            , ["sidebar", [root.screenState, "sidebar"]] //
            , ["sidebarTemporary", [root.screenState, "sidebarTemporary"]] //
            , ["session", [root.screenState, "session"]] //
            , ["sessionTemporary", [root.screenState, "sessionTemporary"]] //
            , ["launcher", [root.screenState, "launcher"]] //
            , ["launcherTemporary", [root.screenState, "launcherTemporary"]] //
        ]

        Component.onCompleted: reset()

        function reset(): void {
            properties.map(p => nextScreenState[p[0]] = p[1][0][p[1][1]]);
        }

        function apply(): void {
            properties.map(p => p[1][0][p[1][1]] = nextScreenState[p[0]]);
        }
    }
}
