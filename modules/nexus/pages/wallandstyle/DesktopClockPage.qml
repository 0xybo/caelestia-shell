pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components.controls
import qs.modules.nexus.common

PageBase {
    id: root

    // Positions, matching the states in modules/background/Background.qml
    readonly property list<MenuItem> positionItems: [
        MenuItem {
            text: Tr.tr("Top left")
            value: "top-left"
        },
        MenuItem {
            text: Tr.tr("Top center")
            value: "top-center"
        },
        MenuItem {
            text: Tr.tr("Top right")
            value: "top-right"
        },
        MenuItem {
            text: Tr.tr("Middle left")
            value: "middle-left"
        },
        MenuItem {
            text: Tr.tr("Middle center")
            value: "middle-center"
        },
        MenuItem {
            text: Tr.tr("Middle right")
            value: "middle-right"
        },
        MenuItem {
            text: Tr.tr("Bottom left")
            value: "bottom-left"
        },
        MenuItem {
            text: Tr.tr("Bottom center")
            value: "bottom-center"
        },
        MenuItem {
            text: Tr.tr("Bottom right")
            value: "bottom-right"
        }
    ]

    title: Tr.tr("Desktop clock")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Clock
        SectionHeader {
            first: true
            text: Tr.tr("Clock")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.background.desktopClock.enabled
            onToggled: GlobalConfig.background.desktopClock.enabled = checked
        }

        StepperRow {
            label: Tr.tr("Scale")
            value: Config.background.desktopClock.scale
            from: 0.5
            to: 2
            stepSize: 0.05
            onMoved: v => GlobalConfig.background.desktopClock.scale = v
        }

        SelectRow {
            label: Tr.tr("Position")
            subtext: Tr.tr("Where on the screen the clock appears")
            menuItems: root.positionItems
            active: root.positionItems.find(i => i.value === Config.background.desktopClock.position)
            onSelected: item => GlobalConfig.background.desktopClock.position = item.value
        }

        ToggleRow {
            last: true
            text: Tr.tr("Invert colours")
            checked: Config.background.desktopClock.invertColors
            onToggled: GlobalConfig.background.desktopClock.invertColors = checked
        }

        // Background
        SectionHeader {
            text: Tr.tr("Background")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.background.desktopClock.background.enabled
            onToggled: GlobalConfig.background.desktopClock.background.enabled = checked
        }

        StepperRow {
            label: Tr.tr("Opacity")
            value: Config.background.desktopClock.background.opacity
            from: 0
            to: 1
            stepSize: 0.05
            onMoved: v => GlobalConfig.background.desktopClock.background.opacity = v
        }

        ToggleRow {
            last: true
            text: Tr.tr("Blur")
            checked: Config.background.desktopClock.background.blur
            onToggled: GlobalConfig.background.desktopClock.background.blur = checked
        }

        // Shadow
        SectionHeader {
            text: Tr.tr("Shadow")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.background.desktopClock.shadow.enabled
            onToggled: GlobalConfig.background.desktopClock.shadow.enabled = checked
        }

        StepperRow {
            label: Tr.tr("Opacity")
            value: Config.background.desktopClock.shadow.opacity
            from: 0
            to: 1
            stepSize: 0.05
            onMoved: v => GlobalConfig.background.desktopClock.shadow.opacity = v
        }

        StepperRow {
            last: true
            label: Tr.tr("Blur")
            value: Config.background.desktopClock.shadow.blur
            from: 0
            to: 1
            stepSize: 0.05
            onMoved: v => GlobalConfig.background.desktopClock.shadow.blur = v
        }
    }
}
