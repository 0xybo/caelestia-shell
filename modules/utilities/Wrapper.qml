pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia
import Caelestia.Config
import qs.components
import qs.utils
import qs.modules.bar.popouts as BarPopouts

Item {
    id: root

    required property ScreenState screenState
    required property BarPopouts.Wrapper popouts
    required property int position
    property matrix4x4 deformMatrix

    readonly property bool onTop: BarLayout.isCornerOn(position, BarPosition.Top)
    readonly property bool onLeft: BarLayout.isCornerOn(position, BarPosition.Left)

    readonly property PersistentProperties props: PersistentProperties {
        property bool recordingListExpanded: false
        property string recordingConfirmDelete
        property string recordingMode

        reloadableId: "utilities"
    }
    readonly property bool shouldBeActive: screenState.utilities && Config.utilities.enabled && !(screenState.session && Config.session.enabled)
    readonly property real totalPadding: content.anchors.margins + CUtils.clamp(content.anchors.margins - Config.border.thickness, 0, content.anchors.margins)
    readonly property real nonAnimHeight: ((content.item as Content)?.nonAnimHeight ?? 0) + totalPadding
    property real offsetScale: shouldBeActive ? 0 : 1

    visible: offsetScale < 1
    x: onLeft ? 0 : parent.width - width
    y: onTop ? (-implicitHeight - 5) * offsetScale : parent.height - height + (implicitHeight + 5) * offsetScale
    implicitHeight: content.implicitHeight + totalPadding
    implicitWidth: Tokens.sizes.utilities.width
    opacity: 1 - offsetScale

    Behavior on offsetScale {
        Anim {}
    }

    Loader {
        id: content

        anchors.top: root.onTop ? undefined : parent.top
        anchors.bottom: root.onTop ? parent.bottom : undefined
        anchors.left: root.onLeft ? undefined : parent.left
        anchors.right: root.onLeft ? parent.right : undefined
        anchors.margins: Tokens.padding.large

        asynchronous: true
        active: root.shouldBeActive || root.visible

        sourceComponent: Content {
            implicitWidth: root.implicitWidth - root.totalPadding
            props: root.props
            screenState: root.screenState
            popouts: root.popouts
            deformMatrix: root.deformMatrix
        }
    }
}
