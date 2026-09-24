import QtQuick
import Quickshell
import Quickshell.Bluetooth

QtObject {
    property ShellScreen screen
    property bool isWindow
    property bool animatingContainer
    property int currentPageIdx
    property list<string> subPageIdStack
    property bool searchOpen

    property string selectedWallpaperCategory
    property BluetoothDevice selectedBtDevice
    property DesktopEntry selectedApp
    property int editingVpnIndex: -1
    property string selectedNetworkSsid
    property string selectedEthernetInterface
    property bool networkDetailsFromSaved
    property string editRulesType

    signal close
    signal subPageOpened(id: string)
    signal subPageClosed

    function openSubPage(id: string): void {
        subPageIdStack.push(id);
        subPageOpened(id);
    }

    function closeSubPage(): void {
        subPageClosed();
        subPageIdStack.pop();
    }

    onCurrentPageIdxChanged: subPageIdStack.length = 0
}
