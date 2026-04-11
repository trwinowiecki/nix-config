import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    color: colors.base
    radius: 12

    MatugenColors { id: colors }

    property var shortcuts: [
        { category: "General", items: [
            { key: "Super + Return", desc: "Open terminal" },
            { key: "Super + D", desc: "App launcher" },
            { key: "Super + E", desc: "File manager" },
            { key: "Super + L", desc: "Lock screen" },
            { key: "Alt + F4", desc: "Close window" }
        ]},
        { category: "Widgets", items: [
            { key: "Super + S", desc: "Calendar" },
            { key: "Super + V", desc: "Volume" },
            { key: "Super + B", desc: "Battery" },
            { key: "Super + N", desc: "Network" },
            { key: "Super + Q", desc: "Music" },
            { key: "Super + W", desc: "Wallpaper" },
            { key: "Super + M", desc: "Monitors" },
            { key: "Super + H", desc: "This guide" }
        ]},
        { category: "Windows", items: [
            { key: "Super + Arrow", desc: "Move focus" },
            { key: "Super + Ctrl + Arrow", desc: "Move window" },
            { key: "Super + Shift + Arrow", desc: "Resize window" },
            { key: "Super + Shift + F", desc: "Toggle floating" }
        ]},
        { category: "Workspaces", items: [
            { key: "Super + 1-0", desc: "Switch workspace" },
            { key: "Super + Shift + 1-0", desc: "Move to workspace" }
        ]},
        { category: "Media", items: [
            { key: "Super + Space", desc: "Play/Pause" },
            { key: "Print", desc: "Screenshot area" },
            { key: "Shift + Print", desc: "Screenshot screen" }
        ]}
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        Text {
            text: "Keyboard Shortcuts"
            color: colors.text
            font.pixelSize: 18
            font.family: "JetBrainsMono Nerd Font"
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: colors.surface1
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Column {
                width: parent.width
                spacing: 16

                Repeater {
                    model: root.shortcuts

                    Column {
                        width: parent.width
                        spacing: 8

                        Text {
                            text: modelData.category
                            color: colors.blue
                            font.pixelSize: 14
                            font.family: "JetBrainsMono Nerd Font"
                            font.bold: true
                        }

                        Repeater {
                            model: modelData.items

                            Rectangle {
                                width: parent.width
                                height: 32
                                radius: 4
                                color: colors.surface0

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12

                                    Text {
                                        text: modelData.key
                                        color: colors.peach
                                        font.pixelSize: 12
                                        font.family: "JetBrainsMono Nerd Font"
                                        Layout.preferredWidth: 180
                                    }

                                    Text {
                                        text: modelData.desc
                                        color: colors.text
                                        font.pixelSize: 12
                                        font.family: "JetBrainsMono Nerd Font"
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
