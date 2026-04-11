import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    color: colors.base
    radius: 12

    property var monitors: []

    MatugenColors { id: colors }

    Process {
        id: monitorReader
        command: ["hyprctl", "monitors", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.monitors = JSON.parse(this.text.trim());
                } catch(e) {
                    root.monitors = [];
                }
            }
        }
    }

    Component.onCompleted: monitorReader.running = true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        Text {
            text: "Monitors"
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

        // Monitor list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.monitors
            spacing: 8
            clip: true

            delegate: Rectangle {
                width: ListView.view.width
                height: 80
                radius: 8
                color: colors.surface0

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    // Monitor icon
                    Text {
                        text: "󰍹"
                        color: colors.blue
                        font.pixelSize: 32
                        font.family: "JetBrainsMono Nerd Font"
                    }

                    Column {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: modelData.name || "Monitor"
                            color: colors.text
                            font.pixelSize: 14
                            font.family: "JetBrainsMono Nerd Font"
                            font.bold: true
                        }

                        Text {
                            text: (modelData.width || 0) + "x" + (modelData.height || 0) +
                                  " @ " + (modelData.refreshRate || 60) + "Hz"
                            color: colors.subtext0
                            font.pixelSize: 12
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        Text {
                            text: "Scale: " + (modelData.scale || 1) + "x"
                            color: colors.overlay0
                            font.pixelSize: 10
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }

                    // Active indicator
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: modelData.focused ? colors.green : colors.surface1
                    }
                }
            }
        }

        // Refresh button
        Button {
            Layout.fillWidth: true
            text: "Refresh"
            onClicked: monitorReader.running = true
            contentItem: Text {
                text: parent.text
                color: colors.text
                font.pixelSize: 12
                font.family: "JetBrainsMono Nerd Font"
                horizontalAlignment: Text.AlignHCenter
            }
            background: Rectangle {
                color: parent.hovered ? colors.surface1 : colors.surface0
                radius: 4
            }
        }
    }
}
