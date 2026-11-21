pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    required property ShellScreen screen
    required property ScreenState screenState
    required property bool sidebarVisible
    required property bool besideSession
    required property real sessionHeight
    required property bool besideSidebar
    required property bool besideDashboard
    required property real dashboardHeight
    required property bool onLeft
    required property real offsetScale
    required property bool shouldBeActive

    property bool hovered
    readonly property Brightness.Monitor monitor: Brightness.getMonitorForScreen(root.screen)
    property real sidebarOffset: sidebarVisible ? 12 : 0

    property real volume
    property bool muted
    property real sourceVolume
    property bool sourceMuted
    property real brightness

    property bool timerRunning: timer.running

    function show(): void {
        screenState.osd = true;
        timer.restart();
    }

    onBesideDashboardChanged: {
        if (shouldBeActive && !hovered)
            timer.restart();
    }

    onBesideSidebarChanged: {
        if (shouldBeActive && !hovered)
            timer.restart();
    }

    onBesideSessionChanged: {
        if (shouldBeActive && !hovered)
            timer.restart();
    }

    Component.onCompleted: {
        volume = Audio.volume;
        muted = Audio.muted;
        sourceVolume = Audio.sourceVolume;
        sourceMuted = Audio.sourceMuted;
        brightness = root.monitor?.brightness ?? 0;
    }

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight
    anchors.rightMargin: onLeft ? 0 : -sidebarOffset

    Connections {
        function onMutedChanged(): void {
            root.show();
            root.muted = Audio.muted;
        }

        function onVolumeChanged(): void {
            root.show();
            root.volume = Audio.volume;
        }

        function onSourceMutedChanged(): void {
            root.show();
            root.sourceMuted = Audio.sourceMuted;
        }

        function onSourceVolumeChanged(): void {
            root.show();
            root.sourceVolume = Audio.sourceVolume;
        }

        target: Audio
    }

    Connections {
        function onBrightnessChanged(): void {
            root.show();
            root.brightness = root.monitor?.brightness ?? 0;
        }

        target: root.monitor
    }

    Timer {
        id: timer

        interval: root.Config.osd.hideDelay
        onTriggered: {
            if (!root.hovered)
                root.screenState.osd = false;
        }
    }

    Loader {
        id: content

        readonly property real baseHeight: Tokens.sizes.osd.sliderHeight * 3 + Tokens.spacing.medium * 2 + Config.border.thickness * 2 + 10
        readonly property bool showMicrophone: Config.osd.enableMicrophone && !(root.besideSession && root.sessionHeight < baseHeight) && !(root.besideDashboard && root.dashboardHeight < baseHeight)

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left

        asynchronous: true
        active: root.shouldBeActive

        sourceComponent: Content {
            monitor: root.monitor
            screenState: root.screenState
            volume: root.volume
            muted: root.muted
            sourceVolume: root.sourceVolume
            sourceMuted: root.sourceMuted
            brightness: root.brightness
            showMicrophone: content.showMicrophone
        }
    }
}
