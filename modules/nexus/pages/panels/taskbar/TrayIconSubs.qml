pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Tray icon substitutions")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Substitutions")
        }

        ObjectListEditor {
            first: true
            rootParent: root.flickable
            values: GlobalConfig.bar.tray.iconSubs.values
            nameKey: "id"
            toggleKey: ""
            addLabel: Tr.tr("Add substitution")
            addHeader: Tr.tr("Add substitution")
            editHeader: Tr.tr("Edit substitution")
            defaultItem: (() => ({
                            id: "",
                            icon: "",
                            image: ""
                        }))
            fields: [
                ObjectListEditor.Field {
                    key: "id"
                    label: Tr.tr("Icon ID")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "icon"
                    label: Tr.tr("Icon")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "image"
                    label: Tr.tr("Image")
                    type: ObjectListEditor.FieldType.FileField
                }
            ]
            onItemAdded: item => GlobalConfig.bar.tray.iconSubs.insert(item)
            onItemUpdated: (index, item) => {
                const node = GlobalConfig.bar.tray.iconSubs.at(index);
                for (const key in item)
                    node[key] = item[key];
            }
            onItemMoved: (from, to) => GlobalConfig.bar.tray.iconSubs.move(from, to)
            onItemRemoved: index => GlobalConfig.bar.tray.iconSubs.remove(index)
            onItemToggled: (index, checked, key) => GlobalConfig.bar.tray.iconSubs.at(index)[key] = checked
        }
    }
}
