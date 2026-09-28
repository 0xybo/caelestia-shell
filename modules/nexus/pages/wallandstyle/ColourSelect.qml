import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Colours")
    isSubPage: true

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: {
            const f = parent.parent as Flickable;
            return f.height - f.topMargin - f.bottomMargin;
        }

        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: root.cappedWidth
            spacing: Tokens.spacing.extraSmall / 2

            // Scheme
            SectionHeader {
                first: true
                text: Tr.tr("Scheme")
            }

            ToggleRow {
                first: true
                last: true
                text: Tr.tr("Smart colour scheme")
                subtext: Tr.tr("Derive theme mode and variant from the wallpaper")
                checked: GlobalConfig.services.smartScheme
                onToggled: GlobalConfig.services.smartScheme = checked
            }
        }
    }
}
