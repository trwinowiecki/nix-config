import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    color: colors.base
    radius: 12

    property int focusMinutes: 25
    property int breakMinutes: 5
    property int remainingSeconds: 0
    property bool isRunning: false
    property bool isBreak: false

    MatugenColors { id: colors }

    Timer {
        id: focusTimer
        interval: 1000
        running: root.isRunning
        repeat: true
        onTriggered: {
            if (root.remainingSeconds > 0) {
                root.remainingSeconds--;
            } else {
                root.isRunning = false;
                // Notify
                var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root);
                proc.command = ["notify-send", "Focus Timer",
                    root.isBreak ? "Break time is over!" : "Focus session complete!"];
                proc.running = true;
            }
        }
    }

    function formatTime(seconds) {
        var mins = Math.floor(seconds / 60);
        var secs = seconds % 60;
        return (mins < 10 ? "0" : "") + mins + ":" + (secs < 10 ? "0" : "") + secs;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        Text {
            text: "Focus Timer"
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

        // Timer display
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 180
            height: 180
            radius: 90
            color: colors.surface0
            border.color: root.isRunning ? (root.isBreak ? colors.green : colors.blue) : colors.surface1
            border.width: 4

            Column {
                anchors.centerIn: parent
                spacing: 4

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.isBreak ? "󰒲" : "󰔟"
                    color: root.isBreak ? colors.green : colors.blue
                    font.pixelSize: 32
                    font.family: "JetBrainsMono Nerd Font"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: formatTime(root.remainingSeconds > 0 ? root.remainingSeconds : root.focusMinutes * 60)
                    color: colors.text
                    font.pixelSize: 36
                    font.family: "JetBrainsMono Nerd Font"
                    font.bold: true
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.isBreak ? "Break" : "Focus"
                    color: colors.subtext0
                    font.pixelSize: 12
                    font.family: "JetBrainsMono Nerd Font"
                }
            }
        }

        // Duration controls
        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            visible: !root.isRunning

            Column {
                spacing: 4

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Focus"
                    color: colors.subtext0
                    font.pixelSize: 10
                    font.family: "JetBrainsMono Nerd Font"
                }

                Row {
                    spacing: 8

                    Button {
                        width: 24
                        height: 24
                        text: "-"
                        onClicked: if (root.focusMinutes > 5) root.focusMinutes -= 5
                        contentItem: Text {
                            text: parent.text
                            color: colors.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.hovered ? colors.surface1 : colors.surface0
                            radius: 4
                        }
                    }

                    Text {
                        text: root.focusMinutes + "m"
                        color: colors.text
                        font.pixelSize: 14
                        font.family: "JetBrainsMono Nerd Font"
                        width: 40
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Button {
                        width: 24
                        height: 24
                        text: "+"
                        onClicked: if (root.focusMinutes < 60) root.focusMinutes += 5
                        contentItem: Text {
                            text: parent.text
                            color: colors.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.hovered ? colors.surface1 : colors.surface0
                            radius: 4
                        }
                    }
                }
            }

            Column {
                spacing: 4

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Break"
                    color: colors.subtext0
                    font.pixelSize: 10
                    font.family: "JetBrainsMono Nerd Font"
                }

                Row {
                    spacing: 8

                    Button {
                        width: 24
                        height: 24
                        text: "-"
                        onClicked: if (root.breakMinutes > 1) root.breakMinutes -= 1
                        contentItem: Text {
                            text: parent.text
                            color: colors.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.hovered ? colors.surface1 : colors.surface0
                            radius: 4
                        }
                    }

                    Text {
                        text: root.breakMinutes + "m"
                        color: colors.text
                        font.pixelSize: 14
                        font.family: "JetBrainsMono Nerd Font"
                        width: 40
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Button {
                        width: 24
                        height: 24
                        text: "+"
                        onClicked: if (root.breakMinutes < 30) root.breakMinutes += 1
                        contentItem: Text {
                            text: parent.text
                            color: colors.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.hovered ? colors.surface1 : colors.surface0
                            radius: 4
                        }
                    }
                }
            }
        }

        // Controls
        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            Button {
                width: 100
                height: 40
                text: root.isRunning ? "Pause" : "Start"
                onClicked: {
                    if (!root.isRunning && root.remainingSeconds === 0) {
                        root.remainingSeconds = root.focusMinutes * 60;
                        root.isBreak = false;
                    }
                    root.isRunning = !root.isRunning;
                }
                contentItem: Text {
                    text: parent.text
                    color: colors.crust
                    font.pixelSize: 14
                    font.family: "JetBrainsMono Nerd Font"
                    horizontalAlignment: Text.AlignHCenter
                }
                background: Rectangle {
                    color: parent.hovered ? colors.sapphire : colors.blue
                    radius: 8
                }
            }

            Button {
                width: 100
                height: 40
                text: "Reset"
                visible: root.isRunning || root.remainingSeconds > 0
                onClicked: {
                    root.isRunning = false;
                    root.remainingSeconds = 0;
                    root.isBreak = false;
                }
                contentItem: Text {
                    text: parent.text
                    color: colors.text
                    font.pixelSize: 14
                    font.family: "JetBrainsMono Nerd Font"
                    horizontalAlignment: Text.AlignHCenter
                }
                background: Rectangle {
                    color: parent.hovered ? colors.surface1 : colors.surface0
                    radius: 8
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
