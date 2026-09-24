import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.containers
import qs.services
import qs.modules.nexus.common

ColumnLayout {
    id: root

    required property Item rootParent
    property var values
    property list<Field> fields: []
    property string nameKey: "name"
    property string toggleKey: ""
    property var defaultItem: function (): var {
        return {};
    }
    property string addLabel: Tr.tr("Add item")
    property string addHeader: Tr.tr("Add item")
    property string editHeader: Tr.tr("Edit item")
    property string acceptLabel: Tr.trCtx("Save", "button")
    property bool first
    property bool last

    enum FieldType {
        StringField,
        IntField,
        BoolField,
        StringListField,
        FileField
    }

    // Plain copy of the object being added (-1) or edited (>= 0)
    property var dialogItem: ({})
    property int editIndex: -1

    readonly property Component formComp: Component {
        ObjectListForm {}
    }

    signal itemAdded(item: var)
    signal itemUpdated(index: int, item: var)
    signal itemMoved(from: int, to: int)
    signal itemRemoved(index: int)
    signal itemToggled(index: int, checked: bool, key: string)

    function startEdit(index: int): void {
        const source = root.values?.[index];
        const item = {};
        for (const f of root.fields)
            item[f.key] = source?.[f.key];
        root.dialogItem = item;
        root.editIndex = index;
        dialog.open = true;
    }

    spacing: Tokens.spacing.extraSmall / 2

    ListEditor {
        function labelFor(item: var): string {
            return item?.[root.nameKey] ?? "";
        }

        function toggledFor(item: var): bool {
            return root.toggleKey ? !!item[root.toggleKey] : false;
        }

        values: root.values
        first: root.first
        showToggle: root.toggleKey.length > 0
        editable: root.fields.length > 0

        onItemMoved: (from, to) => root.itemMoved(from, to)
        onItemRemoved: index => root.itemRemoved(index)
        onItemToggled: (index, checked) => root.itemToggled(index, checked, root.toggleKey)
        onItemEditRequested: index => root.startEdit(index)
    }

    DialogRowButton {
        id: dialog

        rootParent: root.rootParent
        icon: "add"
        label: root.addLabel
        header: root.editIndex >= 0 ? root.editHeader : root.addHeader
        acceptLabel: root.acceptLabel
        content: root.formComp
        contentContext: root

        onOpenChanged: {
            if (!dialog.open)
                return;
            if (root.editIndex < 0)
                root.dialogItem = root.defaultItem();
        }

        onAccepted: {
            if (root.editIndex >= 0)
                root.itemUpdated(root.editIndex, root.dialogItem);
            else
                root.itemAdded(root.dialogItem);
        }
    }

    component Field: QtObject {
        required property string key
        property string label
        property string placeholder
        property int type: ObjectListEditor.FieldType.StringField
        property real from: 0
        property real to: 9999
        property real step: 1
    }
}
