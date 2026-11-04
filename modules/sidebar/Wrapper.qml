pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.components

Item {
    id: root

    required property ScreenState screenState
    required property real offsetScale
    readonly property Props props: Props {}

    implicitWidth: Tokens.sizes.sidebar.width
    opacity: 1 - root.offsetScale

    Loader {
        id: content

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Tokens.padding.medium

        active: root.offsetScale < 1

        sourceComponent: Content {
            implicitWidth: Tokens.sizes.sidebar.width - content.anchors.margins * 2
            props: root.props
            screenState: root.screenState
        }
    }
}
