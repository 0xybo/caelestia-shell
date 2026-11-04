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

    readonly property bool sidebarSharesNotifications: root.geometry.sidebarOnRight
    readonly property bool sidebarSharesUtilities: root.geometry.sidebarOnLeft ? root.geometry.utilitiesOnLeft : root.geometry.utilitiesOnRight
    readonly property bool sidebarUtilitiesAbove: root.sidebarSharesUtilities && root.geometry.utilitiesOnTop
    readonly property bool sidebarUtilitiesBelow: root.sidebarSharesUtilities && root.geometry.utilitiesOnBottom

    readonly property alias osd: osd
    readonly property alias osdWrapper: osdWrapper
    readonly property alias notifications: notifications
    readonly property alias session: session
    readonly property alias sessionWrapper: sessionWrapper
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
        osdPanel: osdWrapper
        sessionPanel: sessionWrapper
        utilitiesPanel: utilities

        anchors.top: parent.top
        anchors.right: parent.right
    }

    Item {
        id: sessionWrapper

        anchors.verticalCenter: parent.verticalCenter
        x: root.geometry.sidebarOnLeft ? sidebar.width * (1 - sidebar.offsetScale) : parent.width - implicitWidth - sidebar.width * (1 - sidebar.offsetScale)
        clip: sidebar.visible

        implicitWidth: session.implicitWidth * (1 - session.offsetScale)
        implicitHeight: session.implicitHeight

        Session.Wrapper {
            id: session

            screenState: root.screenState
            sidebarVisible: root.screenState.sidebar || root.screenState.sidebarTemporary

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Launcher.Wrapper {
        id: launcher

        screen: root.screen
        screenState: root.screenState
        panels: root

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

    Dashboard.Wrapper {
        id: dashboard

        screenState: root.screenState
        position: root.geometry.effectiveDashboardPosition
    }

    Item {
        id: osdWrapper

        readonly property bool sessionOnOsdSide: root.geometry.sidebarOnLeft === root.geometry.osdOnLeft
        readonly property bool sidebarOnOsdSide: root.geometry.sidebarOnLeft === root.geometry.osdOnLeft
        readonly property bool dashboardOnOsdSide: (root.geometry.dashboardOnLeft && root.geometry.osdOnLeft) || (root.geometry.dashboardOnRight && root.geometry.osdOnRight)
        readonly property real edgeShift: (sidebarOnOsdSide ? sidebar.width * (1 - sidebar.offsetScale) + (sessionOnOsdSide ? session.width * (1 - session.offsetScale) : 0) : 0) + (dashboardOnOsdSide ? dashboard.width * (1 - dashboard.offsetScale) : 0)

        readonly property real visibleWidth: osd.width * (1 - osd.offsetScale)

        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: root.geometry.osdOnLeft ? edgeShift : 0
        anchors.rightMargin: root.geometry.osdOnLeft ? 0 : edgeShift
        x: root.geometry.osdOnLeft ? edgeShift : parent.width - visibleWidth - edgeShift
        clip: sidebar.visible || session.visible

        implicitWidth: visibleWidth
        implicitHeight: osd.implicitHeight

        Osd.Wrapper {
            id: osd

            screen: root.screen
            screenState: root.screenState
            sidebarVisible: root.screenState.sidebar || root.screenState.sidebarTemporary
            besideSession: osdWrapper.sessionOnOsdSide && (root.screenState.session || root.screenState.sessionTemporary)
            besideSidebar: osdWrapper.sidebarOnOsdSide && (root.screenState.sidebar || root.screenState.sidebarTemporary)
            besideDashboard: osdWrapper.dashboardOnOsdSide && (root.screenState.dashboard || root.screenState.dashboardTemporary)
            onLeft: root.geometry.osdOnLeft

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    BarPopouts.ClipWrapper {
        id: popoutsWrapper

        screen: root.screen
        position: root.geometry.position
        borderThickness: root.borderThickness
    }

    Drawers.Panel {
        id: utilities

        name: "utilities"
        shouldBeActive: root.screenState.utilities && Config.utilities.enabled

        geometry: root.geometry

        verticalAlignment: Drawers.Panel.Alignment.End
        horizontalAlignment: root.geometry.utilitiesOnLeft ? Drawers.Panel.Alignment.Start : Drawers.Panel.Alignment.End
        slidingDirection: Drawers.Panel.SlidingDirection.Vertical

        content: utilitiesContent
        trigger: utilitiesTrigger

        Utilities.Wrapper {
            id: utilitiesContent

            screenState: root.screenState
            offsetScale: utilities.offsetScale
            popouts: popoutsWrapper.content
            position: root.geometry.effectiveUtilitiesPosition

            anchors.fill: parent
            visible: !utilities.closed
        }

        Drawers.Trigger {
            id: utilitiesTrigger

            Drawers.TriggerPart {
                anchors.fill: parent
            }
        }
    }

    Toasts.Toasts {
        id: toasts

        anchors.bottom: sidebar.visible ? parent.bottom : utilities.top
        anchors.left: root.geometry.sidebarOnLeft ? (sidebar.visible ? sidebar.right : parent.left) : undefined
        anchors.right: root.geometry.sidebarOnLeft ? undefined : (sidebar.visible ? sidebar.left : parent.right)
        anchors.margins: Tokens.padding.medium
    }

    Drawers.Panel {
        id: sidebar

        name: "sidebar"
        shouldBeActive: (root.screenState.sidebar || root.screenState.sidebarTemporary) && Config.sidebar.enabled

        geometry: root.geometry
        
        height: parent.height
        verticalAlignment: Drawers.Panel.Alignment.Center
        horizontalAlignment: root.geometry.sidebarOnLeft ? Drawers.Panel.Alignment.Start : Drawers.Panel.Alignment.End
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

        Drawers.Trigger {
            id: sidebarTrigger

            Drawers.TriggerPart {
                active: !sidebar.closed
                invert: root.geometry.barBesideSidebar

                anchors.bottom: parent.bottom
                // anchors.left: root.geometry.sidebarOnLeft ? undefined : parent.right
                // anchors.right: root.geometry.sidebarOnLeft ? parent.left : undefined
                x: {
                    if (root.geometry.sidebarOnLeft) 
                    return 0;
                    
                    return parent.width * (1 - sidebar.offsetScale);
                }

                height: parent.height - Config.sidebar.minHoverThreshold
                width: Config.border.thickness * 2 + root.geometry.insetRight(0)
            }

            Drawers.TriggerPart {
                active: !sidebar.closed
                anchors.fill: parent
            }

            Drawers.TriggerPart {
                anchors.top: parent.top
                anchors.left: parent.right

                height: Config.sidebar.minHoverThreshold
                width: Config.border.thickness * 2 + root.geometry.insetRight(0)
            }
        }
    }
}
