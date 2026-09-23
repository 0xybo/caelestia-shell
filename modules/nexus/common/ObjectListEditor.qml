pragma ComponentBehavior: Bound

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
        StringListField
    }

    // Plain copy of the object being added (-1) or edited (>= 0)
    property var dialogItem: ({})
    property int editIndex: -1

    readonly property Component formComp: Component {
        VerticalFadeFlickable {
            anchors.fill: parent
            topMargin: Tokens.padding.medium
            bottomMargin: Tokens.padding.medium

            clip: true
            contentHeight: formBody.implicitHeight
            contentItem.children: [formBody]

            ColumnLayout {
                id: formBody

                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                spacing: Tokens.spacing.extraSmall / 2

                Repeater {
                    model: root.fields

                    delegate: Item {
                        required property var modelData
                        readonly property var field: modelData
                        Layout.fillWidth: true

                        implicitHeight: formLoader.active ? formLoader.item.implicitHeight : 0

                        Loader {
                            id: formLoader

                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: active ? item.implicitHeight : 0
                            sourceComponent: root.compFor(modelData.type)

                            onLoaded: {
                                formLoader.item.field = modelData;
                                formLoader.item.valueObj = root.dialogItem;
                            }
                        }
                    }
                }
            }
        }
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

    function compFor(type: int): Component {
        switch (type) {
        case ObjectListEditor.FieldType.IntField:
            return intRow;
        case ObjectListEditor.FieldType.BoolField:
            return boolRow;
        case ObjectListEditor.FieldType.StringListField:
            return stringListRow;
        default:
            return stringRow;
        }
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
        last: root.last
        showToggle: root.toggleKey.length > 0
        editable: root.fields.length > 0

        onItemMoved: (from, to) => root.itemMoved(from, to)
        onItemRemoved: index => root.itemRemoved(index)
        onItemToggled: (index, checked) => root.itemToggled(index, checked, root.toggleKey)
        onItemEditRequested: index => root.startEdit(index)
    }

    Loader {
        active: root.last

        Layout.fillWidth: true

        sourceComponent: StyledRect {
            implicitHeight: Tokens.rounding.extraLarge * 2
            color: Colours.tPalette.m3surfaceContainer
            bottomLeftRadius: Tokens.rounding.extraLarge
            bottomRightRadius: Tokens.rounding.extraLarge
        }
    }

    DialogRowButton {
        id: dialog

        rootParent: root.rootParent
        icon: "add"
        label: root.addLabel
        header: root.editIndex >= 0 ? root.editHeader : root.addHeader
        acceptLabel: root.acceptLabel
        content: root.formComp

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

    Component {
        id: stringRow

        TextFieldRow {
            required property var field
            required property var valueObj

            label: field.label ?? ""
            placeholderText: field.placeholder ?? ""
            value: valueObj?.[field.key] ?? ""
            onEditingFinished: v => valueObj[field.key] = v
        }
    }

    Component {
        id: intRow

        StepperRow {
            required property var field
            required property var valueObj

            label: field.label ?? ""
            value: valueObj?.[field.key] ?? 0
            from: field.from ?? 0
            to: field.to ?? 9999
            stepSize: field.step ?? 1
            onMoved: v => valueObj[field.key] = v
        }
    }

    Component {
        id: boolRow

        ToggleRow {
            required property var field
            required property var valueObj

            text: field.label ?? ""
            checked: valueObj?.[field.key] === true
            onToggled: valueObj[field.key] = checked
        }
    }

    Component {
        id: stringListRow

        StringListEditor {
            required property var field
            required property var valueObj

            values: {
                const v = valueObj?.[field.key];
                if (Array.isArray(v))
                    return v;
                const text = String(v ?? "");
                return text ? [text] : [];
            }
            addLabel: field.label ?? Tr.tr("Add item")
            onItemAdded: v => valueObj[field.key] = [...(valueObj[field.key] ?? []), v]
            onItemRemoved: index => {
                const list = [...(valueObj[field.key] ?? [])];
                list.splice(index, 1);
                valueObj[field.key] = list;
            }
            onItemMoved: (from, to) => {
                const list = [...(valueObj[field.key] ?? [])];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                valueObj[field.key] = list;
            }
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
