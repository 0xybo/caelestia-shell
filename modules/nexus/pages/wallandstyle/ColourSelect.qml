import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.controls
import qs.modules.nexus.common
import qs.modules.launcher.services

PageBase {
    id: root

    title: Tr.tr("Colours")
    isSubPage: true

    Component.onCompleted: Schemes.reload()

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

            SelectRow {
                first: true
                label: Tr.tr("Colour scheme")
                subtext: Tr.tr("The base palette used across the shell")
                active: menuItems.find(i => i.modelData === Schemes.currentName)
                menuItems: nameItems.instances
                onSelected: item => Schemes.set(item.modelData, "")

                Variants {
                    id: nameItems

                    model: Schemes.names()

                    MenuItem {
                        required property string modelData

                        text: modelData
                        icon: modelData === "dynamic" ? "palette" : ""
                    }
                }
            }

            SelectRow {
                label: Tr.tr("Flavour")
                subtext: Tr.tr("The colour variant of the selected scheme")
                disabled: !Schemes.loaded
                active: menuItems.find(i => i.modelData === Schemes.currentFlavour)
                menuItems: flavourItems.instances
                onSelected: item => Schemes.set(Schemes.currentName, item.modelData)

                Variants {
                    id: flavourItems

                    model: Schemes.flavoursFor(Schemes.currentName)

                    MenuItem {
                        required property string modelData

                        text: modelData
                    }
                }
            }

            SelectRow {
                last: true
                label: Tr.tr("M3 variant")
                subtext: Tr.tr("How the Material You palette is generated")
                active: menuItems.find(i => i.modelData?.variant === Schemes.currentVariant)
                menuItems: variantItems.instances
                onSelected: item => Schemes.setVariant(item.modelData.variant)

                Variants {
                    id: variantItems

                    model: M3Variants.list

                    MenuItem {
                        required property var modelData

                        text: modelData.name
                        icon: modelData.icon
                    }
                }
            }

            // Behaviour
            SectionHeader {
                text: Tr.tr("Behaviour")
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
