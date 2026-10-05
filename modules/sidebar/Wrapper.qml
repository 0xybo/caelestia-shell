pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.components

Item {
    id: root

    required property ScreenState screenState
    required property bool onLeft
    readonly property Props props: Props {}

    readonly property bool shouldBeActive: (screenState.sidebar || screenState.sidebarTemporary) && Config.sidebar.enabled
    property real offsetScale: shouldBeActive ? 0 : 1

    visible: offsetScale < 1
    x: onLeft ? (-implicitWidth - 5) * offsetScale : parent.width - implicitWidth + (implicitWidth + 5) * offsetScale
    implicitWidth: Tokens.sizes.sidebar.width
    opacity: 1 - offsetScale

    Behavior on offsetScale {
        Anim {}
    }

    Loader {
        id: content

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Tokens.padding.medium

        active: root.shouldBeActive || root.visible

        sourceComponent: Content {
            implicitWidth: Tokens.sizes.sidebar.width - content.anchors.margins * 2
            props: root.props
            screenState: root.screenState
        }
    }
}
