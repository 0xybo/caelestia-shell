import Quickshell
import Caelestia.Config

PersistentProperties {
    required property ShellScreen modelData

    // Drawer visibilities
    property bool bar
    property bool osd
    property bool session
    property bool launcher
    property bool dashboard
    property bool utilities

    property bool sidebar
    property bool sidebarTemporary
    property bool sidebarBeforeTemporary

    readonly property bool sidebarOrSession: sidebar || sidebarTemporary || session

    onSidebarOrSessionChanged: {
        if (sidebarOrSession) {
            dashboard = false;
            osd = false;
        }
    }

    onDashboardChanged: {
        if (dashboard && sidebarOrSession)
            dashboard = false;
    }

    onUtilitiesChanged: {
        if (utilities && GlobalConfig.utilities.alwaysShowNotifications) {
            if (!sidebarTemporary) {
                sidebarBeforeTemporary = sidebar;
                sidebarTemporary = true;
                sidebar = true;
            }
        } else if (!utilities && sidebarTemporary) {
            sidebarTemporary = false;
            sidebar = sidebarBeforeTemporary;
        }
    }

    // Dashboard state
    property int dashboardTab
    property date dashboardDate: new Date()
}
