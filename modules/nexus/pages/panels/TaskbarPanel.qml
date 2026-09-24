pragma ComponentBehavior: Bound

import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components.controls
import qs.modules.nexus.common

PageBase {
    id: root

    readonly property list<MenuItem> barPositionItems: [
        MenuItem {
            text: Tr.tr("Top")
            value: BarPosition.Top
        },
        MenuItem {
            text: Tr.tr("Bottom")
            value: BarPosition.Bottom
        },
        MenuItem {
            text: Tr.tr("Left")
            value: BarPosition.Left
        }
    ]

    // Clamped to the edges valid for the current bar position, mirroring EdgeGeometry
    readonly property int effectiveDashboardPosition: {
        const barPos = Config.bar.position;
        if (barPos === BarPosition.Top)
            return DashboardPosition.Left;
        if (barPos === BarPosition.Bottom)
            return Config.bar.dashboardPosition;
        return DashboardPosition.Top;
    }

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

        SelectRow {
            first: true
            label: Tr.tr("Position")
            subtext: Tr.tr("Where the bar is located on the screen")
            menuItems: root.barPositionItems
            active: root.barPositionItems.find(i => i.value === Config.bar.position)
            onSelected: i => GlobalConfig.bar.position = i.value
        }

        SelectRow {
            label: Tr.tr("Dashboard position")
            subtext: Tr.tr("Which screen edge the dashboard sits on")
            disabled: menuItems.length < 2
            menuItems: {
                const barPos = Config.bar.position;
                // The dashboard can only sit on edges the bar doesn't occupy
                if (barPos === BarPosition.Bottom)
                    return [dashboardPosTop, dashboardPosLeft];
                if (barPos === BarPosition.Top)
                    return [dashboardPosLeft];
                return [dashboardPosTop];
            }
            active: menuItems.find(i => i.value === root.effectiveDashboardPosition) && menuItems.length > 1
            onSelected: i => GlobalConfig.bar.dashboardPosition = i.value

            MenuItem {
                id: dashboardPosTop

                text: Tr.tr("Top")
                value: DashboardPosition.Top
            }
            MenuItem {
                id: dashboardPosLeft

                text: Tr.tr("Left")
                value: DashboardPosition.Left
            }
        }

        ToggleRow {
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
            onClicked: root.nState.openSubPage("barWorkspaces")
        }

        NavRow {
            icon: "web_asset"
            text: Tr.tr("Active window")
            subtext: Tr.tr("Title display, popout")
            onClicked: root.nState.openSubPage("barActiveWindow")
        }

        NavRow {
            icon: "widgets"
            text: Tr.tr("Tray")
            subtext: Tr.tr("System tray icons")
            onClicked: root.nState.openSubPage("barTray")
        }

        NavRow {
            icon: "signal_cellular_alt"
            text: Tr.tr("Status icons")
            subtext: Tr.tr("Visible indicators")
            onClicked: root.nState.openSubPage("barStatusIcons")
        }

        NavRow {
            icon: "schedule"
            text: Tr.tr("Clock")
            subtext: Tr.tr("Date, icon, background")
            onClicked: root.nState.openSubPage("barClock")
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
