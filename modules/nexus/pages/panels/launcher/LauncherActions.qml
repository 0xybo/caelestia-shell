pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Launcher actions")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Actions")
        }

        ObjectListEditor {
            first: true
            rootParent: root.flickable
            values: GlobalConfig.launcher.actions.values
            nameKey: "name"
            toggleKey: "enabled"
            addLabel: Tr.tr("Add action")
            addHeader: Tr.tr("Add action")
            editHeader: Tr.tr("Edit action")
            defaultItem: (() => ({
                            enabled: true,
                            name: "",
                            icon: "",
                            description: "",
                            command: [],
                            dangerous: false
                        }))
            fields: [
                ObjectListEditor.Field {
                    key: "name"
                    label: Tr.tr("Name")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "icon"
                    label: Tr.tr("Icon")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "description"
                    label: Tr.tr("Description")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "command"
                    label: Tr.tr("Command")
                    type: ObjectListEditor.FieldType.StringListField
                },
                ObjectListEditor.Field {
                    key: "dangerous"
                    label: Tr.tr("Dangerous")
                    type: ObjectListEditor.FieldType.BoolField
                }
            ]
            onItemAdded: item => GlobalConfig.launcher.actions.insert(item)
            onItemUpdated: (index, item) => {
                const node = GlobalConfig.launcher.actions.at(index);
                for (const key in item)
                    node[key] = item[key];
            }
            onItemMoved: (from, to) => GlobalConfig.launcher.actions.move(from, to)
            onItemRemoved: index => GlobalConfig.launcher.actions.remove(index)
            onItemToggled: (index, checked, key) => GlobalConfig.launcher.actions.at(index)[key] = checked
        }
    }
}
