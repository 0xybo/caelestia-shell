import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.Config
import Caelestia.I18n
import Caelestia.Services
import qs.components.controls
import qs.services
import qs.modules.nexus.common

PageBase {
    id: root

    // Lyrics backends, ordered to match config::LyricsBackend (Auto, Local, LRCLIB, NetEase)
    readonly property list<MenuItem> lyricsItems: [
        MenuItem {
            text: Tr.trCtx("Auto", "lyrics backend")
        },
        MenuItem {
            text: Tr.trCtx("Local", "lyrics backend")
        },
        MenuItem {
            text: "LRCLIB"
        },
        MenuItem {
            text: "NetEase"
        }
    ]

    // GPU types, ordered to match config::GpuType (Auto, Nvidia, Generic, None)
    readonly property list<MenuItem> gpuItems: [
        MenuItem {
            text: Tr.trCtx("Auto", "gpu type")
        },
        MenuItem {
            text: "NVIDIA"
        },
        MenuItem {
            text: Tr.trCtx("Generic", "gpu type")
        },
        MenuItem {
            text: Tr.trCtx("None", "gpu type")
        }
    ]

    title: Tr.tr("Services")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Detected running players, used as default-player options
        Variants {
            id: playerVariants

            model: [...new Set(Players.list.map(p => Players.getIdentity(p)).filter(id => id))]

            MenuItem {
                required property string modelData

                text: modelData
                icon: modelData === GlobalConfig.services.defaultPlayer ? "check" : ""
                activeIcon: "music_note"
            }
        }

        // Notifications
        SectionHeader {
            first: true
            text: Tr.tr("Notifications")
        }

        NavRow {
            first: true
            icon: "notifications"
            text: Tr.tr("Notifications")
            subtext: Tr.tr("Notifications, toasts, timeouts")
            onClicked: root.nState.openSubPage("notificationsPage")
        }

        NavRow {
            last: true
            icon: "settings_overscan"
            text: Tr.tr("On-screen display")
            subtext: Tr.tr("Brightness and microphone popups")
            onClicked: root.nState.openSubPage("osdPage")
        }

        // Media player
        SectionHeader {
            text: Tr.tr("Media Player")
        }

        NavRow {
            first: true
            icon: "music_note"
            text: Tr.tr("Player aliases")
            subtext: Tr.tr("Show friendlier names for media players")
            onClicked: root.nState.openSubPage("playerAliasesPage")
        }

        SelectRow {
            label: Tr.tr("Default player")
            subtext: Tr.tr("Preferred media player when several are open")
            menuItems: playerVariants.instances
            active: menuItems.find(i => i.text === GlobalConfig.services.defaultPlayer) ?? null
            fallbackIcon: "music_note"
            fallbackText: GlobalConfig.services.defaultPlayer || Tr.trCtx("Auto", "default media player")
            onSelected: item => GlobalConfig.services.defaultPlayer = item.text
        }

        StepperRow {
            last: true
            label: Tr.tr("Media refresh")
            // TRANSLATORS: ms is the millisecond unit, leave it untranslated
            subtext: Tr.tr("How often the media position updates (ms)")
            value: GlobalConfig.dashboard.mediaUpdateInterval
            from: 100
            to: 2000
            stepSize: 50
            onMoved: v => GlobalConfig.dashboard.mediaUpdateInterval = v
        }

        // Lyrics
        SectionHeader {
            text: Tr.tr("Lyrics")
        }

        SelectRow {
            first: true
            label: Tr.tr("Lyrics backend")
            subtext: Tr.tr("Source used to fetch synced lyrics")
            menuItems: root.lyricsItems
            active: root.lyricsItems[Lyrics.preferredBackend] ?? root.lyricsItems[0]
            onSelected: item => Lyrics.preferredBackend = root.lyricsItems.indexOf(item)
        }

        FilePickerRow {
            last: true
            label: Tr.tr("Lyrics folder")
            subtext: Tr.tr("Folder scanned for synced lyrics")
            value: GlobalConfig.paths.lyricsDir
            selectFolder: true
            onEditingFinished: v => GlobalConfig.paths.lyricsDir = v
        }

        // System
        SectionHeader {
            text: Tr.tr("System")
        }

        StepperRow {
            first: true
            // TRANSLATORS: CPU and GPU are hardware abbreviations, leave them untranslated
            label: Tr.tr("System stats refresh")
            subtext: Tr.tr("CPU, memory and GPU update interval (seconds)")
            value: GlobalConfig.dashboard.resourceUpdateInterval / 1000
            from: 0.5
            to: 10
            stepSize: 0.5
            onMoved: v => GlobalConfig.dashboard.resourceUpdateInterval = Math.round(v * 1000)
        }

        SelectRow {
            label: Tr.tr("GPU")
            subtext: Gpu.name ? Tr.tr("Monitoring: %1").arg(Gpu.name) : Tr.tr("Override for GPU type")
            menuOnTop: true
            menuItems: root.gpuItems
            active: root.gpuItems[GlobalConfig.services.gpuType]
            onSelected: item => GlobalConfig.services.gpuType = root.gpuItems.indexOf(item)
        }

        StepperRow {
            last: true
            label: Tr.tr("Brightness step")
            subtext: Tr.tr("Amount the brightness changes per scroll (%)")
            value: Math.round(GlobalConfig.services.brightnessIncrement * 100)
            from: 1
            to: 50
            stepSize: 1
            onMoved: v => GlobalConfig.services.brightnessIncrement = v / 100
        }
    }
}
