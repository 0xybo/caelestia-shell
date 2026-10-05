pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.components

Item {
    id: root

    required property ScreenState screenState
    required property bool sidebarVisible
    required property bool onLeft
    readonly property real nonAnimWidth: content.implicitWidth

    readonly property bool shouldBeActive: screenState.session && Config.session.enabled
    property real offsetScale: shouldBeActive ? 0 : 1
    property real sidebarOffset: sidebarVisible ? 14 : 0

    visible: offsetScale < 1
    anchors.left: onLeft ? parent.left : undefined
    anchors.right: onLeft ? undefined : parent.right
    anchors.leftMargin: (-implicitWidth - 5 - sidebarOffset) * offsetScale
    anchors.rightMargin: (-implicitWidth - 5 - sidebarOffset) * offsetScale
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight || 510 // Hard coded fallback for first open
    opacity: 1 - offsetScale

    Behavior on offsetScale {
        Anim {}
    }

    Loader {
        id: content

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left

        active: root.shouldBeActive || root.visible

        sourceComponent: Content {
            screenState: root.screenState
        }
    }
}
