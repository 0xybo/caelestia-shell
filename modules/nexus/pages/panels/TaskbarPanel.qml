pragma ComponentBehavior: Bound

import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Taskbar")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Behaviour
        SectionHeader {
            first: true
            text: Tr.tr("Behaviour")
        }

        ToggleRow {
            first: true
            text: Tr.tr("Persistent")
            subtext: Tr.tr("Keep the bar visible at all times")
            checked: Config.bar.persistent
            onToggled: GlobalConfig.bar.persistent = checked
        }

        ToggleRow {
            text: Tr.tr("Show on hover")
            subtext: Tr.tr("Reveal the bar when the cursor reaches the screen edge")
            checked: Config.bar.showOnHover
            onToggled: GlobalConfig.bar.showOnHover = checked
        }

        StepperRow {
            last: true
            label: Tr.tr("Drag threshold")
            subtext: Tr.tr("Pixels dragged before the bar reveals")
            value: Config.bar.dragThreshold
            from: 0
            to: 200
            stepSize: 5
            onMoved: v => GlobalConfig.bar.dragThreshold = v
        }

        // Components
        SectionHeader {
            text: Tr.tr("Components")
        }

        NavRow {
            first: true
            icon: "workspaces"
            text: Tr.tr("Workspaces")
            subtext: Tr.tr("Indicators, window icons")
            onClicked: root.nState.openSubPage(7)
        }

        NavRow {
            icon: "web_asset"
            text: Tr.tr("Active window")
            subtext: Tr.tr("Title display, popout")
            onClicked: root.nState.openSubPage(8)
        }

        NavRow {
            icon: "widgets"
            text: Tr.tr("Tray")
            subtext: Tr.tr("System tray icons")
            onClicked: root.nState.openSubPage(9)
        }

        NavRow {
            icon: "signal_cellular_alt"
            text: Tr.tr("Status icons")
            subtext: Tr.tr("Visible indicators")
            onClicked: root.nState.openSubPage(10)
        }

        NavRow {
            icon: "schedule"
            text: Tr.tr("Clock")
            subtext: Tr.tr("Date, icon, background")
            onClicked: root.nState.openSubPage(11)
        }

        NavRow {
            last: true
            icon: "border_style"
            text: Tr.tr("Borders")
            subtext: Tr.tr("Thickness, rounding")
            onClicked: root.nState.openSubPage(12)
        }

        // Excluded screens
        SectionHeader {
            text: Tr.tr("Excluded screens")
        }

        StringListEditor {
            first: true
            labelKey: "name"
            values: Config.bar.excludedScreens
            addPlaceholderText: Tr.tr("Screen name")
            onItemAdded: v => GlobalConfig.bar.excludedScreens = [...GlobalConfig.bar.excludedScreens, v]
            onItemMoved: (from, to) => {
                const list = [...GlobalConfig.bar.excludedScreens];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.bar.excludedScreens = list;
            }
            onItemRemoved: index => {
                const list = [...GlobalConfig.bar.excludedScreens];
                list.splice(index, 1);
                GlobalConfig.bar.excludedScreens = list;
            }
        }

        // Bar entries
        SectionHeader {
            text: Tr.tr("Bar entries")
        }

        ListEditor {
            function labelFor(item: var): string {
                return root.entryNames[item.id] ?? item.id;
            }

            function toggledFor(item: var): bool {
                return item.enabled;
            }

            first: true
            last: true
            values: Config.bar.entries.values

            onItemMoved: (from, to) => GlobalConfig.bar.entries.move(from, to)
            onItemRemoved: index => GlobalConfig.bar.entries.remove(index)
            onItemToggled: (index, checked) => GlobalConfig.bar.entries.at(index).enabled = checked
        }

        // Scroll actions
        SectionHeader {
            text: Tr.tr("Scroll actions")
        }

        ToggleRow {
            first: true
            text: Tr.tr("Workspaces")
            subtext: Tr.tr("Scroll over the workspace indicator to switch workspaces")
            checked: Config.bar.scrollActions.workspaces
            onToggled: GlobalConfig.bar.scrollActions.workspaces = checked
        }

        ToggleRow {
            text: Tr.tr("Volume")
            subtext: Tr.tr("Scroll on the top half of the bar to adjust volume")
            checked: Config.bar.scrollActions.volume
            onToggled: GlobalConfig.bar.scrollActions.volume = checked
        }

        ToggleRow {
            last: true
            text: Tr.tr("Brightness")
            subtext: Tr.tr("Scroll on the bottom half of the bar to adjust brightness")
            checked: Config.bar.scrollActions.brightness
            onToggled: GlobalConfig.bar.scrollActions.brightness = checked
        }
    }
}
