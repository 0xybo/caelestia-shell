pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    // Which icon rule list to edit, set by the nav row using NexusState.editRulesType
    readonly property string listKey: {
        switch (root.nState.editRulesType) {
        case "special":
            return "specialWorkspaceIcons";
        case "window":
            return "windowIcons";
        default:
            return "workspaceIcons";
        }
    }

    title: {
        switch (root.nState.editRulesType) {
        case "special":
            return Tr.tr("Special workspace icons");
        case "window":
            return Tr.tr("Window icons");
        default:
            return Tr.tr("Workspace icons");
        }
    }
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Rules")
        }

        ObjectListEditor {
            first: true
            rootParent: root.flickable
            values: GlobalConfig.bar.workspaces[root.listKey].values
            nameKey: "name"
            toggleKey: ""
            addLabel: Tr.tr("Add rule")
            addHeader: Tr.tr("Add rule")
            editHeader: Tr.tr("Edit rule")
            defaultItem: (() => ({
                            name: "",
                            regex: "",
                            flags: "",
                            icon: ""
                        }))
            fields: [
                ObjectListEditor.Field {
                    key: "name"
                    label: Tr.tr("Name")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "regex"
                    label: Tr.tr("Regex")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "flags"
                    label: Tr.tr("Flags")
                    type: ObjectListEditor.FieldType.StringField
                },
                ObjectListEditor.Field {
                    key: "icon"
                    label: Tr.tr("Icon")
                    type: ObjectListEditor.FieldType.StringField
                }
            ]
            onItemAdded: item => GlobalConfig.bar.workspaces[root.listKey].insert(item)
            onItemUpdated: (index, item) => {
                const node = GlobalConfig.bar.workspaces[root.listKey].at(index);
                for (const key in item)
                    node[key] = item[key];
            }
            onItemMoved: (from, to) => GlobalConfig.bar.workspaces[root.listKey].move(from, to)
            onItemRemoved: index => GlobalConfig.bar.workspaces[root.listKey].remove(index)
            onItemToggled: (index, checked, key) => GlobalConfig.bar.workspaces[root.listKey].at(index)[key] = checked
        }
    }
}
