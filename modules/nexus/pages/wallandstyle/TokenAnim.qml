pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Animation")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Durations
        SectionHeader {
            first: true
            text: Tr.tr("Durations")
        }

        StepperRow {
            first: true
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Small")
            subtext: Tr.tr("Quick animations, such as state layer fades (ms)")
            value: TokenConfig.appearance.animDurations.small
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.small = value
        }

        StepperRow {
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Normal")
            subtext: Tr.tr("Default animation duration (ms)")
            value: TokenConfig.appearance.animDurations.normal
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.normal = value
        }

        StepperRow {
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Large")
            subtext: Tr.tr("Slow animations, such as panel transitions (ms)")
            value: TokenConfig.appearance.animDurations.large
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.large = value
        }

        StepperRow {
            last: true
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Extra large")
            subtext: Tr.tr("Slowest animation duration (ms)")
            value: TokenConfig.appearance.animDurations.extraLarge
            from: 0
            to: 4000
            onMoved: value => TokenConfig.appearance.animDurations.extraLarge = value
        }

        // Expressive durations
        SectionHeader {
            text: Tr.tr("Expressive durations")
        }

        StepperRow {
            first: true
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Fast spatial")
            subtext: Tr.tr("Short spatial transitions (ms)")
            value: TokenConfig.appearance.animDurations.expressiveFastSpatial
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.expressiveFastSpatial = value
        }

        StepperRow {
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Default spatial")
            subtext: Tr.tr("Default spatial transitions (ms)")
            value: TokenConfig.appearance.animDurations.expressiveDefaultSpatial
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.expressiveDefaultSpatial = value
        }

        StepperRow {
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Slow spatial")
            subtext: Tr.tr("Long spatial transitions (ms)")
            value: TokenConfig.appearance.animDurations.expressiveSlowSpatial
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.expressiveSlowSpatial = value
        }

        StepperRow {
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Fast effects")
            subtext: Tr.tr("Short color and state effects (ms)")
            value: TokenConfig.appearance.animDurations.expressiveFastEffects
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.expressiveFastEffects = value
        }

        StepperRow {
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Default effects")
            subtext: Tr.tr("Default color and state effects (ms)")
            value: TokenConfig.appearance.animDurations.expressiveDefaultEffects
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.expressiveDefaultEffects = value
        }

        StepperRow {
            last: true
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            label: Tr.tr("Slow effects")
            subtext: Tr.tr("Long color and state effects (ms)")
            value: TokenConfig.appearance.animDurations.expressiveSlowEffects
            from: 0
            to: 2000
            onMoved: value => TokenConfig.appearance.animDurations.expressiveSlowEffects = value
        }
    }
}
