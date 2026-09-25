pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Components
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.controls
import qs.components.images
import qs.services
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Wallpaper & style")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        StyledClippingRect {
            id: wallWrapper

            Layout.alignment: Qt.AlignHCenter
            implicitWidth: {
                const screen = root.nState.screen;
                return implicitHeight / screen.height * screen.width;
            }
            implicitHeight: {
                const screen = root.nState.screen;
                const cWidth = root.cappedWidth;
                return Math.min(Math.round(cWidth * 0.4), cWidth / screen.width * screen.height);
            }

            color: Colours.tPalette.m3surfaceContainer
            radius: Tokens.rounding.large

            Loader {
                anchors.centerIn: parent
                opacity: Config.background.wallpaperEnabled ? 0 : 1
                active: opacity > 0

                sourceComponent: ColumnLayout {
                    spacing: Tokens.spacing.extraSmall

                    MaterialIcon {
                        Layout.alignment: Qt.AlignHCenter
                        text: "hide_image"
                        color: Colours.palette.m3onSurfaceVariant
                        fontStyle: Tokens.font.icon.extraLarge
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: Tr.tr("Wallpaper disabled")
                        color: Colours.palette.m3onSurfaceVariant
                        font: Tokens.font.body.large
                    }
                }

                Behavior on opacity {
                    Anim {
                        type: Anim.SlowEffects
                    }
                }
            }

            Item {
                anchors.fill: parent
                opacity: Config.background.wallpaperEnabled ? 1 : 0

                Behavior on opacity {
                    Anim {
                        type: Anim.SlowEffects
                    }
                }

                Loader {
                    id: wallIndicatorLoader

                    anchors.centerIn: parent

                    opacity: 0
                    active: opacity > 0

                    sourceComponent: StyledRect {
                        implicitWidth: wallLoadingIndicator.implicitSize + Tokens.padding.largeIncreased * 2
                        implicitHeight: wallLoadingIndicator.implicitSize + Tokens.padding.largeIncreased * 2

                        color: Colours.palette.m3primaryContainer
                        radius: Tokens.rounding.full

                        LoadingIndicator {
                            id: wallLoadingIndicator

                            anchors.centerIn: parent
                            containsIcon: true
                            implicitSize: Math.min(wallWrapper.implicitWidth, wallWrapper.implicitHeight) * 0.4
                        }
                    }

                    Behavior on opacity {
                        Anim {
                            type: Anim.DefaultEffects
                        }
                    }
                }

                Timer {
                    id: wallLoadDebounceTimer

                    interval: 100
                    onTriggered: {
                        if (wallImg.status !== Image.Ready)
                            wallIndicatorLoader.opacity = 1;
                    }
                }

                FadeImage {
                    id: wallImg

                    anchors.fill: parent
                    source: Wallpapers.current
                    preventInit: wallIndicatorLoader.opacity > 0
                    fadeOutAnim: Anim.DefaultEffects
                    fadeInAnim: Anim.SlowEffects

                    onSourceChanged: wallLoadDebounceTimer.restart()

                    onStatusChanged: {
                        if (status === Image.Ready) {
                            wallLoadDebounceTimer.stop();
                            wallIndicatorLoader.opacity = 0;
                        }
                    }
                }
            }
        }

        ButtonRow {
            Layout.alignment: Qt.AlignHCenter
            spacing: Tokens.spacing.small

            IconTextButton {
                icon: "wallpaper"
                text: Tr.tr("Wallpapers")
                font: Tokens.font.body.large
                isRound: true
                shapeMorph: true
                type: IconTextButton.Tonal
                horizontalPadding: Tokens.padding.extraLarge
                verticalPadding: Tokens.padding.medium
                disabled: !Config.background.wallpaperEnabled
                onClicked: root.nState.openSubPage("wallpaperSelectPage") // Wallpaper page
            }

            IconTextButton {
                icon: "palette"
                text: Tr.tr("Colours")
                font: Tokens.font.body.large
                isRound: true
                shapeMorph: true
                type: IconTextButton.Tonal
                horizontalPadding: Tokens.padding.extraLarge
                verticalPadding: Tokens.padding.medium
                onClicked: root.nState.openSubPage("colourSelectPage") // Colours page
            }
        }

        // Background
        SectionHeader {
            text: Tr.tr("Background")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.background.enabled
            onToggled: GlobalConfig.background.enabled = checked
        }

        ToggleRow {
            text: Tr.tr("Display wallpaper")
            checked: Config.background.wallpaperEnabled
            onToggled: GlobalConfig.background.wallpaperEnabled = checked
        }

        FilePickerRow {
            last: true
            label: Tr.tr("Wallpaper folder")
            subtext: Tr.tr("Folder scanned for local wallpapers")
            value: GlobalConfig.paths.wallpaperDir
            selectFolder: true
            onEditingFinished: v => GlobalConfig.paths.wallpaperDir = v
        }

        // Overlays
        SectionHeader {
            text: Tr.tr("Overlays")
        }

        NavRow {
            first: true
            icon: "schedule"
            text: Tr.tr("Desktop clock")
            subtext: Tr.tr("Clock overlaid on the wallpaper")
            onClicked: root.nState.openSubPage("desktopClockPage")
        }

        NavRow {
            last: true
            icon: "monitor_heart"
            text: Tr.tr("Visualiser")
            subtext: Tr.tr("Audio visualiser on the wallpaper")
            onClicked: root.nState.openSubPage("visualiserPage")
        }

        // Transparency
        SectionHeader {
            text: Tr.tr("Transparency")
        }

        ToggleRow {
            first: true
            text: Tr.tr("Transparency")
            // TRANSLATORS: %1/%2 = opacity values from 0 to 1 for the base surface and layered surfaces
            subtext: Tr.tr("Base %1, layers %2").arg(Colours.transparency.base).arg(Colours.transparency.layers)
            checked: Colours.transparency.enabled
            onToggled: GlobalConfig.appearance.transparency.enabled = checked
        }

        StepperRow {
            label: Tr.tr("Base opacity")
            value: Config.appearance.transparency.base
            from: 0
            to: 1
            stepSize: 0.05
            onMoved: v => GlobalConfig.appearance.transparency.base = v
        }

        StepperRow {
            last: true
            label: Tr.tr("Layer opacity")
            value: Config.appearance.transparency.layers
            from: 0
            to: 1
            stepSize: 0.05
            onMoved: v => GlobalConfig.appearance.transparency.layers = v
        }

        // Scales
        SectionHeader {
            text: Tr.tr("Scales")
        }

        StepperRow {
            first: true
            label: Tr.tr("Deformation")
            subtext: Tr.tr("Scale of the surface deformation effect")
            value: Config.appearance.deformScale
            from: 0
            to: 2
            stepSize: 0.05
            onMoved: v => GlobalConfig.appearance.deformScale = v
        }

        StepperRow {
            label: Tr.tr("Rounding scale")
            value: Config.appearance.rounding.scale
            from: 0
            to: 3
            stepSize: 0.05
            onMoved: v => GlobalConfig.appearance.rounding.scale = v
        }

        StepperRow {
            label: Tr.tr("Spacing scale")
            value: Config.appearance.spacing.scale
            from: 0
            to: 3
            stepSize: 0.05
            onMoved: v => GlobalConfig.appearance.spacing.scale = v
        }

        StepperRow {
            label: Tr.tr("Padding scale")
            value: Config.appearance.padding.scale
            from: 0
            to: 3
            stepSize: 0.05
            onMoved: v => GlobalConfig.appearance.padding.scale = v
        }

        StepperRow {
            last: true
            label: Tr.tr("Animation scale")
            subtext: Tr.tr("Duration multiplier for animations")
            value: Config.appearance.anim.durations.scale
            from: 0
            to: 3
            stepSize: 0.05
            onMoved: v => GlobalConfig.appearance.anim.durations.scale = v
        }

        // Fonts
        SectionHeader {
            text: Tr.tr("Fonts")
        }

        StepperRow {
            first: true
            label: Tr.tr("Font scale")
            value: Config.appearance.font.scale
            from: 0.5
            to: 3
            stepSize: 0.05
            onMoved: v => GlobalConfig.appearance.font.scale = v
        }

        TextFieldRow {
            label: Tr.tr("Clock font")
            value: Config.appearance.font.clock
            onEditingFinished: v => GlobalConfig.appearance.font.clock = v
        }

        TextFieldRow {
            last: true
            label: Tr.tr("Workspaces font")
            value: Config.appearance.font.workspaces
            onEditingFinished: v => GlobalConfig.appearance.font.workspaces = v
        }

        // Theme
        SectionHeader {
            text: Tr.tr("Theme")
        }

        ToggleRow {
            first: true
            last: true
            text: Tr.tr("Dark theme")
            checked: !Colours.light
            onToggled: Colours.setMode(checked ? "dark" : "light")
        }

        // Borders
        SectionHeader {
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
