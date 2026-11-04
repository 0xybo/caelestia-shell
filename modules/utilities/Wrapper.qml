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
    required property real offsetScale
    required property BarPopouts.Wrapper popouts
    required property int position
    property matrix4x4 deformMatrix

    // readonly property bool onTop: BarLayout.isCornerOn(position, BarPosition.Top)
    // readonly property bool onLeft: BarLayout.isCornerOn(position, BarPosition.Left)
    // readonly property real padding: Tokens.padding.large

    readonly property PersistentProperties props: PersistentProperties {
        property bool recordingListExpanded: false
        property string recordingConfirmDelete
        property string recordingMode

        reloadableId: "utilities"
    }
    // readonly property bool shouldBeActive: Config.utilities.enabled && (screenState.utilities || (screenState.utilitiesTemporary && (!(Config.session.enabled && screenState.session) || Config.utilities.alsoShowSidebar)))
    // readonly property real totalPadding: content.anchors.margins + CUtils.clamp(content.anchors.margins - Config.border.thickness, 0, content.anchors.margins)
    // readonly property real nonAnimHeight: ((content.item as Content)?.nonAnimHeight ?? 0) + totalPadding
    // property real offsetScale: shouldBeActive ? 0 : 1

    // x: onLeft ? 0 : parent.width - width
    // y: onTop ? (-implicitHeight - 5) * offsetScale : parent.height - height + (implicitHeight + 5) * offsetScale
    implicitHeight: content.implicitHeight + content.anchors.margins * 2
    implicitWidth: Tokens.sizes.utilities.width + content.anchors.margins * 2
    opacity: 1 - offsetScale

    // Behavior on offsetScale {
    //     Anim {}
    // }

    Loader {
        id: content

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: Tokens.padding.medium

        asynchronous: true
        active: root.shouldBeActive || root.visible

        sourceComponent: Content {
            implicitWidth: Tokens.sizes.utilities.width
            props: root.props
            screenState: root.screenState
            popouts: root.popouts
            deformMatrix: root.deformMatrix
        }
    }
}
