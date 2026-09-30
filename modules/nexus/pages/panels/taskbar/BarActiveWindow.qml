pragma ComponentBehavior: Bound

import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.utils
import qs.modules.nexus.common

PageBase {
    id: root

    readonly property bool hoverSupported: BarLayout.activeWindowHoverSupported(Config.bar.position, Config.bar.dashboardPosition)

    title: Tr.tr("Active window")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        ToggleRow {
            first: true
            text: Tr.trCtx("Compact", "taskbar active window layout")
            checked: Config.bar.activeWindow.compact
            onToggled: GlobalConfig.bar.activeWindow.compact = checked
        }

        ToggleRow {
            text: Tr.trCtx("Inverted", "taskbar active window: swap the title and class order")
            checked: Config.bar.activeWindow.inverted
            onToggled: GlobalConfig.bar.activeWindow.inverted = checked
        }

        ToggleRow {
            text: Tr.tr("Show on hover")
            subtext: root.hoverSupported ? Tr.tr("Only show the active window title while hovering") : Tr.tr("Unavailable while the dashboard shares this bar's edge")
            disabled: !root.hoverSupported
            checked: Config.bar.activeWindow.showOnHover
            onToggled: GlobalConfig.bar.activeWindow.showOnHover = checked
        }

        ToggleRow {
            last: true
            text: Tr.tr("Popout on hover")
            subtext: root.hoverSupported ? Tr.tr("Show a window details popout when hovering") : Tr.tr("Unavailable while the dashboard shares this bar's edge")
            disabled: !root.hoverSupported
            checked: Config.bar.popouts.activeWindow
            onToggled: GlobalConfig.bar.popouts.activeWindow = checked
        }
    }
}
