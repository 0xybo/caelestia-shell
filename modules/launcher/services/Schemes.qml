pragma Singleton

import ".."
import QtQuick
import Quickshell
import Quickshell.Io
import Caelestia.Config
import qs.utils

Searcher {
    id: root

    property string currentName
    property string currentFlavour
    readonly property string currentScheme: `${currentName} ${currentFlavour}`
    property string currentVariant
    readonly property bool loaded: currentName !== ""

    function transformSearch(search: string): string {
        return search.slice(`${GlobalConfig.launcher.actionPrefix}scheme `.length);
    }

    function selector(item: var): string {
        return `${item.name} ${item.flavour}`;
    }

    function names(): var {
        const names = [];
        for (const scheme of list) {
            if (!names.includes(scheme.name))
                names.push(scheme.name);
        }
        return names;
    }

    function flavoursFor(name: string): var {
        const flavours = [];
        for (const scheme of list) {
            if (scheme.name === name && !flavours.includes(scheme.flavour))
                flavours.push(scheme.flavour);
        }
        return flavours;
    }

    function reload(): void {
        getCurrent.running = true;
    }

    function set(name: string, flavour: string): void {
        if (!name || name === currentName && (!flavour || flavour === currentFlavour))
            return;

        const args = ["caelestia", "scheme", "set", "-n", name];
        if (flavour)
            args.push("-f", flavour);
        Quickshell.execDetached(args);
        syncTimer.restart();
    }

    function setVariant(variant: string): void {
        if (!variant || variant === currentVariant)
            return;

        Quickshell.execDetached(["caelestia", "scheme", "set", "-v", variant]);
        syncTimer.restart();
    }

    list: schemes.instances
    useFuzzy: GlobalConfig.launcher.useFuzzy.schemes
    keys: ["name", "flavour"]
    weights: [0.9, 0.1]

    Variants {
        id: schemes

        Scheme {}
    }

    Process {
        id: getSchemes

        running: true
        command: ["caelestia", "scheme", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                const schemeData = JSON.parse(text);
                const list = Object.entries(schemeData).map(([name, f]) => Object.entries(f).map(([flavour, colours]) => ({
                                name,
                                flavour,
                                colours
                            })));

                const flat = [];
                for (const s of list)
                    for (const f of s)
                        flat.push(f);

                schemes.model = flat.sort((a, b) => String(a.name + a.flavour).localeCompare((b.name + b.flavour)));
            }
        }
    }

    Process {
        id: getCurrent

        running: true
        command: ["caelestia", "scheme", "get", "-nfv"]
        stdout: StdioCollector {
            onStreamFinished: {
                const [name, flavour, variant] = text.trim().split("\n");
                root.currentName = name ?? "";
                root.currentFlavour = flavour ?? "";
                root.currentVariant = variant ?? "";
            }
        }
    }

    Timer {
        id: syncTimer

        interval: 400
        onTriggered: root.reload()
    }

    component Scheme: QtObject {
        required property var modelData
        readonly property string name: modelData.name
        readonly property string flavour: modelData.flavour
        readonly property var colours: modelData.colours

        function onClicked(list: AppList): void {
            list.screenState.launcher = false;
            root.set(name, flavour);
        }
    }
}
