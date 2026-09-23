pragma ComponentBehavior: Bound

import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components.controls
import qs.modules.nexus.common

PageBase {
    id: root

    // Workspace display types, ordered to match config::BarWorkspaceDisplay
    readonly property list<MenuItem> displayItems: [
        MenuItem {
            text: Tr.tr("Shapes")
            value: BarWorkspaceDisplay.Shapes
        },
        MenuItem {
            text: Tr.tr("Text")
            value: BarWorkspaceDisplay.Text
        },
        MenuItem {
            text: Tr.tr("Icons")
            value: BarWorkspaceDisplay.Icons
        }
    ]

    // Text capitalisation modes, ordered to match config::BarWorkspaceCapitalisation
    readonly property list<MenuItem> capitalisationItems: [
        MenuItem {
            text: Tr.trCtx("Preserve", "workspace label capitalisation")
            value: BarWorkspaceCapitalisation.Preserve
        },
        MenuItem {
            text: Tr.tr("Uppercase")
            value: BarWorkspaceCapitalisation.Upper
        },
        MenuItem {
            text: Tr.tr("Lowercase")
            value: BarWorkspaceCapitalisation.Lower
        }
    ]

    title: Tr.tr("Workspaces")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        StepperRow {
            first: true
            // TRANSLATORS: the number of workspaces shown on the bar
            label: Tr.trCtx("Shown", "bar workspaces")
            subtext: Tr.tr("Number of workspaces displayed")
            value: Config.bar.workspaces.shown
            from: 1
            to: 20
            stepSize: 1
            onMoved: v => GlobalConfig.bar.workspaces.shown = v
        }

        SelectRow {
            label: Tr.tr("Display type")
            subtext: Tr.tr("How workspace indicators are drawn")
            menuItems: root.displayItems
            active: root.displayItems.find(i => i.value === Config.bar.workspaces.displayType)
            onSelected: item => GlobalConfig.bar.workspaces.displayType = item.value
        }

        SelectRow {
            label: Tr.tr("Special workspace display")
            subtext: Tr.tr("How special workspace indicators are drawn")
            menuItems: root.displayItems
            active: root.displayItems.find(i => i.value === Config.bar.workspaces.specialDisplayType)
            onSelected: item => GlobalConfig.bar.workspaces.specialDisplayType = item.value
        }

        SelectRow {
            label: Tr.tr("Capitalisation")
            subtext: Tr.tr("How workspace labels are cased")
            menuItems: root.capitalisationItems
            active: root.capitalisationItems.find(i => i.value === Config.bar.workspaces.capitalisation)
            onSelected: item => GlobalConfig.bar.workspaces.capitalisation = item.value
        }

        TextFieldRow {
            label: Tr.tr("Workspace label")
            value: Config.bar.workspaces.label
            onEditingFinished: v => GlobalConfig.bar.workspaces.label = v
        }

        TextFieldRow {
            label: Tr.tr("Occupied label")
            value: Config.bar.workspaces.occupiedLabel
            onEditingFinished: v => GlobalConfig.bar.workspaces.occupiedLabel = v
        }

        TextFieldRow {
            label: Tr.tr("Active label")
            value: Config.bar.workspaces.activeLabel
            onEditingFinished: v => GlobalConfig.bar.workspaces.activeLabel = v
        }

        ToggleRow {
            text: Tr.trCtx("Active indicator", "bar workspaces")
            checked: Config.bar.workspaces.activeIndicator
            onToggled: GlobalConfig.bar.workspaces.activeIndicator = checked
        }

        ToggleRow {
            text: Tr.trCtx("Active trail", "bar workspaces")
            checked: Config.bar.workspaces.activeTrail
            onToggled: GlobalConfig.bar.workspaces.activeTrail = checked
        }

        ToggleRow {
            text: Tr.trCtx("Occupied background", "bar workspaces")
            checked: Config.bar.workspaces.occupiedBg
            onToggled: GlobalConfig.bar.workspaces.occupiedBg = checked
        }

        ToggleRow {
            text: Tr.trCtx("Show unoccupied", "bar workspaces")
            subtext: Tr.tr("Show workspaces that are inactive and empty")
            checked: Config.bar.workspaces.showUnoccupied
            onToggled: GlobalConfig.bar.workspaces.showUnoccupied = checked
        }

        ToggleRow {
            text: Tr.trCtx("Per monitor", "bar workspaces")
            subtext: Tr.tr("Hide workspaces not on the current monitor")
            checked: Config.bar.workspaces.perMonitor
            onToggled: GlobalConfig.bar.workspaces.perMonitor = checked
        }

        ToggleRow {
            text: Tr.trCtx("Show windows", "bar workspaces")
            subtext: Tr.tr("Show icons of open windows on each workspace")
            checked: Config.bar.workspaces.showWindows
            onToggled: GlobalConfig.bar.workspaces.showWindows = checked
        }

        ToggleRow {
            text: Tr.trCtx("Windows on special workspaces", "bar workspaces")
            checked: Config.bar.workspaces.showWindowsOnSpecialWorkspaces
            onToggled: GlobalConfig.bar.workspaces.showWindowsOnSpecialWorkspaces = checked
        }

        StepperRow {
            last: true
            // TRANSLATORS: maximum number of window icons shown per workspace
            label: Tr.trCtx("Max window icons", "bar workspaces")
            value: Config.bar.workspaces.maxWindowIcons
            from: 0
            to: 20
            stepSize: 1
            onMoved: v => GlobalConfig.bar.workspaces.maxWindowIcons = v
        }

        // Icon rules
        SectionHeader {
            text: Tr.tr("Icon rules")
        }

        NavRow {
            first: true
            icon: "workspaces"
            text: Tr.tr("Workspace icons")
            subtext: Tr.tr("Icons for named workspaces")
            onClicked: {
                root.nState.editRulesType = "workspace";
                root.nState.openSubPage(13);
            }
        }

        NavRow {
            icon: "star"
            text: Tr.tr("Special workspace icons")
            subtext: Tr.tr("Icons for special workspaces")
            onClicked: {
                root.nState.editRulesType = "special";
                root.nState.openSubPage(14);
            }
        }

        NavRow {
            last: true
            icon: "window"
            text: Tr.tr("Window icons")
            subtext: Tr.tr("Icons for open windows")
            onClicked: {
                root.nState.editRulesType = "window";
                root.nState.openSubPage(15);
            }
        }

        // Tags
        SectionHeader {
            text: Tr.tr("Tags")
        }

        StringListEditor {
            first: true
            last: true
            values: Config.bar.workspaces.ignoredTags
            addPlaceholderText: Tr.tr("Tag")
            onItemAdded: v => GlobalConfig.bar.workspaces.ignoredTags = [...Config.bar.workspaces.ignoredTags, v]
            onItemMoved: (from, to) => {
                const list = [...Config.bar.workspaces.ignoredTags];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.bar.workspaces.ignoredTags = list;
            }
            onItemRemoved: index => {
                const list = [...Config.bar.workspaces.ignoredTags];
                list.splice(index, 1);
                GlobalConfig.bar.workspaces.ignoredTags = list;
            }
        }
    }
}
