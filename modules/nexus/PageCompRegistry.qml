pragma Singleton

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services
import qs.modules.nexus.common
import qs.modules.nexus.pages
import qs.modules.nexus.pages.apps
import qs.modules.nexus.pages.audio
import qs.modules.nexus.pages.bluetooth
import qs.modules.nexus.pages.network
import qs.modules.nexus.pages.panels
import qs.modules.nexus.pages.services
import qs.modules.nexus.pages.wallandstyle
import qs.modules.nexus.pages.general
import qs.modules.nexus.pages.panels.taskbar
import qs.modules.nexus.pages.panels.launcher

QtObject {
    id: root

    // qmlformat off
    readonly property list<Component> pageComps: [
        // Appearance
        Component {
            // Wallpaper & style
            StackPage {
                Component { id: main; WallpaperAndStyle {} }
                Component { id: wallpaperSelectPage; WallpaperSelect {} }
                Component { id: wallpaperCategoryPage; WallpaperCategory {} }
                Component { id: colourSelectPage; ColourSelect {} }
                Component { id: desktopClockPage; DesktopClockPage {} }
                Component { id: visualiserPage; VisualiserPage {} }

                pages: [
                    { name: "main", component: main },
                    { name: "wallpaperSelectPage", component: wallpaperSelectPage },
                    { name: "wallpaperCategoryPage", component: wallpaperCategoryPage },
                    { name: "colourSelectPage", component: colourSelectPage },
                    { name: "desktopClockPage", component: desktopClockPage },
                    { name: "visualiserPage", component: visualiserPage }
                ]
            }
        },

        // Connectivity
        Component {
            // Network
            StackPage {
                Component { id: main; NetworkPage {} }
                Component { id: ethernetDetailPage; EthernetDetailPage {} }
                Component { id: addNetworkPage; AddNetworkPage {} }
                Component { id: networkDetailPage; NetworkDetailPage {} }
                Component { id: addVpnPage; AddVpnPage {} }
                Component { id: allNetworksPage; AllNetworksPage {} }
                Component { id: savedNetworksPage; SavedNetworksPage {} }

                pages: [
                    { name: "main", component: main },
                    { name: "ethernetDetailPage", component: ethernetDetailPage },
                    { name: "addNetworkPage", component: addNetworkPage },
                    { name: "networkDetailPage", component: networkDetailPage },
                    { name: "addVpnPage", component: addVpnPage },
                    { name: "allNetworksPage", component: allNetworksPage },
                    { name: "savedNetworksPage", component: savedNetworksPage }
                ]
            }
        },
        Component {
            // Bluetooth
            StackPage {
                Component { id: main; BluetoothPage {} }
                Component { id: btDeviceInfoPage; BtDeviceInfo {} }
                Component { id: bluetoothPairingPage; BluetoothPairing {} }

                pages: [
                    { name: "main", component: main },
                    { name: "btDeviceInfoPage", component: btDeviceInfoPage },
                    { name: "bluetoothPairingPage", component: bluetoothPairingPage }
                ]
            }
        },
        Component {
            // Audio
            StackPage {
                Component { id: main; AudioPage {} }
                Component { id: appVolumesPage; AppVolumes {} }

                pages: [
                    { name: "main", component: main },
                    { name: "appVolumesPage", component: appVolumesPage }
                ]
            }
        },

        // System
        Component {
            PlaceholderComp {}
        },
        Component {
            PlaceholderComp {}
        },

        // Shell
        Component {
            // General
            StackPage {
                Component { id: main; GeneralPage {} }
                Component { id: idlePage; IdlePage {} }
                Component { id: batteryPage; BatteryPage {} }

                pages: [
                    { name: "main", component: main },
                    { name: "idlePage", component: idlePage },
                    { name: "batteryPage", component: batteryPage }
                ]
            }
        },
        Component {
            // Lock
            StackPage {
                Component { id: main; LockPage {} }

                pages: [
                    { name: "main", component: main }
                ]
            }
        },
        Component {
            // Panels
            StackPage {
                Component { id: main; PanelsPage {} }
                Component { id: dashboardPanel; DashboardPanel {} }
                Component { id: taskbarPanel; TaskbarPanel {} }
                Component { id: launcherPanel; LauncherPanel {} }
                Component { id: sidebarPanel; SidebarPanel {} }
                Component { id: utilitiesPanel; UtilitiesPanel {} }
                Component { id: sessionPanel; SessionPanel {} }
                Component { id: barWorkspaces; BarWorkspaces {} }
                Component { id: barActiveWindow; BarActiveWindow {} }
                Component { id: barTray; BarTray {} }
                Component { id: barStatusIcons; BarStatusIcons {} }
                Component { id: barClock; BarClock {} }
                Component { id: workspaceIconRules; WorkspaceIconRules {} }
                Component { id: workspaceIconRulesSpecial; WorkspaceIconRules {} }
                Component { id: workspaceIconRulesWindow; WorkspaceIconRules {} }
                Component { id: trayIconSubs; TrayIconSubs {} }
                Component { id: launcherActions; LauncherActions {} }

                pages: [
                    { name: "main", component: main },
                    { name: "dashboardPanel", component: dashboardPanel },
                    { name: "taskbarPanel", component: taskbarPanel },
                    { name: "launcherPanel", component: launcherPanel },
                    { name: "sidebarPanel", component: sidebarPanel },
                    { name: "utilitiesPanel", component: utilitiesPanel },
                    { name: "sessionPanel", component: sessionPanel },
                    { name: "barWorkspaces", component: barWorkspaces },
                    { name: "barActiveWindow", component: barActiveWindow },
                    { name: "barTray", component: barTray },
                    { name: "barStatusIcons", component: barStatusIcons },
                    { name: "barClock", component: barClock },
                    { name: "workspaceIconRules", component: workspaceIconRules },
                    { name: "workspaceIconRulesSpecial", component: workspaceIconRulesSpecial },
                    { name: "workspaceIconRulesWindow", component: workspaceIconRulesWindow },
                    { name: "trayIconSubs", component: trayIconSubs },
                    { name: "launcherActions", component: launcherActions }
                ]
            }
        },
        Component {
            // Apps
            StackPage {
                Component { id: main; AppsPage {} }
                Component { id: allAppsPage; AllApps {} }
                Component { id: appInfoPage; AppInfo {} }

                pages: [
                    { name: "main", component: main },
                    { name: "allAppsPage", component: allAppsPage },
                    { name: "appInfoPage", component: appInfoPage }
                ]
            }
        },
        Component {
            // Services
            StackPage {
                Component { id: main; ServicesPage {} }
                Component { id: notificationsPage; NotificationsPage {} }
                Component { id: osdPage; OsdPage {} }
                Component { id: playerAliasesPage; PlayerAliasesPage {} }

                pages: [
                    { name: "main", component: main },
                    { name: "notificationsPage", component: notificationsPage },
                    { name: "osdPage", component: osdPage },
                    { name: "playerAliasesPage", component: playerAliasesPage }
                ]
            }
        },
        Component {
            // Language & region
            StackPage {
                Component { id: main; LanguageAndRegion {} }

                pages: [
                    { name: "main", component: main }
                ]
            }
        },

        // About
        Component {
            StackPage {
                Component { id: main; AboutPage {} }

                pages: [
                    { name: "main", component: main }
                ]
            }
        }
    ]
    // qmlformat on

    readonly property Component placeholderComp: Component {
        PlaceholderComp {}
    }

    component PlaceholderComp: Item {
        property NexusState nState // To avoid the warning from non-existent property

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Tokens.padding.extraSmall

            MaterialIcon {
                Layout.alignment: Qt.AlignHCenter
                text: "handyman"
                color: Colours.palette.m3outlineVariant
                fontStyle: Tokens.font.icon.extraLarge
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Tr.tr("Page under construction")
                color: Colours.palette.m3outlineVariant
                font: Tokens.font.title.large
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Tr.tr("This page will be available in a future update.")
                color: Colours.palette.m3outlineVariant
                font: Tokens.font.body.large
            }
        }
    }
}
