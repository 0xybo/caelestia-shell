pragma Singleton

import QtQuick
import Caelestia.I18n

QtObject {
    id: root

    readonly property list<var> pages: [
        // Appearance
        {
            key: "wallpaperAndStyle",
            label: Tr.tr("Wallpaper & style"),
            icon: "palette",
            description: Tr.tr("Wallpaper, fonts, colours"),
            category: "appearance"
        },

        // Connectivity
        // TODO
        // {
        //     key: "display",
        //     label: Tr.tr("Display"),
        //     icon: "monitor",
        //     description: Tr.tr("Output configuration"),
        //     category: "connectivity"
        // },
        {
            key: "network",
            label: Tr.tr("Network"),
            icon: "wifi",
            description: Tr.tr("Wi-Fi, ethernet, VPN"),
            category: "connectivity"
        },
        {
            key: "connectedDevices",
            label: Tr.tr("Connected devices"),
            icon: "devices_other",
            description: Tr.tr("Bluetooth, pairing"),
            category: "connectivity",
            noFill: true
        },
        {
            key: "audio",
            label: Tr.tr("Audio"),
            icon: "volume_up",
            description: Tr.tr("App volumes, sound devices"),
            category: "connectivity"
        },

        // System
        {
            key: "updates",
            label: Tr.tr("Updates"),
            icon: "update",
            description: Tr.tr("System updates"),
            category: "system"
        },
        {
            key: "plugins",
            label: Tr.tr("Plugins"),
            icon: "extension",
            description: Tr.tr("Manage plugins"),
            category: "system"
        },

        // Shell
        {
            key: "general",
            label: Tr.tr("General"),
            icon: "toggle_on",
            description: Tr.tr("Idle, battery, print timeouts"),
            category: "shell"
        },
        {
            key: "lock",
            label: Tr.tr("Lock"),
            icon: "lock",
            description: Tr.tr("Lock screen, fingerprint, howdy"),
            category: "shell"
        },
        {
            key: "panels",
            label: Tr.tr("Panels"),
            icon: "dock_to_bottom",
            description: Tr.tr("Dashboard, taskbar, launcher, sidebar"),
            category: "shell"
        },
        {
            key: "apps",
            label: Tr.tr("Apps"),
            icon: "apps",
            description: Tr.tr("Default apps, favourites, hidden apps"),
            category: "shell"
        },
        {
            key: "services",
            label: Tr.tr("Services"),
            icon: "build",
            description: Tr.tr("Media player, lyrics, system"),
            category: "shell"
        },
        {
            key: "languageAndRegion",
            label: Tr.tr("Language & region"),
            icon: "globe",
            description: Tr.tr("UI language, weather location, display units"),
            category: "shell"
        },

        // About
        {
            key: "about",
            label: Tr.tr("About"),
            icon: "info",
            description: Tr.tr("System information, credits"),
            category: "about"
        },
    ]

    function indexOf(key: string): int {
        return pages.findIndex(p => p.key === key);
    }
}
