import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    color: colors.base
    radius: 12

    property string currentWallpaper: ""
    property var wallpapers: []
    property string wallpaperDir: ""

    MatugenColors { id: colors }

    // Get home directory and load wallpapers
    Process {
        id: homeReader
        command: ["bash", "-c", "echo $HOME"]
        stdout: StdioCollector {
            onStreamFinished: {
                let home = this.text.trim();
                root.wallpaperDir = home + "/Pictures/Wallpapers";
                wallpaperLoader.running = true;
            }
        }
    }

    Process {
        id: wallpaperLoader
        command: ["bash", "-c", "ls -1 \"" + root.wallpaperDir + "\" 2>/dev/null | grep -E '\\.(jpg|jpeg|png|webp)$' | head -20"]
        stdout: StdioCollector {
            onStreamFinished: {
                let files = this.text.trim().split("\n").filter(f => f.length > 0);
                root.wallpapers = files.map(f => root.wallpaperDir + "/" + f);
            }
        }
    }

    Process {
        id: currentWallpaperReader
        command: ["bash", "-c", "swww query 2>/dev/null | head -n1 | sed 's/.*image: //'"]
        stdout: StdioCollector {
            onStreamFinished: root.currentWallpaper = this.text.trim()
        }
    }

    Component.onCompleted: {
        homeReader.running = true;
        currentWallpaperReader.running = true;
    }

    function setWallpaper(path) {
        var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root);
        proc.command = ["swww", "img", path, "--transition-type", "fade", "--transition-duration", "1"];
        proc.running = true;
        root.currentWallpaper = path;

        // Update matugen colors
        var matugenProc = Qt.createQmlObject('import Quickshell.Io; Process {}', root);
        matugenProc.command = ["matugen", "image", path];
        matugenProc.running = true;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Wallpaper"
                color: colors.text
                font.pixelSize: 18
                font.family: "JetBrainsMono Nerd Font"
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "󰉋 Open Folder"
                onClicked: {
                    var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root);
                    proc.command = ["xdg-open", root.wallpaperDir];
                    proc.running = true;
                }
                contentItem: Text {
                    text: parent.text
                    color: colors.text
                    font.pixelSize: 12
                    font.family: "JetBrainsMono Nerd Font"
                }
                background: Rectangle {
                    color: parent.hovered ? colors.surface1 : colors.surface0
                    radius: 4
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: colors.surface1
        }

        // Current wallpaper preview
        Rectangle {
            Layout.fillWidth: true
            height: 150
            radius: 8
            color: colors.surface0
            clip: true

            Image {
                anchors.fill: parent
                source: root.currentWallpaper ? "file://" + root.currentWallpaper : ""
                fillMode: Image.PreserveAspectCrop
                visible: root.currentWallpaper.length > 0
            }

            Text {
                anchors.centerIn: parent
                text: "No wallpaper selected"
                color: colors.overlay0
                font.pixelSize: 14
                font.family: "JetBrainsMono Nerd Font"
                visible: root.currentWallpaper.length === 0
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30
                color: Qt.rgba(0, 0, 0, 0.6)

                Text {
                    anchors.centerIn: parent
                    text: root.currentWallpaper.split("/").pop() || "Current"
                    color: "white"
                    font.pixelSize: 11
                    font.family: "JetBrainsMono Nerd Font"
                    elide: Text.ElideMiddle
                    width: parent.width - 20
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Text {
            text: "Available Wallpapers (" + root.wallpapers.length + ")"
            color: colors.subtext0
            font.pixelSize: 12
            font.family: "JetBrainsMono Nerd Font"
        }

        // Wallpaper grid
        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 140
            cellHeight: 90
            clip: true
            model: root.wallpapers

            delegate: Rectangle {
                width: 132
                height: 82
                radius: 6
                color: colors.surface0
                border.color: modelData === root.currentWallpaper ? colors.blue : "transparent"
                border.width: 2
                clip: true

                Image {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: "file://" + modelData
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true

                    BusyIndicator {
                        anchors.centerIn: parent
                        running: parent.status === Image.Loading
                        width: 20
                        height: 20
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.setWallpaper(modelData)
                }
            }
        }

        // Info text
        Text {
            Layout.fillWidth: true
            text: "Place wallpapers in ~/Pictures/Wallpapers"
            color: colors.overlay0
            font.pixelSize: 10
            font.family: "JetBrainsMono Nerd Font"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
