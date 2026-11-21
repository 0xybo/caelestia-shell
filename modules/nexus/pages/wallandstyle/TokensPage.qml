import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.services
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Tokens")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        TipRow {
            first: true
            last: true
            label: Tr.tr("Caution")
            body: Tr.tr("Do NOT change any of these options unless you know what you are doing. These options control the tokens used internally within the shell, and can cause visual issues if modified incorrectly. The available options may change or be removed without notice across versions.")
        }

        TipRow {
            first: true
            last: true
            icon: "description"
            label: Tr.tr("Where these values live")
            // TRANSLATORS: shell-tokens.json and shell.json are file names, leave them untranslated
            body: Tr.tr("These values are written to shell-tokens.json in your Caelestia config directory, with per-monitor overrides in monitors/<monitor>/shell-tokens.json. The appearance scale values in shell.json are multiplied against them to produce the final values.")
            containerColour: Colours.palette.m3secondaryContainer
            iconColour: Colours.palette.m3onSecondaryContainer
            bodyColour: Colours.palette.m3onSecondaryContainer
        }

        // Appearance
        SectionHeader {
            text: Tr.tr("Appearance")
        }

        NavRow {
            first: true
            icon: "rounded_corner"
            text: Tr.tr("Shape")
            subtext: Tr.tr("Corner rounding and padding")
            onClicked: root.nState.openSubPage("tokenShapePage")
        }

        NavRow {
            icon: "space_bar"
            text: Tr.tr("Spacing")
            subtext: Tr.tr("Gaps between elements")
            onClicked: root.nState.openSubPage("tokenSpacingPage")
        }

        NavRow {
            last: true
            icon: "animation"
            text: Tr.tr("Animation")
            subtext: Tr.tr("Animation durations")
            onClicked: root.nState.openSubPage("tokenAnimPage")
        }

        // Sizes
        SectionHeader {
            text: Tr.tr("Sizes")
        }

        NavRow {
            first: true
            last: true
            icon: "dashboard"
            text: Tr.tr("Nexus")
            subtext: Tr.tr("Window and dialog dimensions")
            onClicked: root.nState.openSubPage("tokenNexusPage")
        }
    }
}
