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
import qs.modules.bar.popouts as BarPopouts
import qs.modules.utilities.toasts as Toasts

Item {
    id: root

    required property ShellScreen screen
    required property ScreenState screenState
    required property Bar.BarWrapper bar
    required property EdgeGeometry geometry
    required property real borderThickness

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
        anchors.left: root.geometry.sidebarOnLeft ? parent.left : undefined
        anchors.right: root.geometry.sidebarOnLeft ? undefined : parent.right
        anchors.leftMargin: root.geometry.sidebarOnLeft ? sidebar.width * (1 - sidebar.offsetScale) : 0
        anchors.rightMargin: root.geometry.sidebarOnLeft ? 0 : sidebar.width * (1 - sidebar.offsetScale)
        clip: sidebar.visible

        implicitWidth: session.implicitWidth * (1 - session.offsetScale)
        implicitHeight: session.implicitHeight

        Session.Wrapper {
            id: session

            screenState: root.screenState
            sidebarVisible: sidebar.visible
            onLeft: root.geometry.sidebarOnLeft

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

        // Keep clear of the sidebar/session when they share the OSD's side
        readonly property real edgeShift: root.geometry.osdOnLeft ? (root.geometry.sidebarOnLeft ? sidebar.width * (1 - sidebar.offsetScale) : 0) : (sessionWrapper.anchors.rightMargin + session.width * (1 - session.offsetScale))

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: root.geometry.osdOnLeft ? parent.left : undefined
        anchors.right: root.geometry.osdOnLeft ? undefined : parent.right
        anchors.leftMargin: root.geometry.osdOnLeft ? edgeShift : 0
        anchors.rightMargin: root.geometry.osdOnLeft ? 0 : edgeShift
        clip: sidebar.visible || session.visible

        implicitWidth: osd.implicitWidth * (1 - osd.offsetScale)
        implicitHeight: osd.implicitHeight

        Osd.Wrapper {
            id: osd

            screen: root.screen
            screenState: root.screenState
            sidebarOrSessionVisible: sidebar.visible || session.visible
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

    Utilities.Wrapper {
        id: utilities

        screenState: root.screenState
        popouts: popoutsWrapper.content
        position: root.geometry.effectiveUtilitiesPosition
    }

    Toasts.Toasts {
        id: toasts

        anchors.bottom: sidebar.visible ? parent.bottom : utilities.top
        anchors.left: root.geometry.sidebarOnLeft ? sidebar.right : undefined
        anchors.right: root.geometry.sidebarOnLeft ? undefined : sidebar.left
        anchors.margins: Tokens.padding.medium
    }

    Sidebar.Wrapper {
        id: sidebar

        screenState: root.screenState
        onLeft: root.geometry.sidebarOnLeft

        anchors.top: root.geometry.utilitiesOnTop ? utilities.bottom : notifications.bottom
        anchors.bottom: root.geometry.utilitiesOnTop ? parent.bottom : (root.geometry.utilitiesOnRight ? utilities.top : parent.bottom)
        anchors.left: root.geometry.sidebarOnLeft ? parent.left : undefined
        anchors.right: root.geometry.sidebarOnLeft ? undefined : parent.right
        anchors.topMargin: -notifications.anchors.topMargin
    }
}
