pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Battery")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        // Critical level
        SectionHeader {
            first: true
            text: Tr.tr("Critical level")
        }

        StepperRow {
            first: true
            last: true
            label: Tr.tr("Battery level")
            subtext: Tr.tr("Level at which the system acts on critical battery")
            value: GlobalConfig.general.battery.criticalLevel
            from: 0
            to: 100
            stepSize: 1
            onMoved: v => GlobalConfig.general.battery.criticalLevel = v
        }

        // Warnings
        SectionHeader {
            text: Tr.tr("Warnings")
        }

        ObjectListEditor {
            first: true
            rootParent: root.flickable
            values: GlobalConfig.general.battery.warnLevels.values
            nameKey: "title"
            toggleKey: ""
            addLabel: Tr.tr("Add warning")
            addHeader: Tr.tr("Add warning")
            editHeader: Tr.tr("Edit warning")
            defaultItem: (() => ({
                            level: 20,
                            title: "",
                            message: "",
                            icon: "battery_alert",
                            critical: false
                        }))
            fields: [
                ObjectListEditor.Field {
                    key: "level"
                    label: Tr.tr("Battery level (%)")
                    type: ObjectListEditor.FieldType.IntField
                    from: 0
                    to: 100
                    step: 1
                },
                ObjectListEditor.Field {
                    key: "title"
                    label: Tr.tr("Title")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "message"
                    label: Tr.tr("Message")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "icon"
                    label: Tr.tr("Icon")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "critical"
                    label: Tr.tr("Critical")
                    type: ObjectListEditor.FieldType.BoolField
                }
            ]
            onItemAdded: item => GlobalConfig.general.battery.warnLevels.insert(item)
            onItemUpdated: (index, item) => {
                const node = GlobalConfig.general.battery.warnLevels.at(index);
                for (const key in item)
                    node[key] = item[key];
            }
            onItemMoved: (from, to) => GlobalConfig.general.battery.warnLevels.move(from, to)
            onItemRemoved: index => GlobalConfig.general.battery.warnLevels.remove(index)
            onItemToggled: (index, checked, key) => GlobalConfig.general.battery.warnLevels.at(index)[key] = checked
        }
    }
}
