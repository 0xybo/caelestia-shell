pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Session")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // General
        SectionHeader {
            first: true
            text: Tr.tr("General")
        }

        ToggleRow {
            first: true
            text: Tr.trCtx("Enabled", "toggle label")
            checked: Config.session.enabled
            onToggled: GlobalConfig.session.enabled = checked
        }

        ToggleRow {
            text: Tr.tr("Vim keybinds")
            subtext: Tr.tr("Navigate the session screen with hjkl")
            checked: Config.session.vimKeybinds
            onToggled: GlobalConfig.session.vimKeybinds = checked
        }

        StepperRow {
            last: true
            label: Tr.tr("Drag threshold")
            subtext: Tr.tr("Pixels dragged before the session screen opens")
            value: Config.session.dragThreshold
            from: 0
            to: 200
            stepSize: 5
            onMoved: v => GlobalConfig.session.dragThreshold = v
        }

        // GIF
        SectionHeader {
            text: Tr.tr("Session GIF")
        }

        ToggleRow {
            first: true
            text: Tr.tr("Show GIF")
            checked: Config.session.showGif
            onToggled: GlobalConfig.session.showGif = checked
        }

        TextFieldRow {
            label: Tr.tr("Session GIF")
            subtext: Tr.tr("GIF shown on the lock screen")
            value: Config.paths.sessionGif
            onEditingFinished: v => GlobalConfig.paths.sessionGif = v
        }

        TextFieldRow {
            last: true
            label: Tr.tr("Session GIF speed")
            subtext: Tr.tr("Playback speed of the session GIF on the lock screen")
            value: GlobalConfig.general.sessionGifSpeed
            smallField: true
            validator: DoubleValidator {
                bottom: 0.1
                top: 2
            }
            onEditingFinished: v => GlobalConfig.general.sessionGifSpeed = Number(v)
        }

        // Icons
        SectionHeader {
            text: Tr.tr("Icons")
        }

        TextFieldRow {
            first: true
            label: Tr.tr("Log out")
            value: Config.session.icons.logout
            onEditingFinished: v => GlobalConfig.session.icons.logout = v
        }

        TextFieldRow {
            label: Tr.tr("Shut down")
            value: Config.session.icons.shutdown
            onEditingFinished: v => GlobalConfig.session.icons.shutdown = v
        }

        TextFieldRow {
            label: Tr.tr("Hibernate")
            value: Config.session.icons.hibernate
            onEditingFinished: v => GlobalConfig.session.icons.hibernate = v
        }

        TextFieldRow {
            last: true
            label: Tr.tr("Reboot")
            value: Config.session.icons.reboot
            onEditingFinished: v => GlobalConfig.session.icons.reboot = v
        }

        // Commands
        SectionHeader {
            text: Tr.tr("Commands")
        }

        SectionHeader {
            text: Tr.tr("Log out")
        }

        StringListEditor {
            first: true
            last: true
            values: Config.session.commands.logout
            addPlaceholderText: Tr.tr("Command")
            onItemAdded: v => GlobalConfig.session.commands.logout = [...Config.session.commands.logout, v]
            onItemMoved: (from, to) => {
                const list = [...Config.session.commands.logout];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.session.commands.logout = list;
            }
            onItemRemoved: index => {
                const list = [...Config.session.commands.logout];
                list.splice(index, 1);
                GlobalConfig.session.commands.logout = list;
            }
        }

        SectionHeader {
            text: Tr.tr("Shut down")
        }

        StringListEditor {
            first: true
            last: true
            values: Config.session.commands.shutdown
            addPlaceholderText: Tr.tr("Command")
            onItemAdded: v => GlobalConfig.session.commands.shutdown = [...Config.session.commands.shutdown, v]
            onItemMoved: (from, to) => {
                const list = [...Config.session.commands.shutdown];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.session.commands.shutdown = list;
            }
            onItemRemoved: index => {
                const list = [...Config.session.commands.shutdown];
                list.splice(index, 1);
                GlobalConfig.session.commands.shutdown = list;
            }
        }

        SectionHeader {
            text: Tr.tr("Hibernate")
        }

        StringListEditor {
            first: true
            last: true
            values: Config.session.commands.hibernate
            addPlaceholderText: Tr.tr("Command")
            onItemAdded: v => GlobalConfig.session.commands.hibernate = [...Config.session.commands.hibernate, v]
            onItemMoved: (from, to) => {
                const list = [...Config.session.commands.hibernate];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.session.commands.hibernate = list;
            }
            onItemRemoved: index => {
                const list = [...Config.session.commands.hibernate];
                list.splice(index, 1);
                GlobalConfig.session.commands.hibernate = list;
            }
        }

        SectionHeader {
            text: Tr.tr("Reboot")
        }

        StringListEditor {
            first: true
            last: true
            values: Config.session.commands.reboot
            addPlaceholderText: Tr.tr("Command")
            onItemAdded: v => GlobalConfig.session.commands.reboot = [...Config.session.commands.reboot, v]
            onItemMoved: (from, to) => {
                const list = [...Config.session.commands.reboot];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                GlobalConfig.session.commands.reboot = list;
            }
            onItemRemoved: index => {
                const list = [...Config.session.commands.reboot];
                list.splice(index, 1);
                GlobalConfig.session.commands.reboot = list;
            }
        }
    }
}
