import QtQuick
import Quickshell
import Caelestia.Config
import qs.services
import qs.modules.drawers

PersistentProperties {
    required property ShellScreen modelData

    readonly property var config: GlobalConfig.forScreen(modelData.name)
    readonly property EdgeGeometry geometry: ShellState.geometryFor(modelData)

    // Drawer visibilities
    property bool bar
    property bool barTemporary
    readonly property bool shouldBarVisible: bar || barTemporary

    property bool osd
    property bool osdTemporary
    readonly property bool shouldOsdVisible: config.osd.enabled && (osd || osdTemporary) && !(config.utilities.enabled && utilities && !config.utilities.alsoShowSidebar)

    property bool session
    property bool sessionTemporary
    readonly property bool shouldSessionVisible: config.session.enabled && (session || sessionTemporary)

    property bool launcher
    property bool launcherTemporary
    readonly property bool shouldLauncherVisible: config.launcher.enabled && (launcher || launcherTemporary)

    property bool dashboard
    property bool dashboardTemporary
    readonly property bool shouldDashboardVisible: config.dashboard.enabled && (dashboard || dashboardTemporary)

    property bool utilities
    property bool utilitiesTemporary
    readonly property bool shouldUtilitiesVisible: config.utilities.enabled && (utilities || (utilitiesTemporary && (!(config.session.enabled && session) || config.utilities.alsoShowSidebar)))

    property bool sidebar
    property bool sidebarTemporary
    readonly property bool shouldSidebarVisible: config.sidebar.enabled && (sidebar || sidebarTemporary)

    // Dashboard state
    property int dashboardTab
    property date dashboardDate: new Date()

    // Notifications state
    readonly property bool shouldNotificationsVisible: Notifs.shouldShowPopup() && !shouldDashboardVisible && !(shouldSessionVisible && geometry?.session.besideSidebar) && !shouldSidebarVisible && !(shouldOsdVisible && geometry?.osd.besideSidebar) && !(shouldUtilitiesVisible && geometry?.sidebar.alongUtilities)

    // Toasts state
    readonly property bool shouldToastsVisible: !shouldDashboardVisible && !(shouldSessionVisible && geometry?.session.besideSidebar) && !(shouldOsdVisible && geometry?.osd.besideSidebar)
}
