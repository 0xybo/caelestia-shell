pragma ComponentBehavior: Bound

import QtQuick
import Caelestia
import Caelestia.Config
import qs.components

Item {
    id: root

    required property ScreenState screenState
    required property bool onLeft
    readonly property Props props: Props {}

    readonly property bool shouldBeActive: screenState.sidebar && Config.sidebar.enabled
    property real offsetScale: shouldBeActive ? 0 : 1

    visible: offsetScale < 1
    anchors.left: onLeft ? parent.left : undefined
    anchors.right: onLeft ? undefined : parent.right
    anchors.leftMargin: onLeft ? (-implicitWidth - 5) * offsetScale : 0
    anchors.rightMargin: onLeft ? 0 : (-implicitWidth - 5) * offsetScale
    implicitWidth: Tokens.sizes.sidebar.width
    opacity: 1 - offsetScale

    Behavior on offsetScale {
        Anim {}
    }

    Loader {
        id: content

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: root.onLeft ? undefined : parent.left
        anchors.right: root.onLeft ? parent.right : undefined
        anchors.margins: Tokens.padding.large
        anchors.bottomMargin: 0

        active: root.shouldBeActive || root.visible

        sourceComponent: Content {
            implicitWidth: Tokens.sizes.sidebar.width - content.anchors.margins * 2
            props: root.props
            screenState: root.screenState
        }
    }
}
