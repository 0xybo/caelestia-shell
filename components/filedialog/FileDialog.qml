pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.I18n
import qs.components
import qs.services
import qs.utils

LazyLoader {
    id: loader

    property list<string> cwd: ["Home"]
    property string filterLabel: Tr.tr("All files")
    property list<string> filters: ["*"]
    property string title: Tr.tr("Select a file")
    property bool selectFolder: false

    signal accepted(path: string)
    signal rejected

    function open(): void {
        activeAsync = true;
    }

    function close(): void {
        rejected();
    }

    onAccepted: activeAsync = false
    onRejected: activeAsync = false

    FloatingWindow {
        id: root

        property list<string> cwd: loader.cwd
        property string filterLabel: loader.filterLabel
        property list<string> filters: loader.filters
        property bool selectFolder: loader.selectFolder

        readonly property bool selectionValid: {
            if (selectFolder)
                return true;
            const file = folderContents.currentItem?.modelData;
            return (file && !file.isDir && (filters.includes("*") || filters.some(filter => filter.toLowerCase() === file.suffix.toLowerCase()))) ?? false;
        }

        function accepted(path: string): void {
            loader.accepted(path);
        }

        function rejected(): void {
            loader.rejected();
        }

        function currentFolderPath(): string {
            if (cwd[0] === "Home")
                return Paths.home + `/${cwd.slice(1).join("/")}`;
            return cwd.join("/");
        }

        function selectedPath(): string {
            const file = folderContents.currentItem?.modelData;
            if (selectFolder) {
                if (file?.isDir)
                    return file.path;
                return currentFolderPath();
            }
            return file?.path ?? "";
        }

        implicitWidth: 1000
        implicitHeight: 600
        minimumSize.width: 400
        minimumSize.height: 300
        color: Colours.tPalette.m3surface
        surfaceFormat.opaque: false
        title: loader.title

        onVisibleChanged: {
            if (!visible)
                rejected();
        }

        RowLayout {
            anchors.fill: parent

            spacing: 0

            Sidebar {
                Layout.fillHeight: true
                dialog: root
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                spacing: 0

                HeaderBar {
                    Layout.fillWidth: true
                    dialog: root
                }

                FolderContents {
                    id: folderContents

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    dialog: root
                }

                DialogButtons {
                    Layout.fillWidth: true
                    dialog: root
                    folder: folderContents
                }
            }
        }

        Behavior on color {
            CAnim {}
        }
    }
}
