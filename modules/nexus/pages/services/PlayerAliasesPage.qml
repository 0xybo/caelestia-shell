pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Player aliases")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: ObjectListEditor.FieldType.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Aliases")
        }

        ObjectListEditor {
            first: true
            rootParent: ObjectListEditor.FieldType.flickable
            values: GlobalConfig.services.playerAliases.values
            nameKey: "from"
            toggleKey: ""
            addLabel: Tr.tr("Add alias")
            addHeader: Tr.tr("Add alias")
            editHeader: Tr.tr("Edit alias")
            defaultItem: (() => ({
                            from: "",
                            to: ""
                        }))
            fields: [
                ObjectListEditor.Field {
                    key: "from"
                    label: Tr.tr("Player ID")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "to"
                    label: Tr.tr("Display name")
                    type: ObjectListEditor.FieldType.StringField
                }
            ]
            onItemAdded: item => GlobalConfig.services.playerAliases.insert(item)
            onItemUpdated: (index, item) => {
                const node = GlobalConfig.services.playerAliases.at(index);
                for (const key in item)
                    node[key] = item[key];
            }
            onItemMoved: (from, to) => GlobalConfig.services.playerAliases.move(from, to)
            onItemRemoved: index => GlobalConfig.services.playerAliases.remove(index)
            onItemToggled: (index, checked, key) => GlobalConfig.services.playerAliases.at(index)[key] = checked
        }
    }
}
