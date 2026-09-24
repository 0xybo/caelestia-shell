pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.utils
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Lock")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Lock screen
        SectionHeader {
            first: true
            text: Tr.tr("Lock screen")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.lock.enabled
            onToggled: GlobalConfig.lock.enabled = checked
        }

        ToggleRow {
            text: Tr.tr("Blur the wallpaper")
            checked: Config.lock.useWallpaper
            onToggled: GlobalConfig.lock.useWallpaper = checked
        }

        ToggleRow {
            text: Tr.tr("Recolour logo")
            checked: Config.lock.recolourLogo
            onToggled: GlobalConfig.lock.recolourLogo = checked
        }

        ToggleRow {
            text: Tr.tr("Hide notifications")
            subtext: Tr.tr("Keep notifications out of the lock screen")
            checked: Config.lock.hideNotifs
            onToggled: GlobalConfig.lock.hideNotifs = checked
        }

        FilePickerRow {
            last: true
            label: Tr.tr("No notifications image")
            subtext: Tr.tr("Image shown on the lock screen when there are no notifications")
            value: Config.paths.lockNoNotifsPic
            filterLabel: Tr.tr("Image files")
            filters: Images.validImageExtensions
            onEditingFinished: v => GlobalConfig.paths.lockNoNotifsPic = v
        }

        // Fingerprint
        SectionHeader {
            text: Tr.tr("Fingerprint")
        }

        ToggleRow {
            first: true
            text: Tr.tr("Authentication")
            checked: GlobalConfig.lock.enableFprint
            onToggled: GlobalConfig.lock.enableFprint = checked
        }

        StepperRow {
            last: true
            label: Tr.tr("Max tries")
            subtext: Tr.tr("Attempts before the lock screen hides the prompt")
            value: GlobalConfig.lock.maxFprintTries
            from: 1
            to: 10
            stepSize: 1
            onMoved: v => GlobalConfig.lock.maxFprintTries = v
        }

        // Howdy
        SectionHeader {
            text: Tr.tr("Howdy")
        }

        ToggleRow {
            first: true
            text: Tr.tr("Face authentication")
            checked: GlobalConfig.lock.enableHowdy
            onToggled: GlobalConfig.lock.enableHowdy = checked
        }

        ToggleRow {
            text: Tr.tr("Trigger on wake")
            subtext: Tr.tr("Run face authentication when the screen wakes")
            checked: GlobalConfig.lock.triggerHowdyOnWake
            onToggled: GlobalConfig.lock.triggerHowdyOnWake = checked
        }

        StepperRow {
            last: true
            label: Tr.tr("Max tries")
            subtext: Tr.tr("Attempts before the lock screen hides the prompt")
            value: GlobalConfig.lock.maxHowdyTries
            from: 1
            to: 10
            stepSize: 1
            onMoved: v => GlobalConfig.lock.maxHowdyTries = v
        }

        // Session
        SectionHeader {
            text: Tr.tr("Session")
        }

        ToggleRow {
            first: true
            last: true
            text: Tr.tr("Session controls")
            subtext: Tr.tr("Show session controls on the lock screen")
            checked: GlobalConfig.lock.enableSessionControls
            onToggled: GlobalConfig.lock.enableSessionControls = checked
        }
    }
}
