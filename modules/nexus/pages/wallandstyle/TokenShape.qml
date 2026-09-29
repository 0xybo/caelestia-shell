pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Shape")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Rounding
        SectionHeader {
            first: true
            text: Tr.tr("Corner rounding")
        }

        StepperRow {
            first: true
            label: Tr.tr("Extra small")
            subtext: Tr.tr("Corner radius of small elements, such as chips")
            value: TokenConfig.appearance.rounding.extraSmall
            onMoved: value => TokenConfig.appearance.rounding.extraSmall = value
        }

        StepperRow {
            label: Tr.tr("Small")
            subtext: Tr.tr("Corner radius of small surfaces")
            value: TokenConfig.appearance.rounding.small
            onMoved: value => TokenConfig.appearance.rounding.small = value
        }

        StepperRow {
            label: Tr.tr("Medium")
            subtext: Tr.tr("Corner radius of cards and buttons")
            value: TokenConfig.appearance.rounding.medium
            onMoved: value => TokenConfig.appearance.rounding.medium = value
        }

        StepperRow {
            label: Tr.tr("Large")
            subtext: Tr.tr("Corner radius of large surfaces")
            value: TokenConfig.appearance.rounding.large
            onMoved: value => TokenConfig.appearance.rounding.large = value
        }

        StepperRow {
            label: Tr.tr("Large increased")
            subtext: Tr.tr("Corner radius of settings and list rows")
            value: TokenConfig.appearance.rounding.largeIncreased
            onMoved: value => TokenConfig.appearance.rounding.largeIncreased = value
        }

        StepperRow {
            label: Tr.tr("Extra large")
            subtext: Tr.tr("Corner radius of dialogs and popups")
            value: TokenConfig.appearance.rounding.extraLarge
            onMoved: value => TokenConfig.appearance.rounding.extraLarge = value
        }

        StepperRow {
            label: Tr.tr("Extra large increased")
            subtext: Tr.tr("Corner radius of large dialogs")
            value: TokenConfig.appearance.rounding.extraLargeIncreased
            onMoved: value => TokenConfig.appearance.rounding.extraLargeIncreased = value
        }

        StepperRow {
            last: true
            label: Tr.tr("Extra extra large")
            subtext: Tr.tr("Corner radius of the largest surfaces")
            value: TokenConfig.appearance.rounding.extraExtraLarge
            onMoved: value => TokenConfig.appearance.rounding.extraExtraLarge = value
        }

        // Padding
        SectionHeader {
            text: Tr.tr("Padding")
        }

        StepperRow {
            first: true
            label: Tr.tr("Extra small")
            subtext: Tr.tr("Inner spacing of dense elements")
            value: TokenConfig.appearance.padding.extraSmall
            onMoved: value => TokenConfig.appearance.padding.extraSmall = value
        }

        StepperRow {
            label: Tr.tr("Small")
            subtext: Tr.tr("Inner spacing of small elements")
            value: TokenConfig.appearance.padding.small
            onMoved: value => TokenConfig.appearance.padding.small = value
        }

        StepperRow {
            label: Tr.tr("Medium")
            subtext: Tr.tr("Inner spacing of settings rows")
            value: TokenConfig.appearance.padding.medium
            onMoved: value => TokenConfig.appearance.padding.medium = value
        }

        StepperRow {
            label: Tr.tr("Large")
            subtext: Tr.tr("Inner spacing of panels")
            value: TokenConfig.appearance.padding.large
            onMoved: value => TokenConfig.appearance.padding.large = value
        }

        StepperRow {
            label: Tr.tr("Large increased")
            subtext: Tr.tr("Horizontal inset of settings rows")
            value: TokenConfig.appearance.padding.largeIncreased
            onMoved: value => TokenConfig.appearance.padding.largeIncreased = value
        }

        StepperRow {
            label: Tr.tr("Extra large")
            subtext: Tr.tr("Inner spacing of large surfaces")
            value: TokenConfig.appearance.padding.extraLarge
            onMoved: value => TokenConfig.appearance.padding.extraLarge = value
        }

        StepperRow {
            label: Tr.tr("Extra large increased")
            subtext: Tr.tr("Inner spacing of extra large surfaces")
            value: TokenConfig.appearance.padding.extraLargeIncreased
            onMoved: value => TokenConfig.appearance.padding.extraLargeIncreased = value
        }

        StepperRow {
            last: true
            label: Tr.tr("Extra extra large")
            subtext: Tr.tr("Inner spacing of the largest surfaces")
            value: TokenConfig.appearance.padding.extraExtraLarge
            onMoved: value => TokenConfig.appearance.padding.extraExtraLarge = value
        }
    }
}
