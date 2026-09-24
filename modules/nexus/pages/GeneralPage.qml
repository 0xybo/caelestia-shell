pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("General")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Misc
        SectionHeader {
            first: true
            text: Tr.tr("Misc")
        }

        TextFieldRow {
            first: true
            label: Tr.tr("Logo")
            subtext: Tr.tr("Brand image shown on the lock screen")
            value: GlobalConfig.general.logo
            onEditingFinished: v => GlobalConfig.general.logo = v
        }

        ToggleRow {
            last: true
            text: Tr.tr("Show over fullscreen")
            subtext: Tr.tr("Show widgets even when fullscreen apps are focused")
            checked: Config.general.showOverFullscreen
            onToggled: GlobalConfig.general.showOverFullscreen = checked
        }

        // Idle
        SectionHeader {
            text: Tr.tr("Idle")
        }

        NavRow {
            first: true
            last: true
            icon: "coffee"
            text: Tr.tr("Idle timeouts")
            subtext: Tr.tr("Actions triggered when the system idles")
            onClicked: root.nState.openSubPage("idlePage")
        }

        // Battery
        SectionHeader {
            text: Tr.tr("Battery")
        }

        NavRow {
            first: true
            last: true
            icon: "battery_saver"
            text: Tr.tr("Battery warnings")
            subtext: Tr.tr("Notify when battery levels get low")
            onClicked: root.nState.openSubPage("batteryPage")
        }

        // Apps
        SectionHeader {
            text: Tr.tr("Apps")
        }

        SectionHeader {
            text: Tr.tr("Terminal")
        }

        StringListEditor {
            first: true
            last: true
            values: GlobalConfig.general.apps.terminal
            addPlaceholderText: Tr.tr("Command name")
            onItemAdded: v => GlobalConfig.general.apps.terminal = [...GlobalConfig.general.apps.terminal, v]
            onItemMoved: (from, to) => {
                const list = [...GlobalConfig.general.apps.terminal];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.general.apps.terminal = list;
            }
            onItemRemoved: index => {
                const list = [...GlobalConfig.general.apps.terminal];
                list.splice(index, 1);
                GlobalConfig.general.apps.terminal = list;
            }
        }

        SectionHeader {
            text: Tr.tr("Audio mixer")
        }

        StringListEditor {
            first: true
            last: true
            values: GlobalConfig.general.apps.audio
            addPlaceholderText: Tr.tr("Command name")
            onItemAdded: v => GlobalConfig.general.apps.audio = [...GlobalConfig.general.apps.audio, v]
            onItemMoved: (from, to) => {
                const list = [...GlobalConfig.general.apps.audio];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.general.apps.audio = list;
            }
            onItemRemoved: index => {
                const list = [...GlobalConfig.general.apps.audio];
                list.splice(index, 1);
                GlobalConfig.general.apps.audio = list;
            }
        }

        SectionHeader {
            text: Tr.tr("Media player")
        }

        StringListEditor {
            first: true
            last: true
            values: GlobalConfig.general.apps.playback
            addPlaceholderText: Tr.tr("Command name")
            onItemAdded: v => GlobalConfig.general.apps.playback = [...GlobalConfig.general.apps.playback, v]
            onItemMoved: (from, to) => {
                const list = [...GlobalConfig.general.apps.playback];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.general.apps.playback = list;
            }
            onItemRemoved: index => {
                const list = [...GlobalConfig.general.apps.playback];
                list.splice(index, 1);
                GlobalConfig.general.apps.playback = list;
            }
        }

        SectionHeader {
            text: Tr.tr("File explorer")
        }

        StringListEditor {
            first: true
            last: true
            values: GlobalConfig.general.apps.explorer
            addPlaceholderText: Tr.tr("Command name")
            onItemAdded: v => GlobalConfig.general.apps.explorer = [...GlobalConfig.general.apps.explorer, v]
            onItemMoved: (from, to) => {
                const list = [...GlobalConfig.general.apps.explorer];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.general.apps.explorer = list;
            }
            onItemRemoved: index => {
                const list = [...GlobalConfig.general.apps.explorer];
                list.splice(index, 1);
                GlobalConfig.general.apps.explorer = list;
            }
        }
    }
}
