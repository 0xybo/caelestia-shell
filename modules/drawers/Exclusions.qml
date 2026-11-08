pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.services
import qs.components.containers
import qs.modules.bar as Bar

Scope {
    id: root

    required property ShellScreen screen
    required property Bar.BarWrapper bar

    readonly property var geometry: ShellState.geometryFor(screen)

    Component.onCompleted: console.log(`Exclusions: geometry for ${screen.name} => ${geometry}`)

    ExclusionZone {
        anchors.left: true
        hasBar: root.geometry.bar.onLeft
    }

    ExclusionZone {
        anchors.top: true
        hasBar: root.geometry.bar.onTop
    }

    ExclusionZone {
        anchors.right: true
        hasBar: root.geometry.bar.onRight
    }

    ExclusionZone {
        anchors.bottom: true
        hasBar: root.geometry.bar.onBottom
    }

    component ExclusionZone: StyledWindow {
        property bool hasBar

        screen: root.screen
        name: "border-exclusion"
        exclusiveZone: hasBar ? root.bar.exclusiveZone : contentItem.Config.border.thickness
        mask: Region {}
        implicitWidth: 1
        implicitHeight: 1
    }
}
