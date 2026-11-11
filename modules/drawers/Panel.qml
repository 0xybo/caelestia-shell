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
        End,
        None
    }
    enum SlidingDirection {
        Horizontal,
        Vertical
    }

    required property string name
    required property bool shouldBeActive

    required property Item content

    required property int slidingDirection

    property int verticalAlignment: Panel.Alignment.None
    property int horizontalAlignment: Panel.Alignment.None

    property Drawers.Trigger trigger

    property real margin: 0
    property real slideOffset: 5

    property real offsetScale: shouldBeActive ? 0 : 1

    readonly property bool opened: root.offsetScale <= 0
    readonly property bool closed: root.offsetScale >= 1
    readonly property real horizontalOffsetScale: root.slidingDirection === Panel.SlidingDirection.Horizontal ? root.offsetScale : 0
    readonly property real verticalOffsetScale: root.slidingDirection === Panel.SlidingDirection.Vertical ? root.offsetScale : 0

    implicitWidth: root.content.implicitWidth
    implicitHeight: root.content.implicitHeight
    opacity: 1 - root.offsetScale
    visible: root.offsetScale < 1

    x: {
        switch (root.horizontalAlignment) {
        case Panel.Alignment.Start:
            return root.margin - (root.width + root.slideOffset) * root.horizontalOffsetScale;
        case Panel.Alignment.Center:
            return (root.parent.width - root.width) / 2;
        case Panel.Alignment.End:
            return root.parent.width - root.width - root.margin + (root.width + root.slideOffset) * root.horizontalOffsetScale;
        default:
            return 0;
        }
    }
    y: {
        switch (root.verticalAlignment) {
        case Panel.Alignment.Start:
            return root.margin - (root.height + root.slideOffset) * root.verticalOffsetScale;
        case Panel.Alignment.Center:
            return (root.parent.height - root.height) / 2;
        case Panel.Alignment.End:
            return root.parent.height - root.height - root.margin + (root.height + root.slideOffset) * root.verticalOffsetScale;
        default:
            return 0;
        }
    }

    Behavior on offsetScale {
        Anim {}
    }
}
