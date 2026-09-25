import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Panels")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        NavRow {
            first: true
            icon: "dashboard"
            text: Tr.tr("Dashboard")
            subtext: Config.dashboard.enabled ? Tr.trCtx("Enabled", "panel status") : Tr.trCtx("Disabled", "panel status")
            onClicked: root.nState.openSubPage("dashboardPanel")
        }

        NavRow {
            icon: "dock_to_bottom"
            text: Tr.tr("Taskbar")
            subtext: Config.bar.persistent ? Tr.tr("Always visible") : Config.bar.showOnHover ? Tr.tr("Reveal on hover") : Tr.tr("Reveal on drag")
            onClicked: root.nState.openSubPage("taskbarPanel")
        }

        NavRow {
            icon: "apps"
            text: Tr.tr("Launcher")
            subtext: Config.launcher.enabled ? Tr.trCtx("Enabled", "panel status") : Tr.trCtx("Disabled", "panel status")
            onClicked: root.nState.openSubPage("launcherPanel")
        }

        NavRow {
            icon: "dock_to_right"
            text: Tr.tr("Sidebar")
            subtext: Config.sidebar.enabled ? Tr.trCtx("Enabled", "panel status") : Tr.trCtx("Disabled", "panel status")
            onClicked: root.nState.openSubPage("sidebarPanel")
        }

        NavRow {
            icon: "construction"
            text: Tr.tr("Utilities")
            subtext: Config.utilities.enabled ? Tr.trCtx("Enabled", "panel status") : Tr.trCtx("Disabled", "panel status")
            onClicked: root.nState.openSubPage("utilitiesPanel")
        }

        NavRow {
            last: true
            icon: "power_settings_new"
            text: Tr.tr("Session")
            subtext: Tr.tr("Logout, shutdown, suspend, restart")
            onClicked: root.nState.openSubPage("sessionPanel")
        }

        NavRow {
            last: true
            icon: "power_settings_new"
            text: Tr.tr("Session")
            onClicked: root.nState.openSubPage(6)
        }
    }
}
