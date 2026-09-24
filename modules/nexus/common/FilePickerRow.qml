pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.controls
import qs.components.filedialog
import qs.services
import qs.modules.nexus.common

ConnectedRect {
    id: root

    property alias label: label.text
    property string subtext
    property string value
    property alias placeholderText: input.placeholderText
    property bool smallField
    property bool selectFolder
    property string filterLabel: Tr.tr("All files")
    property list<string> filters: ["*"]
    property string dialogTitle: root.selectFolder ? Tr.tr("Select a folder") : Tr.tr("Select a file")

    signal editingFinished(value: string)

    function openPicker(): void {
        picker.open();
    }

    Layout.fillWidth: true
    implicitHeight: rowLayout.implicitHeight + Tokens.padding.medium + Math.max(0, Tokens.padding.large - input.verticalPadding) * 2

    FileDialog {
        id: picker

        title: root.dialogTitle
        filterLabel: root.filterLabel
        filters: root.filters
        selectFolder: root.selectFolder

        onAccepted: path => root.editingFinished(path)
    }

    RowLayout {
        id: rowLayout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Tokens.padding.largeIncreased
        anchors.rightMargin: Tokens.padding.largeIncreased
        spacing: Tokens.spacing.medium

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                id: label

                Layout.fillWidth: true
                font: Tokens.font.body.small
                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true
                visible: root.subtext
                text: root.subtext
                color: Colours.palette.m3outline
                font: Tokens.font.label.small
                elide: Text.ElideRight
            }
        }

        StyledTextField {
            id: input

            Layout.preferredWidth: root.smallField ? Tokens.sizes.nexus.smallTextFieldWidth : Tokens.sizes.nexus.textFieldWidth
            Layout.maximumWidth: root.width / 2
            Layout.alignment: Qt.AlignVCenter
            verticalPadding: Tokens.padding.small

            text: root.value

            onEditingFinished: root.editingFinished(text)
        }

        IconButton {
            Layout.alignment: Qt.AlignVCenter

            type: IconButton.Tonal
            icon: "folder_open"
            onClicked: root.openPicker()
        }
    }
}
