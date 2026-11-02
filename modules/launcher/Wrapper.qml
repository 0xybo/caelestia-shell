pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.components
import qs.modules.launcher.services
import qs.modules.drawers

Item {
    id: root

    required property ShellScreen screen
    required property ScreenState screenState
    required property EdgeGeometry geometry
    required property var panels

    readonly property real maxHeight: {
        let max = panels.height;
        if (screenState.shouldDashboardVisible)
            max -= panels.dashboard.implicitHeight + Tokens.padding.extraLarge;
        return max;
    }

    required property bool shouldBeActive
    required property real offsetScale

    onShouldBeActiveChanged: {
        if (shouldBeActive)
            implicitHeight = Qt.binding(() => content.implicitHeight);
        else
            implicitHeight = implicitHeight; // Break binding during close anim
    }

    anchors.bottomMargin: (-implicitHeight - 5) * offsetScale
    implicitHeight: content.implicitHeight // Fallback for first open
    implicitWidth: content.implicitWidth || 630 // Hard coded fallback for first open

    Component.onCompleted: Qt.callLater(() => Apps) // Load apps on init

    Loader {
        id: content

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        active: root.shouldBeActive || root.visible

        sourceComponent: Content {
            screenState: root.screenState
            panels: root.panels
            maxHeight: root.maxHeight
        }
    }
}
