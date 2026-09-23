pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.controls
import qs.services
import qs.modules.nexus.common

ColumnLayout {
    id: root

    property var values: []
    property string addLabel: Tr.tr("Add item")
    property string addPlaceholderText: ""
    property string labelKey: "name"
    property bool first
    property bool last

    signal itemAdded(value: string)
    signal itemMoved(from: int, to: int)
    signal itemRemoved(index: int)

    function addItem(): void {
        const value = addField.text.trim();
        if (value)
            root.itemAdded(value);
        addField.text = "";
    }

    spacing: Tokens.spacing.extraSmall / 2

    ConnectedRect {
        Layout.fillWidth: true
        first: root.first

        implicitHeight: addRow.implicitHeight + addRow.anchors.margins * 2

        RowLayout {
            id: addRow

            anchors.fill: parent
            anchors.margins: Tokens.padding.medium
            anchors.leftMargin: Tokens.padding.largeIncreased
            anchors.rightMargin: Tokens.padding.medium
            spacing: Tokens.spacing.medium

            StyledTextField {
                id: addField

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                placeholderText: root.addPlaceholderText
                verticalPadding: Tokens.padding.small
                onAccepted: addItem()
            }

            IconButton {
                type: IconButton.Tonal
                isRound: true
                icon: "add"
                label.fill: 0
                onClicked: addItem()
            }
        }
    }

    ListEditor {
        function labelFor(item: var): string {
            if (typeof item === "string")
                return item;
            return item?.[root.labelKey] ?? "";
        }

        values: root.values
        showToggle: false
        last: root.last

        onItemMoved: (from, to) => root.itemMoved(from, to)
        onItemRemoved: index => root.itemRemoved(index)
    }
}
