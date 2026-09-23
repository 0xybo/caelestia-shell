pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Border")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Border")
        }

        StepperRow {
            first: true
            label: Tr.tr("Thickness")
            subtext: Tr.tr("Border width around the screen edges")
            value: Config.border.thickness
            from: Config.border.minThickness
            to: 100
            stepSize: 1
            onMoved: v => GlobalConfig.border.thickness = v
        }

        StepperRow {
            label: Tr.tr("Rounding")
            subtext: Tr.tr("Corner radius of the border")
            value: Config.border.rounding
            from: 0
            to: 100
            stepSize: 1
            onMoved: v => GlobalConfig.border.rounding = v
        }

        StepperRow {
            last: true
            label: Tr.tr("Smoothing")
            subtext: Tr.tr("How smoothly the border blends")
            value: Config.border.smoothing
            from: 1
            to: 100
            stepSize: 1
            onMoved: v => GlobalConfig.border.smoothing = v
        }
    }
}
