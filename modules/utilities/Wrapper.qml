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

    readonly property PersistentProperties props: PersistentProperties {
        property bool recordingListExpanded: false
        property string recordingConfirmDelete
        property string recordingMode

        reloadableId: "utilities"
    }

    implicitHeight: content.implicitHeight + content.anchors.margins * 2
    implicitWidth: Tokens.sizes.utilities.width

    Loader {
        id: content

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: Tokens.padding.medium

        asynchronous: true
        active: root.offsetScale < 1

        sourceComponent: Content {
            implicitWidth: Tokens.sizes.utilities.width - content.anchors.margins * 2
            props: root.props
            screenState: root.screenState
            popouts: root.popouts
            deformMatrix: root.deformMatrix
        }
    }
}
