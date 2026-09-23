pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Idle")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Behaviour
        SectionHeader {
            first: true
            text: Tr.tr("Behaviour")
        }

        ToggleRow {
            first: true
            text: Tr.tr("Lock before sleep")
            subtext: Tr.tr("Lock the screen when the system sleeps")
            checked: GlobalConfig.general.idle.lockBeforeSleep
            onToggled: GlobalConfig.general.idle.lockBeforeSleep = checked
        }

        ToggleRow {
            text: Tr.tr("Inhibit when audio playing")
            subtext: Tr.tr("Don't idle while media is playing")
            checked: GlobalConfig.general.idle.inhibitWhenAudio
            onToggled: GlobalConfig.general.idle.inhibitWhenAudio = checked
        }

        ToggleRow {
            last: true
            text: Tr.tr("Inhibit when charging")
            subtext: Tr.tr("Don't idle while the battery is charging")
            checked: GlobalConfig.general.idle.inhibitWhenCharging
            onToggled: GlobalConfig.general.idle.inhibitWhenCharging = checked
        }

        // Timeouts
        SectionHeader {
            text: Tr.tr("Timeouts")
        }

        ObjectListEditor {
            first: true
            rootParent: root.flickable
            values: GlobalConfig.general.idle.timeouts.values
            nameKey: "timeout"
            toggleKey: "enabled"
            addLabel: Tr.tr("Add timeout")
            addHeader: Tr.tr("Add timeout")
            editHeader: Tr.tr("Edit timeout")
            defaultItem: (() => ({
                            enabled: true,
                            timeout: 300,
                            idleAction: "lock",
                            returnAction: "",
                            inhibitWhenAudio: false,
                            inhibitWhenCharging: false,
                            respectInhibitors: true
                        }))
            fields: [
                ObjectListEditor.Field {
                    key: "timeout"
                    label: Tr.trCtx("Timeout", "idle timeout")
                    type: root.IntField
                    from: 10
                    to: 86400
                    step: 10
                    placeholder: "s"
                },
                ObjectListEditor.Field {
                    key: "idleAction"
                    label: Tr.tr("Idle action")
                    type: root.StringListField
                },
                ObjectListEditor.Field {
                    key: "returnAction"
                    label: Tr.tr("Return action")
                    type: root.StringListField
                },
                ObjectListEditor.Field {
                    key: "inhibitWhenAudio"
                    label: Tr.tr("Inhibit when audio playing")
                    type: root.BoolField
                },
                ObjectListEditor.Field {
                    key: "inhibitWhenCharging"
                    label: Tr.tr("Inhibit when charging")
                    type: root.BoolField
                },
                ObjectListEditor.Field {
                    key: "respectInhibitors"
                    label: Tr.tr("Respect inhibitors")
                    type: root.BoolField
                }
            ]
            onItemAdded: item => GlobalConfig.general.idle.timeouts.insert(item)
            onItemUpdated: (index, item) => {
                const node = GlobalConfig.general.idle.timeouts.at(index);
                for (const key in item)
                    node[key] = item[key];
            }
            onItemMoved: (from, to) => GlobalConfig.general.idle.timeouts.move(from, to)
            onItemRemoved: index => GlobalConfig.general.idle.timeouts.remove(index)
            onItemToggled: (index, checked, key) => GlobalConfig.general.idle.timeouts.at(index)[key] = checked
        }
    }
}
