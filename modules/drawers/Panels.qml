import QtQuick
import Quickshell
import Caelestia.Config
import qs.components
import qs.modules.bar as Bar
import qs.modules.dashboard as Dashboard
import qs.modules.launcher as Launcher
import qs.modules.notifications as Notifications
import qs.modules.osd as Osd
import qs.modules.session as Session
import qs.modules.sidebar as Sidebar
import qs.modules.utilities as Utilities
import qs.modules.drawers as Drawers
import qs.modules.bar.popouts as BarPopouts
import qs.modules.utilities.toasts as Toasts

Item {
    id: root

    required property ShellScreen screen
    required property ScreenState screenState
    required property Bar.BarWrapper bar
    required property EdgeGeometry geometry
    required property real borderThickness

    readonly property bool sidebarSharesNotifications: root.geometry.sidebar.onRight
    readonly property bool sidebarSharesUtilities: root.geometry.sidebar.onLeft ? root.geometry.utilities.onLeft : root.geometry.utilities.onRight
    readonly property bool sidebarUtilitiesAbove: root.sidebarSharesUtilities && root.geometry.utilities.onTop
    readonly property bool sidebarUtilitiesBelow: root.sidebarSharesUtilities && root.geometry.utilities.onBottom

    readonly property alias osd: osd
    readonly property alias notifications: notifications
    readonly property alias session: session
    readonly property alias launcher: launcher
    readonly property alias dashboard: dashboard
    readonly property alias popouts: popoutsWrapper.content
    readonly property alias popoutsWrapper: popoutsWrapper
    readonly property alias utilities: utilities
    readonly property alias toasts: toasts
    readonly property alias sidebar: sidebar

    anchors.fill: parent
    anchors.margins: borderThickness
    anchors.leftMargin: geometry.insetLeft(borderThickness)
    anchors.topMargin: geometry.insetTop(borderThickness)
    anchors.rightMargin: geometry.insetRight(borderThickness)
    anchors.bottomMargin: geometry.insetBottom(borderThickness)

    Notifications.Wrapper {
        id: notifications

        screenState: root.screenState
        sidebarPanel: sidebar
        osdPanel: osd
        sessionPanel: session
        utilitiesPanel: utilities

        anchors.top: parent.top
        anchors.right: parent.right
    }

    Toasts.Toasts {
        id: toasts

        anchors.bottom: !sidebar.closed ? parent.bottom : utilities.top
        anchors.left: root.geometry.sidebar.onLeft ? (!sidebar.closed ? sidebar.right : parent.left) : undefined
        anchors.right: root.geometry.sidebar.onRight ? (!sidebar.closed ? sidebar.left : parent.right) : undefined
        anchors.margins: Tokens.padding.medium
    }

    BarPopouts.ClipWrapper {
        id: popoutsWrapper

        screen: root.screen
        position: root.geometry.bar.position
        borderThickness: root.borderThickness
    }

    // ╭────────────────────────────────────────────────────────╮
    // │                         PANELS                         │
    // ╰────────────────────────────────────────────────────────╯

    Drawers.Panel {
        id: session

        name: "session"
        shouldBeActive: root.screenState.shouldSessionVisible

        verticalAlignment: Drawers.Panel.Alignment.Center
        horizontalAlignment: root.geometry.sidebar.onLeft ? Drawers.Panel.Alignment.Start : Drawers.Panel.Alignment.End
        slidingDirection: Drawers.Panel.SlidingDirection.Horizontal
        margin: root.geometry.session.besideSidebar ? sidebar.width * (1 - sidebar.offsetScale) : 0

        content: sessionContent
        trigger: sessionTrigger

        Session.Wrapper {
            id: sessionContent

            screenState: root.screenState
            shouldBeActive: session.shouldBeActive
            offsetScale: session.offsetScale
            sidebarVisible: sidebar.shouldBeActive

            anchors.fill: parent
            visible: !session.closed
        }
    }

    Drawers.Panel {
        id: launcher

        name: "launcher"
        shouldBeActive: root.screenState.shouldLauncherVisible

        verticalAlignment: Drawers.Panel.Alignment.End
        horizontalAlignment: Drawers.Panel.Alignment.Center
        slidingDirection: Drawers.Panel.SlidingDirection.Vertical

        content: launcherContent
        trigger: launcherTrigger

        Launcher.Wrapper {
            id: launcherContent

            screen: root.screen
            panels: root
            screenState: root.screenState
            shouldBeActive: launcher.shouldBeActive
            offsetScale: launcher.offsetScale

            anchors.fill: parent
            visible: !launcher.closed
        }
    }

    Drawers.Panel {
        id: dashboard

        name: "dashboard"
        shouldBeActive: root.screenState.shouldDashboardVisible

        verticalAlignment: {
            switch (root.geometry.dashboard.position) {
            case DashboardPosition.Left:
            case DashboardPosition.Right:
                return Drawers.Panel.Alignment.Center;
            case DashboardPosition.Top:
                return Drawers.Panel.Alignment.Start;
            }
        }
        horizontalAlignment: {
            switch (root.geometry.dashboard.position) {
            case DashboardPosition.Left:
                return Drawers.Panel.Alignment.Start;
            case DashboardPosition.Right:
                return Drawers.Panel.Alignment.End;
            case DashboardPosition.Top:
                return Drawers.Panel.Alignment.Center;
            }
        }
        slidingDirection: Drawers.Panel.SlidingDirection.Vertical

        content: dashboardContent
        trigger: dashboardTrigger

        Dashboard.Wrapper {
            id: dashboardContent

            screenState: root.screenState
            offsetScale: dashboard.offsetScale
            position: root.geometry.dashboard.position

            anchors.fill: parent
            visible: !dashboard.closed
        }
    }

    Drawers.Panel {
        id: osd

        name: "osd"
        shouldBeActive: root.screenState.shouldOsdVisible

        verticalAlignment: Drawers.Panel.Alignment.Center
        horizontalAlignment: root.geometry.osd.onLeft ? Drawers.Panel.Alignment.Start : Drawers.Panel.Alignment.End
        slidingDirection: Drawers.Panel.SlidingDirection.Horizontal
        margin: (root.geometry.osd.besideSidebar ? sidebar.width * (1 - sidebar.offsetScale) : 0) + (root.geometry.osd.besideSession ? session.width * (1 - session.offsetScale) : 0) + (root.geometry.osd.besideDashboard ? dashboard.width * (1 - dashboard.offsetScale) : 0)

        content: osdContent
        trigger: osdTrigger

        Osd.Wrapper {
            id: osdContent

            screen: root.screen
            screenState: root.screenState
            offsetScale: osd.offsetScale
            shouldBeActive: osd.shouldBeActive

            sidebarVisible: root.screenState.shouldSidebarVisible
            besideSession: root.geometry.sidebar.onLeft === root.geometry.osd.onLeft && (root.screenState.session || root.screenState.sessionTemporary)
            besideSidebar: root.geometry.osd.besideSidebar && sidebar.shouldBeActive
            besideDashboard: (root.geometry.dashboard.onLeft && root.geometry.osd.onLeft) || (root.geometry.dashboard.onRight && root.geometry.osd.onRight) && (root.screenState.dashboard || root.screenState.dashboardTemporary)
            onLeft: root.geometry.osd.onLeft

            anchors.fill: parent
            visible: !osd.closed
        }
    }

    Drawers.Panel {
        id: utilities

        name: "utilities"
        shouldBeActive: root.screenState.shouldUtilitiesVisible

        verticalAlignment: root.geometry.utilities.onTop ? Drawers.Panel.Alignment.Start : Drawers.Panel.Alignment.End
        horizontalAlignment: root.geometry.utilities.onLeft ? Drawers.Panel.Alignment.Start : Drawers.Panel.Alignment.End
        slidingDirection: Drawers.Panel.SlidingDirection.Vertical

        content: utilitiesContent
        trigger: utilitiesTrigger

        Utilities.Wrapper {
            id: utilitiesContent

            screenState: root.screenState
            offsetScale: utilities.offsetScale
            popouts: popoutsWrapper.content
            position: root.geometry.utilities.position

            anchors.fill: parent
            visible: !utilities.closed
        }
    }

    Drawers.Panel {
        id: sidebar

        name: "sidebar"
        shouldBeActive: (root.screenState.sidebar || root.screenState.sidebarTemporary) && Config.sidebar.enabled

        horizontalAlignment: root.geometry.sidebar.onLeft ? Drawers.Panel.Alignment.Start : Drawers.Panel.Alignment.End
        verticalAlignment: Drawers.Panel.Alignment.Center
        anchors.top: parent.top
        anchors.bottom: root.sidebarSharesUtilities ? utilities.top : parent.bottom
        slidingDirection: Drawers.Panel.SlidingDirection.Horizontal

        content: sidebarContent
        trigger: sidebarTrigger

        Sidebar.Wrapper {
            id: sidebarContent

            screenState: root.screenState
            offsetScale: sidebar.offsetScale

            anchors.fill: parent
            visible: !sidebar.closed
        }
    }

    // ╭────────────────────────────────────────────────────────╮
    // │                        TRIGGERS                        │
    // ╰────────────────────────────────────────────────────────╯

    Drawers.Trigger {
        id: sessionTrigger

        panel: session

        anchors.fill: parent

        Drawers.TriggerPart {
            x: session.x
            y: session.y
            width: session.width
            height: session.height
        }
    }

    Drawers.Trigger {
        id: dashboardTrigger

        panel: dashboard

        anchors.fill: parent

        Drawers.TriggerPart {
            x: dashboard.x - (root.geometry.dashboard.onLeft ? Config.border.thickness * 2 + root.geometry.insetLeft(0) : 0)
            y: dashboard.y - (root.geometry.dashboard.onTop ? Config.border.thickness * 2 + root.geometry.insetTop(0) : 0)
            width: dashboard.width + (root.geometry.dashboard.onRight || root.geometry.dashboard.onLeft ? Config.border.thickness * 2 + root.geometry.insetRight(0) + root.geometry.insetLeft(0) : 0)
            height: dashboard.height + (root.geometry.dashboard.onTop ? Config.border.thickness * 2 + root.geometry.insetTop(0) : 0)
        }
    }

    Drawers.Trigger {
        id: osdTrigger

        panel: osd

        anchors.fill: parent

        Drawers.TriggerPart {
            x: osd.x
            y: osd.y
            width: osd.width * (1 - osd.offsetScale) + Config.border.thickness * 2 - (root.geometry.osd.besideSidebar ? Config.border.thickness / 2 * (osd.offsetScale) : 0)
            height: osd.height
        }
    }

    Drawers.Trigger {
        id: utilitiesTrigger

        panel: utilities

        anchors.fill: parent

        Drawers.TriggerPart {
            x: utilities.x
            y: utilities.y
            width: utilities.width
            height: utilities.height + Config.border.thickness * 2
        }
    }

    Drawers.Trigger {
        id: launcherTrigger

        panel: launcher

        anchors.fill: parent

        Drawers.TriggerPart {
            x: launcher.x
            y: launcher.y
            width: launcher.width
            height: launcher.height + Config.border.thickness * 2
        }
    }

    Drawers.Trigger {
        id: sidebarTrigger

        panel: sidebar

        anchors.fill: parent

        Drawers.TriggerPart {
            active: !sidebar.closed

            x: sidebar.x
            y: sidebar.y
            width: sidebar.width
            height: sidebar.height
        }

        Drawers.TriggerPart {
            active: !sidebar.closed
            subtract: root.geometry.bar.besideSidebar

            anchors.bottom: parent.bottom
            anchors.right: root.geometry.sidebar.onLeft ? parent.left : undefined
            anchors.left: root.geometry.sidebar.onLeft ? undefined : parent.right

            width: Config.border.thickness * 2 + root.geometry.insetRight(0) + root.geometry.insetLeft(0)
            height: parent.height - Config.sidebar.minHoverThreshold
        }

        Drawers.TriggerPart {
            anchors.top: parent.top
            anchors.right: root.geometry.sidebar.onLeft ? parent.left : undefined
            anchors.left: root.geometry.sidebar.onLeft ? undefined : parent.right
            anchors.leftMargin: sidebar.shouldBeActive ? 0 : Config.border.thickness / 2

            width: Config.border.thickness * 2 + root.geometry.insetRight(0) + root.geometry.insetLeft(0)
            height: Config.sidebar.minHoverThreshold
        }
    }
}
