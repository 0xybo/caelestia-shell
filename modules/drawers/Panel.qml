pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.components
import qs.modules.drawers as Drawers

Item {
    id: root

    enum Alignment {
        Start,
        Center,
        End
    }
    enum SlidingDirection {
        Horizontal,
        Vertical
    }

    required property string name
    required property bool shouldBeActive

    required property EdgeGeometry geometry

    required property Item content
    required property Drawers.Trigger trigger

    required property int verticalAlignment
    required property int horizontalAlignment
    required property int slidingDirection

    property real offsetScale: shouldBeActive ? 0 : 1

    readonly property bool opened: root.offsetScale <= 0
    readonly property bool closed: root.offsetScale >= 1
    readonly property real horizontalOffsetScale: root.slidingDirection === Panel.SlidingDirection.Horizontal ? root.offsetScale : 0
    readonly property real verticalOffsetScale: root.slidingDirection === Panel.SlidingDirection.Vertical ? root.offsetScale : 0

    implicitWidth: root.content.implicitWidth
    implicitHeight: root.content.implicitHeight

    x: {
        switch (root.horizontalAlignment) {
        case Panel.Alignment.Start:
            return root.geometry.insetLeft(0) - (root.width + 5) * root.horizontalOffsetScale;
        case Panel.Alignment.Center:
            return (root.parent.width - root.width) / 2;
        case Panel.Alignment.End:
            return root.parent.width - root.width - root.geometry.insetRight(0) + (root.width + 5) * root.horizontalOffsetScale;
        default:
            return 0;
        }
    }
    y: {
        switch (root.verticalAlignment) {
        case Panel.Alignment.Start:
            return root.geometry.insetTop(0) - (root.height + 5) * root.verticalOffsetScale;
        case Panel.Alignment.Center:
            return (root.parent.height - root.height) / 2;
        case Panel.Alignment.End:
            return root.parent.height - root.height - root.geometry.insetBottom(0) + (root.height + 5) * root.verticalOffsetScale;
        default:
            return 0;
        }
    }

    Behavior on offsetScale {
        Anim {}
    }
}
