pragma ComponentBehavior: Bound

import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Tray")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        ToggleRow {
            first: true
            text: Tr.trCtx("Background", "taskbar tray: draw a background behind the tray")
            checked: Config.bar.tray.background
            onToggled: GlobalConfig.bar.tray.background = checked
        }

        ToggleRow {
            // TRANSLATORS: tint system tray icons with the theme accent colour
            text: Tr.tr("Recolour icons")
            checked: Config.bar.tray.recolour
            onToggled: GlobalConfig.bar.tray.recolour = checked
        }

        ToggleRow {
            text: Tr.trCtx("Compact", "taskbar tray layout")
            checked: Config.bar.tray.compact
            onToggled: GlobalConfig.bar.tray.compact = checked
        }

        ToggleRow {
            last: true
            text: Tr.tr("Popout on hover")
            subtext: Tr.tr("Show the tray menu popout when hovering")
            checked: Config.bar.popouts.tray
            onToggled: GlobalConfig.bar.popouts.tray = checked
        }

        // Substitutions
        SectionHeader {
            text: Tr.tr("Substitutions")
        }

        NavRow {
            first: true
            last: true
            icon: "swap_horiz"
            text: Tr.tr("Icon substitutions")
            subtext: Tr.tr("Replace tray icon IDs with icons or images")
            onClicked: root.nState.openSubPage("trayIconSubs")
        }

        // Hidden icons
        SectionHeader {
            text: Tr.tr("Hidden icons")
        }

        StringListEditor {
            first: true
            values: Config.bar.tray.hiddenIcons
            addPlaceholderText: Tr.tr("Icon ID")
            onItemAdded: v => GlobalConfig.bar.tray.hiddenIcons = [...Config.bar.tray.hiddenIcons, v]
            onItemMoved: (from, to) => {
                const list = [...Config.bar.tray.hiddenIcons];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.bar.tray.hiddenIcons = list;
            }
            onItemRemoved: index => {
                const list = [...Config.bar.tray.hiddenIcons];
                list.splice(index, 1);
                GlobalConfig.bar.tray.hiddenIcons = list;
            }
        }
    }
}
