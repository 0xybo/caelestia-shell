pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Spacing")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Spacing")
        }

        StepperRow {
            first: true
            label: Tr.tr("Extra small")
            subtext: Tr.tr("Gap between tightly related elements")
            value: TokenConfig.appearance.spacing.extraSmall
            onMoved: value => TokenConfig.appearance.spacing.extraSmall = value
        }

        StepperRow {
            label: Tr.tr("Small")
            subtext: Tr.tr("Gap between related elements")
            value: TokenConfig.appearance.spacing.small
            onMoved: value => TokenConfig.appearance.spacing.small = value
        }

        StepperRow {
            label: Tr.tr("Medium")
            subtext: Tr.tr("Default gap between elements")
            value: TokenConfig.appearance.spacing.medium
            onMoved: value => TokenConfig.appearance.spacing.medium = value
        }

        StepperRow {
            label: Tr.tr("Large")
            subtext: Tr.tr("Gap between groups of elements")
            value: TokenConfig.appearance.spacing.large
            onMoved: value => TokenConfig.appearance.spacing.large = value
        }

        StepperRow {
            label: Tr.tr("Large increased")
            subtext: Tr.tr("Vertical gap between sections")
            value: TokenConfig.appearance.spacing.largeIncreased
            onMoved: value => TokenConfig.appearance.spacing.largeIncreased = value
        }

        StepperRow {
            label: Tr.tr("Extra large")
            subtext: Tr.tr("Gap between distinct regions")
            value: TokenConfig.appearance.spacing.extraLarge
            onMoved: value => TokenConfig.appearance.spacing.extraLarge = value
        }

        StepperRow {
            label: Tr.tr("Extra large increased")
            subtext: Tr.tr("Gap between major regions")
            value: TokenConfig.appearance.spacing.extraLargeIncreased
            onMoved: value => TokenConfig.appearance.spacing.extraLargeIncreased = value
        }

        StepperRow {
            last: true
            label: Tr.tr("Extra extra large")
            subtext: Tr.tr("Largest gap between elements")
            value: TokenConfig.appearance.spacing.extraExtraLarge
            onMoved: value => TokenConfig.appearance.spacing.extraExtraLarge = value
        }
    }
}
