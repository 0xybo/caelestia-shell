pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.containers
import qs.modules.nexus.common

VerticalFadeFlickable {
    id: root

    // The editor is assigned by DialogRowButton after this component is loaded.
    property var editor

    anchors.fill: parent
    topMargin: Tokens.padding.medium
    bottomMargin: Tokens.padding.medium

    clip: true
    contentHeight: formBody.implicitHeight
    contentItem.children: [formBody]

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

    ColumnLayout {
        id: formBody

        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        spacing: Tokens.spacing.extraSmall / 2

        Repeater {
            model: root.editor?.fields ?? []

            delegate: Item {
                id: delegateItem

                required property var modelData
                readonly property var fieldInfo: modelData
                Layout.fillWidth: true

                implicitHeight: formLoader.active ? formLoader.item.implicitHeight : 0

                Loader {
                    id: formLoader

                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: {
                        return active ? delegateItem.implicitHeight : 0;
                    }
                    sourceComponent: root.compFor(delegateItem.fieldInfo.type)

                    onLoaded: {
                        item.fieldInfo = delegateItem.fieldInfo;
                        item.valueObj = root.editor.dialogItem;
                    }
                }
            }
        }
    }

    Component {
        id: stringRow

        TextFieldRow {
            property var fieldInfo
            property var valueObj

            label: fieldInfo.label ?? ""
            placeholderText: fieldInfo.placeholder ?? ""
            value: valueObj?.[fieldInfo.key] ?? ""
            onEditingFinished: v => valueObj[fieldInfo.key] = v
        }
    }

    Component {
        id: intRow

        StepperRow {
            property var fieldInfo
            property var valueObj

            label: fieldInfo.label ?? ""
            value: valueObj?.[fieldInfo.key] ?? 0
            from: fieldInfo.from ?? 0
            to: fieldInfo.to ?? 9999
            stepSize: fieldInfo.step ?? 1
            onMoved: v => valueObj[fieldInfo.key] = v
        }
    }

    Component {
        id: boolRow

        ToggleRow {
            property var fieldInfo
            property var valueObj

            text: fieldInfo.label ?? ""
            checked: valueObj?.[fieldInfo.key] === true
            onToggled: valueObj[fieldInfo.key] = checked
        }
    }

    Component {
        id: stringListRow

        StringListEditor {
            property var fieldInfo
            property var valueObj

            values: {
                const v = valueObj?.[fieldInfo.key];
                if (Array.isArray(v))
                    return v;
                const text = String(v ?? "");
                return text ? [text] : [];
            }
            addLabel: fieldInfo.label ?? Tr.tr("Add item")
            onItemAdded: v => valueObj[fieldInfo.key] = [...(valueObj[fieldInfo.key] ?? []), v]
            onItemRemoved: index => {
                const list = [...(valueObj[fieldInfo.key] ?? [])];
                list.splice(index, 1);
                valueObj[fieldInfo.key] = list;
            }
            onItemMoved: (from, to) => {
                const list = [...(valueObj[fieldInfo.key] ?? [])];
                const value = list.splice(from, 1)[0];
                list.splice(to, 0, value);
                valueObj[fieldInfo.key] = list;
            }
        }
    }
}
