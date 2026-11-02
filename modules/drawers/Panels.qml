import QtQuick
import Quickshell
import Caelestia.Config
import qs.utils
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
import qs.modules.drawers as Drawers

Item {
    id: root

    required property ShellScreen screen
    required property ScreenState screenState
    required property Bar.BarWrapper bar
    required property EdgeGeometry geometry
    required property real borderThickness

    readonly property alias osd: osd
    readonly property alias osdWrapper: osdWrapper
    readonly property alias osdTrigger: osdTrigger
    readonly property alias notifications: notifications
    readonly property alias session: session
    readonly property alias sessionWrapper: sessionWrapper
    readonly property alias launcher: launcher
    readonly property alias launcherTrigger: launcherTrigger
    readonly property alias dashboard: dashboard
    readonly property alias dashboardTrigger: dashboardTrigger
    readonly property alias popouts: popoutsWrapper.content
    readonly property alias popoutsWrapper: popoutsWrapper
    readonly property alias utilities: utilities
    readonly property alias utilitiesTrigger: utilitiesTrigger
    readonly property alias toasts: toasts
    readonly property alias sidebar: sidebar
    // readonly property alias sidebarTrigger: sidebarTrigger

    function barOnLeft(yes: real, no: real): real {
        return Config.bar.position === BarPosition.Left ? yes : no;
    }

    function barOnRight(yes: real, no: real): real {
        return Config.bar.position === BarPosition.Right ? yes : no;
    }

    function barOnTop(yes: real, no: real): real {
        return Config.bar.position === BarPosition.Top ? yes : no;
    }

    function barOnBottom(yes: real, no: real): real {
        return Config.bar.position === BarPosition.Bottom ? yes : no;
    }

    function panelOpened(scale: real, yes: real, no: real): real {
        return scale * no + (1 - scale) * yes;
    }

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
        x: parent.width - implicitWidth - sidebar.width * (1 - sidebar.offsetScale)
        clip: sidebar.visible

        implicitWidth: session.implicitWidth * (1 - session.offsetScale)
        implicitHeight: session.implicitHeight

        Session.Wrapper {
            id: session

            screenState: root.screenState
            sidebarVisible: sidebar.visible

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

    Loader {
        id: launcherTrigger

        active: Config.launcher.showOnHover

        anchors.top: launcher.top
        anchors.left: launcher.left
        anchors.right: launcher.right
        height: launcher.height + Config.border.thickness * 2

        sourceComponent: Item {}
    }

    Dashboard.Wrapper {
        id: dashboard

        screenState: root.screenState
        position: root.geometry.effectiveDashboardPosition
    }

    Item {
        id: dashboardTrigger

        x: {
            switch (Config.dashboard.position) {
            case DashboardPosition.Top:
            case DashboardPosition.Right:
                return dashboard.x;
            case DashboardPosition.Left:
                return dashboard.x - Config.border.thickness * 4 - root.geometry.insetLeft(0) * (1 - dashboard.offsetScale);
            }
        }
        y: {
            switch (Config.dashboard.position) {
            case DashboardPosition.Left:
            case DashboardPosition.Right:
                return dashboard.y;
            case DashboardPosition.Top:
                return dashboard.y - root.geometry.insetTop(Config.border.thickness * dashboard.offsetScale) + Config.border.thickness * (dashboard.offsetScale) - Config.border.thickness * 2 * (1 - dashboard.offsetScale);
            }
        }
        width: {
            switch (Config.dashboard.position) {
            case DashboardPosition.Top:
                return dashboard.width;
            case DashboardPosition.Left:
            case DashboardPosition.Right:
                return dashboard.width + Config.border.thickness * 4 - root.geometry.insetLeft(+Config.border.thickness) * (dashboard.offsetScale) + Config.border.thickness * (dashboard.offsetScale) + root.geometry.insetLeft(0) * (1 - dashboard.offsetScale);
            }
        }
        height: {
            switch (Config.dashboard.position) {
            case DashboardPosition.Top:
                return dashboard.height + Config.border.thickness * 2 * (1 - dashboard.offsetScale) + root.geometry.insetTop(0) * (1 - dashboard.offsetScale);
            case DashboardPosition.Left:
            case DashboardPosition.Right:
                return dashboard.height;
            }
        }
    }

    Item {
        id: osdWrapper

        readonly property bool sessionOnOsdSide: root.geometry.osdOnRight
        readonly property bool sidebarOnOsdSide: Config.sidebar.position === Config.osd.position
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
            sidebarVisible: screenState.sidebar || screenState.sidebarTemporary
            besideSession: osdWrapper.sessionOnOsdSide && screenState.session
            besideSidebar: osdWrapper.sidebarOnOsdSide && screenState.sidebar
            besideDashboard: osdWrapper.dashboardOnOsdSide && screenState.dashboard
            onLeft: root.geometry.osdOnLeft

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Item {
        id: osdTrigger

        anchors.top: osdWrapper.top
        anchors.bottom: osdWrapper.bottom
        x: {
            switch (Config.osd.position) {
            case HorizontalPosition.Left:
                return osdWrapper.x - Config.border.thickness;
            case HorizontalPosition.Right:
                const panelOnOsdSide = (osdWrapper.sidebarOnOsdSide && root.screenState.sidebar || root.screenState.sidebarTemporary) || (osdWrapper.dashboardOnOsdSide && root.screenState.dashboard) || (osdWrapper.sessionOnOsdSide && root.screenState.session);

                return osdWrapper.x + root.panelOpened(osd.offsetScale, 0, (panelOnOsdSide ? 0 : Config.border.thickness / 2));
            }
        }
        width: {
            const panelOnOsdSide = (osdWrapper.sidebarOnOsdSide && root.screenState.sidebar || root.screenState.sidebarTemporary) || (osdWrapper.dashboardOnOsdSide && root.screenState.dashboard) || (osdWrapper.sessionOnOsdSide && root.screenState.session);

            switch (Config.osd.position) {
            case HorizontalPosition.Left:
                return root.panelOpened(osd.offsetScale, osdWrapper.width + Config.border.thickness, Config.border.thickness / 2 + (panelOnOsdSide ? Config.border.thickness / 2 : 0));
            case HorizontalPosition.Right:
                return osdWrapper.width + root.panelOpened(osd.offsetScale, Config.border.thickness * 2, Config.border.thickness / 2 + (panelOnOsdSide ? Config.border.thickness / 2 : 0));
            }
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

    Item {
        id: utilitiesTrigger

        anchors.left: utilities.left
        anchors.right: utilities.right
        y: {
            switch (Config.utilities.position) {
            case UtilitiesPosition.TopLeft:
            case UtilitiesPosition.TopRight:
                return utilities.y - root.panelOpened(utilities.offsetScale, root.geometry.insetTop(0) + Config.border.thickness * 2, root.geometry.insetTop(Config.border.thickness) - Config.border.thickness);
            case UtilitiesPosition.BottomLeft:
                return utilities.y;
            case UtilitiesPosition.BottomRight:
                return utilities.y + root.panelOpened(utilities.offsetScale, 0, root.geometry.insetBottom(Config.border.thickness) - Config.border.thickness);
            }
        }
        height: {
            switch (Config.utilities.position) {
            case UtilitiesPosition.TopLeft:
            case UtilitiesPosition.TopRight:
                return utilities.height + root.geometry.insetTop(0) * (1 - utilities.offsetScale) + Config.border.thickness * 2 * (1 - utilities.offsetScale);
            case UtilitiesPosition.BottomLeft:
                return utilities.height;
            case UtilitiesPosition.BottomRight:
                return utilities.height + Config.border.thickness * 2 + root.geometry.insetBottom(0);
            }
        }
    }

    Toasts.Toasts {
        id: toasts

        anchors.bottom: sidebar.visible ? parent.bottom : utilities.top
        anchors.left: root.geometry.sidebarOnLeft ? sidebar.right : undefined
        anchors.right: root.geometry.sidebarOnLeft ? undefined : sidebar.left
        anchors.margins: Tokens.padding.medium
    }

    // Sidebar.Wrapper {
    //     id: sidebar

    //     readonly property bool sharesNotifications: root.geometry.sidebarOnRight
    //     readonly property bool sharesUtilities: root.geometry.sidebarOnLeft ? root.geometry.utilitiesOnLeft : root.geometry.utilitiesOnRight
    //     readonly property bool utilitiesAbove: sharesUtilities && root.geometry.utilitiesOnTop
    //     readonly property bool utilitiesBelow: sharesUtilities && root.geometry.utilitiesOnBottom

    //     screenState: root.screenState
    //     onLeft: root.geometry.sidebarOnLeft

    //     anchors.top: utilitiesAbove ? utilities.bottom : sharesNotifications ? notifications.bottom : parent.top
    //     anchors.bottom: utilitiesBelow ? utilities.top : parent.bottom
    //     anchors.topMargin: utilitiesAbove ? 0 : sharesNotifications ? -notifications.anchors.topMargin : 0
    // }

    // Item {
    //     id: sidebarTrigger

    //     anchors.fill: sidebar

    //     // Taskbar
    //     Loader {
    //         active: (Config.sidebar.position === HorizontalPosition.Left && Config.bar.position === BarPosition.Left) || (Config.sidebar.position === HorizontalPosition.Right && Config.bar.position === BarPosition.Right)

    //         anchors.bottom: parent.bottom
    //         height: parent.height - Config.sidebar.minHoverThreshold

    //         x: {
    //             switch (Config.sidebar.position) {
    //             case HorizontalPosition.Left:
    //                 return root.panelOpened(sidebar.offsetScale, 0, parent.width);
    //             case HorizontalPosition.Right:
    //                 return root.panelOpened(sidebar.offsetScale, parent.width, Config.border.thickness);
    //             }
    //         }
    //         width: Config.border.thickness

    //         sourceComponent: Item {
    //             property bool inverted: true

    //             // Rectangle {
    //             //     anchors.fill: parent
    //             //     color: '#32bb00ff'
    //             // }
    //         }
    //     }

    //     // Sidebar
    //     Item {
    //         id: sidebarMainTrigger

    //         anchors.top: parent.top
    //         x: {
    //             switch (Config.sidebar.position) {
    //             case HorizontalPosition.Left:
    //                 return -Config.border.thickness * 2 - root.panelOpened(sidebar.offsetScale, 0, Config.border.thickness / 2);
    //             case HorizontalPosition.Right:
    //                 return root.panelOpened(sidebar.offsetScale, 0, Config.border.thickness / 2);
    //             }
    //         }
    //         height: parent.height
    //         width: {
    //             switch (Config.sidebar.position) {
    //             case HorizontalPosition.Left:
    //                 return sidebar.width + Config.border.thickness * 2;
    //             case HorizontalPosition.Right:
    //                 return sidebar.width + Config.border.thickness * 2;
    //             }
    //         }
    //     }

    //     // Second trigger
    //     Item {
    //         id: sidebarSecondTrigger

    //         x: {
    //             switch (Config.sidebar.position) {
    //             case HorizontalPosition.Left:
    //                 return -Config.border.thickness * 2;
    //             case HorizontalPosition.Right:
    //                 return 0;
    //             }
    //         }
    //         height: Config.sidebar.minHoverThreshold
    //         width: {
    //             switch (Config.sidebar.position) {
    //             case HorizontalPosition.Left:
    //                 return sidebar.width + Config.border.thickness * 2;
    //             case HorizontalPosition.Right:
    //                 return sidebar.width + Config.border.thickness * 2;
    //             }
    //         }
    //     }

    //     // Rectangle {
    //     //     anchors.fill: sidebarMainTrigger
    //     //     color: '#32ff0000'
    //     // }

    //     // Rectangle {
    //     //     anchors.fill: sidebarSecondTrigger
    //     //     color: '#32ff0000'
    //     // }
    // }

    Drawers.Panel {
        id: sidebar
        name: "sidebar"

        // anchors.top: utilitiesAbove ? utilities.bottom : sharesNotifications ? notifications.bottom : parent.top
        // anchors.bottom: utilitiesBelow ? utilities.top : parent.bottom
        // anchors.topMargin: utilitiesAbove ? 0 : sharesNotifications ? -notifications.anchors.topMargin : 0

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 0

        Sidebar.Wrapper {
            id: sidebarContent

            screenState: root.screenState
            onLeft: root.geometry.sidebarOnLeft

            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: '#32ff0000'
            }
        }
        content: sidebarContent
        offsetScale: sidebarContent.offsetScale

        Drawers.Trigger {
            id: sidebarTrigger

            Drawers.TriggerPart {
                anchors.fill: parent
            }

            Drawers.TriggerPart {
                debug: true
                height: Config.sidebar.minHoverThreshold
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: -Config.border.thickness * 2
                anchors.rightMargin: -Config.border.thickness * 2
            }
        }
        trigger: sidebarTrigger
    }

    // Rectangle {
    //     anchors.fill: sessionWrapper
    //     color: '#32ff00ff'
    // }

    // Rectangle {
    //     anchors.fill: launcherTrigger
    //     color: '#51ffa200'
    // }

    // Rectangle {
    //     anchors.fill: dashboardTrigger
    //     color: '#3200ffd5'
    // }

    // Rectangle {
    //     anchors.fill: osdTrigger
    //     color: '#3211ff00'
    // }

    // Rectangle {
    //     anchors.fill: utilitiesTrigger
    //     color: '#320040ff'
    // }

    // Rectangle {
    //     anchors.fill: popoutsWrapper
    //     color: '#32ff00ff'
    // }
}
