pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components.controls
import qs.modules.nexus.common

PageBase {
    id: root

    readonly property list<MenuItem> positionItems: [
        MenuItem {
            text: Tr.tr("Left")
            value: HorizontalPosition.Left
        },
        MenuItem {
            text: Tr.tr("Right")
            value: HorizontalPosition.Right
        }
    ]

    title: Tr.tr("Volume and brightness")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // General
        SectionHeader {
            first: true
            text: Tr.tr("General")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.osd.enabled
            onToggled: GlobalConfig.osd.enabled = checked
        }

        SelectRow {
            label: Tr.tr("Position")
            subtext: Tr.tr("Which screen edge the sliders appear on")
            menuItems: root.positionItems
            active: root.positionItems.find(i => i.value === Config.osd.position)
            onSelected: i => GlobalConfig.osd.position = i.value
        }

        StepperRow {
            last: true
            label: Tr.tr("Hide delay")
            subtext: Tr.tr("Milliseconds before the sliders hide again")
            value: Config.osd.hideDelay
            from: 200
            to: 10000
            stepSize: 100
            onMoved: v => GlobalConfig.osd.hideDelay = v
        }

        // Sliders
        SectionHeader {
            text: Tr.tr("Sliders")
        }

        ToggleRow {
            first: true
            text: Tr.tr("Brightness")
            subtext: Tr.tr("Show a slider when the screen brightness changes")
            checked: Config.osd.enableBrightness
            onToggled: GlobalConfig.osd.enableBrightness = checked
        }

        ToggleRow {
            last: true
            text: Tr.tr("Microphone")
            subtext: Tr.tr("Show a slider when the input volume changes")
            checked: Config.osd.enableMicrophone
            onToggled: GlobalConfig.osd.enableMicrophone = checked
        }
    }
}
