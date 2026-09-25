pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Visualiser")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Wallpaper visualiser")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.background.visualiser.enabled
            onToggled: GlobalConfig.background.visualiser.enabled = checked
        }

        ToggleRow {
            text: Tr.tr("Auto hide")
            subtext: Tr.tr("Fade out when no audio is playing")
            checked: Config.background.visualiser.autoHide
            onToggled: GlobalConfig.background.visualiser.autoHide = checked
        }

        ToggleRow {
            text: Tr.tr("Background blur")
            subtext: Tr.tr("Blur the wallpaper behind the visualiser")
            checked: Config.background.visualiser.blur
            onToggled: GlobalConfig.background.visualiser.blur = checked
        }

        StepperRow {
            label: Tr.tr("Rounding")
            subtext: Tr.tr("Corner radius of the visualiser bars")
            value: Config.background.visualiser.rounding
            from: 0
            to: 2
            stepSize: 0.1
            onMoved: v => GlobalConfig.background.visualiser.rounding = v
        }

        StepperRow {
            last: true
            label: Tr.tr("Spacing")
            subtext: Tr.tr("Gap between the visualiser bars")
            value: Config.background.visualiser.spacing
            from: 0
            to: 2
            stepSize: 0.1
            onMoved: v => GlobalConfig.background.visualiser.spacing = v
        }
    }
}
