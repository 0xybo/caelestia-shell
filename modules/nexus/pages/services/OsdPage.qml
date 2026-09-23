pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("On-screen display")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("OSD")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.osd.enabled
            onToggled: GlobalConfig.osd.enabled = checked
        }

        ToggleRow {
            text: Tr.tr("Brightness")
            subtext: Tr.tr("Show the OSD when changing brightness")
            checked: Config.osd.enableBrightness
            onToggled: GlobalConfig.osd.enableBrightness = checked
        }

        ToggleRow {
            text: Tr.tr("Microphone")
            subtext: Tr.tr("Show the OSD when toggling the microphone")
            checked: Config.osd.enableMicrophone
            onToggled: GlobalConfig.osd.enableMicrophone = checked
        }

        StepperRow {
            last: true
            label: Tr.tr("Hide delay")
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            subtext: Tr.tr("Time before the OSD dismisses (ms)")
            value: Config.osd.hideDelay
            from: 500
            to: 10000
            stepSize: 100
            onMoved: v => GlobalConfig.osd.hideDelay = v
        }
    }
}
