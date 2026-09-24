import QtQuick
import QtQuick.Controls
import Caelestia.Config
import qs.components
import qs.modules.nexus

StackView {
    id: root

    required property NexusState nState
    required property var pages
    readonly property int animMovement: Tokens.padding.extraExtraLarge * 2

    function openSubPage(id: string, immediate: bool): void {
        const page = pages.find(p => p.name === id)?.component;
        if (page) {
            push(page, {
                nState
            }, immediate ? StackView.Immediate : StackView.PushTransition);
        } else {
            console.warn(logCat, "Attempted to open invalid sub-page with id", id);
            nState.closeSubPage();
        }
    }

    clip: busy

    Component.onCompleted: {
        openSubPage("main", true);
        for (const page of nState.subPageIdStack)
            openSubPage(page, true);
    }

    pushEnter: Transition {
        SequentialAnimation {
            PropertyAction {
                property: "opacity"
                value: 0
            }
            PauseAnimation {
                duration: Tokens.anim.durations.expressiveDefaultEffects
            }
            ParallelAnimation {
                Anim {
                    property: "opacity"
                    to: 1
                    type: Anim.SlowEffects
                }
                Anim {
                    property: "x"
                    from: root.animMovement
                    to: 0
                    type: Anim.SlowEffects
                }
            }
        }
    }

    pushExit: Transition {
        Anim {
            property: "opacity"
            to: 0
            type: Anim.DefaultEffects
        }
    }

    popEnter: Transition {
        SequentialAnimation {
            PropertyAction {
                property: "opacity"
                value: 0
            }
            PauseAnimation {
                duration: Tokens.anim.durations.expressiveDefaultEffects
            }
            ParallelAnimation {
                Anim {
                    property: "opacity"
                    to: 1
                    type: Anim.SlowEffects
                }
                Anim {
                    property: "x"
                    from: -root.animMovement
                    to: 0
                    type: Anim.SlowEffects
                }
            }
        }
    }

    popExit: Transition {
        Anim {
            property: "opacity"
            to: 0
            type: Anim.DefaultEffects
        }
    }

    LoggingCategory {
        id: logCat

        name: "caelestia.nexus"
        defaultLogLevel: LoggingCategory.Info
    }

    Connections {
        function onSubPageOpened(id: string): void {
            root.openSubPage(id, false);
        }

        function onSubPageClosed(): void {
            if (root.depth < root.nState.subPageIdStack.length) {
                console.log(logCat, "Attempted to close page while depth < stack depth. Ignoring.");
                return;
            }
            root.pop();
        }

        target: root.nState
    }
}
