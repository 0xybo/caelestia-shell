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

    title: Tr.tr("Sidebar")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("General")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.sidebar.enabled
            onToggled: GlobalConfig.sidebar.enabled = checked
        }

        SelectRow {
            label: Tr.tr("Position")
            subtext: Tr.tr("Which screen edge the sidebar opens from")
            menuItems: root.positionItems
            active: root.positionItems.find(i => i.value === Config.sidebar.position)
            onSelected: i => GlobalConfig.sidebar.position = i.value
        }

        ToggleRow {
            last: true
            text: Tr.trCtx("Show on hover", "toggle label")
            subtext: Tr.tr("Reveal the sidebar when the mouse hovers over its edge")
            checked: Config.sidebar.showOnHover
            onToggled: GlobalConfig.sidebar.showOnHover = checked
        }

        StepperRow {
            last: true
            label: Tr.tr("Drag threshold")
            subtext: Tr.tr("Pixels dragged before the sidebar opens")
            value: Config.sidebar.dragThreshold
            from: 0
            to: 200
            stepSize: 5
            onMoved: v => GlobalConfig.sidebar.dragThreshold = v
        }
    }
}
