//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    // A simple multi-monitor QuickShell panel, kept separate from Hyprland's WM config.
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData
            anchors { top: true; left: true; right: true }
            implicitHeight: 42
            color: "#111827"

            Rectangle {
                anchors.fill: parent
                color: "#111827"

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 18
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12

                    Text {
                        text: "ADE"
                        color: "#7aa2f7"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Repeater {
                        model: 5
                        Rectangle {
                            id: workspaceButton
                            required property int index
                            readonly property bool isActive: Hyprland.monitorFor(panel.modelData)?.activeWorkspace?.id === index + 1
                            width: 28
                            height: 26
                            radius: 8
                            color: isActive ? "#354565" : "#1d2738"
                            Text {
                                anchors.centerIn: parent
                                text: workspaceButton.index + 1
                                color: workspaceButton.isActive ? "#c0caf5" : "#9ca3af"
                                font.pixelSize: 12
                                font.bold: workspaceButton.isActive
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch("workspace " + (workspaceButton.index + 1))
                            }
                        }
                    }
                }

                SystemClock { id: clock; precision: SystemClock.Minutes }
                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatDateTime(clock.date, "ddd dd MMM  HH:mm")
                    color: "#c0caf5"
                    font.pixelSize: 13
                }
            }
        }
    }

    LazyLoader {
        id: launcherLoader
        Launcher { onDismissed: launcherLoader.active = false }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void { launcherLoader.active = !launcherLoader.active; }
    }
}
