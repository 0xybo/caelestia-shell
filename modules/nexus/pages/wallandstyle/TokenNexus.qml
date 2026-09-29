pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Nexus")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Window
        SectionHeader {
            first: true
            text: Tr.tr("Window")
        }

        StepperRow {
            first: true
            label: Tr.tr("Height multiplier")
            subtext: Tr.tr("Window height as a fraction of the screen height")
            value: TokenConfig.sizes.nexus.heightMult
            from: 0.3
            to: 1
            stepSize: 0.01
            onMoved: value => TokenConfig.sizes.nexus.heightMult = value
        }

        StepperRow {
            label: Tr.tr("Aspect ratio")
            subtext: Tr.tr("Window width divided by height")
            value: TokenConfig.sizes.nexus.ratio
            from: 1
            to: 3
            stepSize: 0.01
            onMoved: value => TokenConfig.sizes.nexus.ratio = value
        }

        StepperRow {
            label: Tr.tr("Minimum width")
            subtext: Tr.tr("Narrowest the window can be dragged")
            value: TokenConfig.sizes.nexus.minWidth
            from: 300
            to: 3000
            stepSize: 10
            onMoved: value => TokenConfig.sizes.nexus.minWidth = value
        }

        StepperRow {
            label: Tr.tr("Minimum height")
            subtext: Tr.tr("Shortest the window can be dragged")
            value: TokenConfig.sizes.nexus.minHeight
            from: 200
            to: 3000
            stepSize: 10
            onMoved: value => TokenConfig.sizes.nexus.minHeight = value
        }

        // Content
        SectionHeader {
            text: Tr.tr("Content")
        }

        StepperRow {
            first: true
            label: Tr.tr("Navigation width")
            subtext: Tr.tr("Widest the navigation column can grow")
            value: TokenConfig.sizes.nexus.maxNavWidth
            from: 100
            to: 1000
            onMoved: value => TokenConfig.sizes.nexus.maxNavWidth = value
        }

        StepperRow {
            label: Tr.tr("Content width")
            subtext: Tr.tr("Widest the page content column can grow")
            value: TokenConfig.sizes.nexus.maxContentWidth
            from: 100
            to: 1000
            onMoved: value => TokenConfig.sizes.nexus.maxContentWidth = value
        }

        StepperRow {
            label: Tr.tr("Popup width")
            subtext: Tr.tr("Width of small popups such as the volume menu")
            value: TokenConfig.sizes.nexus.popupWidth
            from: 100
            to: 1000
            onMoved: value => TokenConfig.sizes.nexus.popupWidth = value
        }

        StepperRow {
            label: Tr.tr("Minimum popup height")
            subtext: Tr.tr("Shortest a small popup can be")
            value: TokenConfig.sizes.nexus.minPopupHeight
            from: 50
            to: 1000
            onMoved: value => TokenConfig.sizes.nexus.minPopupHeight = value
        }

        StepperRow {
            last: true
            label: Tr.tr("Maximum popup height")
            subtext: Tr.tr("Tallest a small popup can be")
            value: TokenConfig.sizes.nexus.maxPopupHeight
            from: 100
            to: 2000
            onMoved: value => TokenConfig.sizes.nexus.maxPopupHeight = value
        }

        // Details
        SectionHeader {
            text: Tr.tr("Details")
        }

        StepperRow {
            first: true
            // TRANSLATORS: Eth is the Ethernet connection type, leave it untranslated
            label: Tr.tr("Ethernet detail width")
            subtext: Tr.tr("Window width above which Eth details are shown (px)")
            value: TokenConfig.sizes.nexus.networkShowEthDetailWidth
            from: 100
            to: 2000
            onMoved: value => TokenConfig.sizes.nexus.networkShowEthDetailWidth = value
        }

        StepperRow {
            // TRANSLATORS: VPN is a network protocol, leave it untranslated
            label: Tr.tr("VPN detail width")
            subtext: Tr.tr("Window width above which VPN details are shown (px)")
            value: TokenConfig.sizes.nexus.networkShowVpnDetailWidth
            from: 100
            to: 2000
            onMoved: value => TokenConfig.sizes.nexus.networkShowVpnDetailWidth = value
        }

        // Dialogs
        SectionHeader {
            text: Tr.tr("Dialogs")
        }

        StepperRow {
            first: true
            label: Tr.tr("Maximum dialog width")
            subtext: Tr.tr("Widest a dialog can be")
            value: TokenConfig.sizes.nexus.maxDialogWidth
            from: 100
            to: 1000
            onMoved: value => TokenConfig.sizes.nexus.maxDialogWidth = value
        }

        StepperRow {
            label: Tr.tr("Maximum dialog height")
            subtext: Tr.tr("Tallest a dialog can be")
            value: TokenConfig.sizes.nexus.maxDialogHeight
            from: 100
            to: 2000
            onMoved: value => TokenConfig.sizes.nexus.maxDialogHeight = value
        }

        StepperRow {
            label: Tr.tr("Text field width")
            subtext: Tr.tr("Default width of text fields in dialogs")
            value: TokenConfig.sizes.nexus.textFieldWidth
            from: 50
            to: 1000
            onMoved: value => TokenConfig.sizes.nexus.textFieldWidth = value
        }

        StepperRow {
            last: true
            label: Tr.tr("Small text field width")
            subtext: Tr.tr("Default width of compact text fields in dialogs")
            value: TokenConfig.sizes.nexus.smallTextFieldWidth
            from: 50
            to: 1000
            onMoved: value => TokenConfig.sizes.nexus.smallTextFieldWidth = value
        }
    }
}
