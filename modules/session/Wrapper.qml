pragma ComponentBehavior: Bound

import QtQuick
import qs.components

Item {
    id: root

    required property ScreenState screenState
    required property bool sidebarVisible
    required property bool shouldBeActive
    required property real offsetScale

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight || 510 // Hard coded fallback for first open

    Loader {
        id: content

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left

        active: root.shouldBeActive

        sourceComponent: Content {
            screenState: root.screenState
        }
    }
}
