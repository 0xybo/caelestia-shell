pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services

StyledRect {
    id: root

    required property bool horizontal
    readonly property color colour: Colours.palette.m3tertiary
    readonly property int padding: Config.bar.clock.background ? Tokens.padding.medium : Tokens.padding.extraSmall
    readonly property var fontBuilder: Tokens.font.body.builders.small
    readonly property var font: fontBuilder.build()

    implicitWidth: horizontal ? layout.implicitWidth + root.padding * 2 : Tokens.sizes.bar.innerWidth
    implicitHeight: horizontal ? Tokens.sizes.bar.innerWidth : layout.implicitHeight + root.padding * 2

    color: Qt.alpha(Colours.tPalette.m3surfaceContainer, Config.bar.clock.background ? Colours.tPalette.m3surfaceContainer.a : 0)
    radius: Tokens.rounding.full

    GridLayout {
        id: layout

        anchors.centerIn: parent
        flow: root.horizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
        rowSpacing: Tokens.spacing.extraSmall
        columnSpacing: Tokens.spacing.extraSmall

        Loader {
            Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
            asynchronous: true
            active: Config.bar.clock.showIcon
            visible: active

            sourceComponent: MaterialIcon {
                text: "calendar_month"
                color: root.colour
            }
        }

        // Date
        Loader {
            Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
            asynchronous: true
            active: Config.bar.clock.showDate
            visible: active

            sourceComponent: GridLayout {
                flow: root.horizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
                rowSpacing: layout.rowSpacing - 4
                columnSpacing: layout.columnSpacing - 4

                // Day of the week
                StyledText {
                    Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
                    Layout.rightMargin: root.horizontal ? 4 : 0
                    text: Time.format("ddd")
                    font: root.horizontal ? root.font : root.fontBuilder.scale(0.9).build()
                    color: root.colour
                }

                Loader {
                    Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
                    sourceComponent: Units.twelveHourClock ? monthComponent : dayComponent
                }

                // Separator between day and month
                Loader {
                    Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
                    Layout.leftMargin: root.horizontal ? Tokens.padding.extraSmall / 2 : 0
                    Layout.rightMargin: root.horizontal ? Tokens.padding.extraSmall / 2 : 0
                    // Layout.bottomMargin: root.horizontal ? 2 : 0
                    asynchronous: true
                    active: root.horizontal
                    visible: active

                    sourceComponent: Text {
                        text: "/"
                        font: root.font
                        color: root.colour
                    }
                }

                Loader {
                    Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
                    sourceComponent: Units.twelveHourClock ? dayComponent : monthComponent
                }

                // Seperator between date and time
                StyledRect {
                    Layout.fillWidth: !root.horizontal
                    Layout.fillHeight: root.horizontal
                    Layout.leftMargin: root.horizontal ? Tokens.padding.extraSmall * 2 : -Tokens.padding.extraSmall
                    Layout.rightMargin: root.horizontal ? Tokens.padding.extraSmall * 2 : -Tokens.padding.extraSmall
                    Layout.topMargin: root.horizontal ? -Tokens.padding.extraSmall : 4
                    Layout.bottomMargin: root.horizontal ? -Tokens.padding.extraSmall : Tokens.padding.extraSmall / 2
                    implicitWidth: root.horizontal ? 1 : 0
                    implicitHeight: root.horizontal ? 0 : 1
                    color: Colours.palette.m3outlineVariant
                }

                // Day of the month
                Component {
                    id: dayComponent

                    StyledText {
                        text: Time.format("d")
                        font: root.font
                        color: root.colour
                    }
                }

                // Month
                Component {
                    id: monthComponent

                    StyledText {
                        text: Time.format("MM")
                        font: root.font
                        color: root.colour
                    }
                }
            }
        }

        GridLayout {
            flow: root.horizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
            Layout.preferredWidth: {
                if (!root.horizontal)
                    return -1;
                const charWidth = Math.round(charMetrics.width / charMetrics.text.length);

                let width = 0;

                if (Config.bar.clock.showSeconds)
                    // Hour (2) + ":" (1) + Minute (2) + ":" (1) + Second (2) = 8
                    width += charWidth * 8 + Tokens.padding.extraSmall * 4;
                else
                    // Hour (2) + ":" (1) + Minute (2) = 5
                    width += charWidth * 5 + Tokens.padding.extraSmall * 2;

                if (Units.twelveHourClock)
                    width += charWidth * 2 + Tokens.padding.extraSmall; // AM/PM (2)

                return width;
            }

            TextMetrics {
                id: charMetrics

                font: root.font
                text: "1234567890:"
            }

            GridLayout {
                flow: root.horizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

                // Hour
                StyledText {
                    Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
                    text: Time.hourStr
                    font: root.font
                    color: root.colour

                    TextMetrics {
                        id: hourMetrics

                        font: root.font
                        text: Time.hourStr
                    }
                }

                // Seperator between hour and minute
                Loader {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: root.horizontal ? -Tokens.padding.extraSmall / 2 : 0
                    Layout.rightMargin: root.horizontal ? -Tokens.padding.extraSmall / 2 : 0
                    Layout.bottomMargin: root.horizontal ? 2 : 0
                    asynchronous: true
                    active: root.horizontal
                    visible: active

                    sourceComponent: Text {
                        text: ":"
                        font: root.font
                        color: root.colour
                    }
                }

                // Minute
                StyledText {
                    Layout.topMargin: root.horizontal ? 0 : -parent.rowSpacing - 4
                    Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
                    text: Time.minuteStr
                    font: root.font
                    color: root.colour

                    TextMetrics {
                        id: minMetrics

                        font: root.font
                        text: Time.minuteStr
                    }
                }

                // Seperator between minute and second
                Loader {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: root.horizontal ? -Tokens.padding.extraSmall / 2 : 0
                    Layout.rightMargin: root.horizontal ? -Tokens.padding.extraSmall / 2 : 0
                    Layout.bottomMargin: root.horizontal ? 2 : 0
                    asynchronous: true
                    active: Config.bar.clock.showSeconds && root.horizontal
                    visible: active

                    sourceComponent: Text {
                        text: ":"
                        font: root.font
                        color: root.colour
                    }
                }

                // Second
                Loader {
                    Layout.topMargin: root.horizontal ? 0 : -parent.rowSpacing - 4
                    Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
                    asynchronous: true
                    active: Config.bar.clock.showSeconds
                    visible: active

                    sourceComponent: StyledText {
                        text: Time.format("ss")
                        font: root.font
                        color: root.colour
                    }
                }

                // AM/PM
                Loader {
                    Layout.topMargin: root.horizontal ? 0 : -parent.rowSpacing - 4
                    Layout.alignment: root.horizontal ? Qt.AlignVCenter : Qt.AlignHCenter
                    asynchronous: true
                    active: Units.twelveHourClock
                    visible: active

                    sourceComponent: StyledText {
                        text: Time.amPmStr.toLowerCase()
                        font: root.font
                        color: root.colour
                    }
                }
            }
        }
    }
}
