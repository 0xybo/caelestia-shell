import Quickshell

PersistentProperties {
    required property ShellScreen modelData

    // Drawer visibilities
    property bool bar
    property bool barTemporary

    property bool osd
    property bool osdTemporary

    property bool session
    property bool sessionTemporary

    property bool launcher
    property bool launcherTemporary

    property bool dashboard
    property bool dashboardTemporary

    property bool utilities
    property bool utilitiesTemporary

    property bool sidebar
    property bool sidebarTemporary

    readonly property bool sidebarOrSession: sidebar || sidebarTemporary || session || sessionTemporary

    // Dashboard state
    property int dashboardTab
    property date dashboardDate: new Date()
}
