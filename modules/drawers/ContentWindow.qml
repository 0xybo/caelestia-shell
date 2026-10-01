pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Caelestia.Blobs
import Caelestia.Config
import qs.components
import qs.components.containers
import qs.services
import qs.modules.bar

StyledWindow {
    id: root

    readonly property alias bar: bar
    readonly property alias interactionWrapper: interactions
    readonly property alias geometry: geometry

    readonly property ScreenState screenState: ShellState.forScreen(screen)

    readonly property HyprlandMonitor monitor: Hypr.monitorFor(screen)
    readonly property bool hasSpecialWorkspace: (monitor?.lastIpcObject.specialWorkspace?.name.length ?? 0) > 0
    readonly property bool hasFullscreenOnNormalWs: monitor?.activeWorkspace?.toplevels.values.some(t => t.lastIpcObject.fullscreen > 1) ?? false
    readonly property bool hasFullscreen: {
        if (hasSpecialWorkspace) {
            const specialName = monitor?.lastIpcObject.specialWorkspace?.name;
            if (!specialName)
                return false;
            const specialWs = Hypr.workspaces.values.find(ws => ws.name === specialName);
            return specialWs?.toplevels.values.some(t => t.lastIpcObject.fullscreen > 1) ?? false;
        }
        return hasFullscreenOnNormalWs;
    }

    property real fsTransitionProg: hasFullscreen ? 1 : 0
    readonly property real sdfBorderOffset: 2 * fsTransitionProg // SDFs joins are not exact, so offset by 2px to ensure nothing shows
    readonly property real borderThickness: contentItem.Config.border.thickness * (1 - fsTransitionProg)
    readonly property real borderRounding: contentItem.Config.border.rounding * (1 - fsTransitionProg)
    readonly property real shadowOpacity: 0.7 * (1 - fsTransitionProg)
    readonly property real borderLayoutThickness: hasFullscreen ? 0 : contentItem.Config.border.thickness

    property color surfaceColour: Colours.tPalette.m3surface

    readonly property int dragMaskPadding: {
        if (focusGrab.active || panels.popouts.isDetached)
            return 0;

        if (monitor?.lastIpcObject.specialWorkspace?.name || monitor?.activeWorkspace?.lastIpcObject.windows > 0)
            return 0;

        const thresholds = [];
        for (const panel of ["dashboard", "launcher", "session", "sidebar"])
            if (contentItem.Config[panel].enabled)
                thresholds.push(contentItem.Config[panel].dragThreshold);
        return Math.max(...thresholds);
    }

    onHasFullscreenChanged: {
        screenState.launcher = false;
        screenState.session = false;
        screenState.dashboard = false;
        panels.popouts.close();
    }

    name: "drawers"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: (fsTransitionProg > 0 && contentItem.Config.general.showOverFullscreen) || (hasSpecialWorkspace && hasFullscreenOnNormalWs) ? WlrLayer.Overlay : WlrLayer.Top
    WlrLayershell.keyboardFocus: screenState.launcher || screenState.session ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    mask: hasFullscreen ? emptyRegion : regions

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    Behavior on fsTransitionProg {
        Anim {}
    }

    Behavior on surfaceColour {
        CAnim {}
    }

    EdgeGeometry {
        id: geometry

        bar: bar
        win: root
        configPosition: root.contentItem.Config.bar.position
        dashboardPosition: root.contentItem.Config.bar.dashboardPosition
        configUtilitiesPosition: root.contentItem.Config.utilities.position
        osdPosition: root.contentItem.Config.osd.position
        sidebarPosition: root.contentItem.Config.sidebar.position
    }

    Region {
        id: emptyRegion

        x: panels.notifications.x + geometry.insetLeft(root.borderThickness)
        y: panels.notifications.y + geometry.insetTop(root.borderThickness)
        width: panels.notifications.width
        height: panels.notifications.height

        Region {
            x: geometry.osdOnLeft ? 0 : root.width - width
            y: panels.osdWrapper.y + root.borderThickness
            width: panels.osdWrapper.width * (1 - panels.osd.offsetScale) + root.borderThickness
            height: panels.osd.height
        }
    }

    Regions {
        id: regions

        geometry: geometry
        panels: panels
        win: root
    }

    HyprlandFocusGrab {
        id: focusGrab

        active: {
            const s = root.screenState;
            const conf = root.contentItem.Config;
            if ((s.launcher && conf.launcher.enabled) || (s.session && conf.session.enabled) || (s.sidebar && conf.sidebar.enabled))
                return true;
            if (!conf.dashboard.showOnHover && s.dashboard && conf.dashboard.enabled)
                return true;
            if (panels.popouts.currentName.startsWith("traymenu") && (panels.popouts.current as StackView)?.depth > 1)
                return true;
            return false;
        }
        windows: [root]
        onCleared: {
            root.screenState.launcher = false;
            root.screenState.session = false;
            root.screenState.sidebar = false;
            root.screenState.dashboard = false;
            panels.popouts.hasCurrent = false;
            bar.closeTray();
        }
    }

    StyledRect {
        anchors.fill: parent
        opacity: (root.screenState.session && Config.session.enabled) || panels.popouts.detachedMode !== "" ? 0.5 : 0
        color: Colours.palette.m3scrim

        Behavior on opacity {
            Anim {
                type: Anim.SlowEffects
            }
        }
    }

    Item {
        anchors.fill: parent
        opacity: root.surfaceColour.a
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            blurMax: 15
            shadowColor: Qt.alpha(Colours.palette.m3shadow, Math.max(0, root.shadowOpacity))
        }

        BlobGroup {
            id: blobGroup

            color: root.surfaceColour
            smoothing: root.contentItem.Config.border.smoothing
        }

        BlobInvertedRect {
            anchors.fill: parent
            anchors.margins: -50 // Make border thicker to smooth out bulge from closed drawers
            group: blobGroup
            radius: root.borderRounding
            borderLeft: geometry.insetLeft(root.borderThickness) - anchors.margins - root.sdfBorderOffset
            borderRight: geometry.insetRight(root.borderThickness) - anchors.margins - root.sdfBorderOffset
            borderTop: geometry.insetTop(root.borderThickness) - anchors.margins - root.sdfBorderOffset
            borderBottom: geometry.insetBottom(root.borderThickness) - anchors.margins - root.sdfBorderOffset
        }

        PanelBg {
            id: dashBg

            panel: panels.dashboard
            offsetScale: panels.dashboard.offsetScale
            deformAmount: 0.1
            x: panels.dashboard.x + geometry.insetLeft(root.borderThickness)
        }

        PanelBg {
            id: launcherBg

            panel: panels.launcher
            offsetScale: panels.launcher.offsetScale
            deformAmount: 0.1
        }

        PanelBg {
            id: sessionBg

            panel: panels.sessionWrapper
            offsetScale: panels.session.offsetScale
            deformAmount: 0.2
            x: panels.sessionWrapper.x + panels.session.x + geometry.insetLeft(root.borderThickness)
            implicitWidth: panels.session.width
        }

        PanelBg {
            id: sidebarBg

            // Corners square off as the panel slides away, so it can pass under the border
            readonly property real cornerRadius: Math.max(0, Math.min(1, panels.sidebar.offsetScale / 0.3)) * radius

            panel: panels.sidebar
            offsetScale: panels.sidebar.offsetScale
            deformAmount: 0.03
            // The 2px compensates SDF rounding on a free bottom edge. Stacked against the
            // utilities panel that edge is covered, and the 2px would poke through it and smin
            // into a bump on the inner border.
            implicitHeight: panel.height * (1 / rawDeformMatrix.m22) + (panels.sidebar.utilitiesBelow ? 0 : 2)
            // Where the two panels meet, both sides square off so the smin bridge is a clean
            // joint instead of a bulge past the border
            bottomLeftRadius: geometry.sidebarOnLeft || panels.sidebar.utilitiesBelow ? 0 : cornerRadius
            bottomRightRadius: !geometry.sidebarOnLeft || panels.sidebar.utilitiesBelow ? 0 : cornerRadius
            topLeftRadius: panels.sidebar.utilitiesAbove ? 0 : -1
            topRightRadius: panels.sidebar.utilitiesAbove ? 0 : -1
        }

        PanelBg {
            id: osdBg

            panel: panels.osdWrapper
            offsetScale: panels.osd.offsetScale
            deformAmount: 0.25
            x: panels.osdWrapper.x + panels.osd.x + geometry.insetLeft(root.borderThickness)
            implicitWidth: panels.osd.width
        }

        PanelBg {
            id: notifsBg

            panel: panels.notifications
        }

        PanelBg {
            id: utilsBg

            panel: panels.utilities
            offsetScale: panels.utilities.offsetScale
            deformAmount: 0.15
            // Square off the edge facing the sidebar, see sidebarBg
            topLeftRadius: panels.sidebar.utilitiesAbove ? 0 : -1
            topRightRadius: panels.sidebar.utilitiesAbove ? 0 : -1
            bottomLeftRadius: panels.sidebar.utilitiesBelow ? 0 : -1
            bottomRightRadius: panels.sidebar.utilitiesBelow ? 0 : -1
        }

        PanelBg {
            id: popoutBg

            // Extra extent to prevent axis movement deformation partially detaching panel from bar
            property real extraExtent: panels.popouts.isDetached ? 0 : 0.2
            readonly property real extraX: geometry.horizontal || geometry.barOnRight ? 0 : -panels.popouts.width * extraExtent

            panel: panels.popoutsWrapper
            offsetScale: panels.popoutsWrapper.offsetScale
            deformAmount: panels.popouts.isDetached ? 0.05 : panels.popouts.hasCurrent ? 0.15 : 0.1
            x: panels.popoutsWrapper.x + panels.popouts.x + geometry.insetLeft(root.borderThickness) + extraX
            y: panels.popoutsWrapper.y + panels.popouts.y + geometry.insetTop(root.borderThickness) - (geometry.barOnTop ? panels.popouts.height * extraExtent : 0)
            implicitWidth: panels.popouts.width * (geometry.horizontal ? 1 : 1 + extraExtent)
            implicitHeight: panels.popouts.height * (geometry.horizontal ? 1 + extraExtent : 1)

            Behavior on extraExtent {
                Anim {}
            }
        }
    }

    Interactions {
        id: interactions

        screen: root.screen
        popouts: panels.popouts
        screenState: root.screenState
        panels: panels
        bar: bar
        geometry: geometry
        borderThickness: root.borderLayoutThickness
        fullscreen: root.hasFullscreen

        Panels {
            id: panels

            screen: root.screen
            screenState: root.screenState
            bar: bar
            geometry: geometry
            borderThickness: root.borderThickness

            utilities.deformMatrix: utilsBg.rawDeformMatrix

            dashboard.transform: Matrix4x4 {
                matrix: dashBg.deformMatrix
            }
            launcher.transform: Matrix4x4 {
                matrix: launcherBg.deformMatrix
            }
            session.transform: Matrix4x4 {
                matrix: sessionBg.deformMatrix
            }
            sidebar.transform: Matrix4x4 {
                matrix: sidebarBg.deformMatrix
            }
            osd.transform: Matrix4x4 {
                matrix: osdBg.deformMatrix
            }
            notifications.transform: Matrix4x4 {
                matrix: notifsBg.deformMatrix
            }
            utilities.transform: Matrix4x4 {
                matrix: utilsBg.deformMatrix
            }
            popouts.transform: Matrix4x4 {
                matrix: popoutBg.deformMatrix
            }
        }

        BarWrapper {
            id: bar

            x: geometry.barOnRight ? parent.width - width : 0
            y: geometry.barOnBottom ? parent.height - height : 0

            width: geometry.horizontal ? parent.width : implicitWidth
            height: geometry.horizontal ? implicitHeight : parent.height

            screen: root.screen
            screenState: root.screenState
            popouts: panels.popouts
            position: geometry.position
            powerTriggersUtilities: geometry.powerTriggersUtilities
            activeWindowHover: geometry.activeWindowHover

            fullscreen: root.hasFullscreen
        }
    }

    ShellState.ComponentRef {
        screen: root.screen
        slot: "rootWindow"
        component: root
    }

    ShellState.ComponentRef {
        screen: root.screen
        slot: "interactionWrapper"
        component: interactions
    }

    ShellState.ComponentRef {
        screen: root.screen
        slot: "bar"
        component: bar
    }

    ShellState.ComponentRef {
        screen: root.screen
        slot: "panels"
        component: panels
    }

    component PanelBg: BlobRect {
        required property Item panel
        // Mirrors the panel's own offsetScale: 0 while on screen, 1 once fully parked off it.
        // Panels that do not slide (notifications) leave this at 0, since their own size
        // already collapses when closed.
        property real offsetScale: 0
        property real deformAmount: 0.15
        // A parked panel is only parked 5px off screen, well inside the border's smoothing
        // band, so the border reads it as a panel intruding and dissolves there. Collapsing to
        // zero size drops this rect from the group entirely, which is what the shader already
        // does for zero-size rects.
        readonly property bool parked: offsetScale >= 1

        group: blobGroup
        x: panel.x + geometry.insetLeft(root.borderThickness)
        y: panel.y + geometry.insetTop(root.borderThickness)
        implicitWidth: panel.width
        implicitHeight: panel.height
        width: parked ? 0 : implicitWidth
        height: parked ? 0 : implicitHeight
        radius: Tokens.rounding.extraLarge
        deformScale: (deformAmount * Config.appearance.deformScale) / 10000
    }
}
