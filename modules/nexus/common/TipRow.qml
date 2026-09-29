pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services
import qs.modules.nexus.common

// Non-interactive notice, used for cautions and hints about advanced settings.
ConnectedRect {
    id: root

    property alias label: label.text
    property string body
    property string icon: "warning"
    property color containerColour: Colours.palette.m3errorContainer
    property color iconColour: Colours.palette.m3onErrorContainer
    property color bodyColour: Colours.palette.m3onErrorContainer

    Layout.fillWidth: true
    color: root.containerColour
    implicitHeight: rowLayout.implicitHeight + Tokens.padding.medium * 2

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        anchors.leftMargin: Tokens.padding.largeIncreased
        anchors.rightMargin: Tokens.padding.largeIncreased
        spacing: Tokens.spacing.medium

        MaterialIcon {
            text: root.icon
            color: root.iconColour
            fontStyle: Tokens.font.icon.small
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.extraSmall / 2

            StyledText {
                id: label

                Layout.fillWidth: true
                color: root.bodyColour
                font: Tokens.font.body.small
                wrapMode: Text.WordWrap
            }

            StyledText {
                Layout.fillWidth: true
                visible: root.body !== ""
                text: root.body
                color: root.bodyColour
                font: Tokens.font.label.small
                opacity: 0.8
                wrapMode: Text.WordWrap
            }
        }
    }
}
