import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    id: win
    signal dismissed()
    property string query: ""
    readonly property var matches: {
        const q = query.trim().toLowerCase();
        const apps = DesktopEntries.applications.values.filter(app => !app.noDisplay);
        return (q.length === 0 ? apps : apps.filter(app => app.name.toLowerCase().includes(q)))
            .sort((a, b) => a.name.localeCompare(b.name)).slice(0, 8);
    }

    anchors { top: true }
    implicitWidth: 540
    implicitHeight: 400
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    function launch(app) {
        if (!app) return;
        Quickshell.execDetached({
            command: ["uwsm", "app", "--"].concat(app.command),
            workingDirectory: app.workingDirectory
        });
        dismissed();
    }

    HyprlandFocusGrab {
        windows: [win]
        active: true
        onCleared: win.dismissed()
    }

    Rectangle {
        anchors.fill: parent
        color: "#1d2332"
        border.color: "#414b62"
        border.width: 1
        radius: 16

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            Rectangle {
                width: parent.width
                height: 44
                color: "#111827"
                radius: 10
                TextInput {
                    id: search
                    anchors.fill: parent
                    anchors.margins: 12
                    color: "#c0caf5"
                    font.pixelSize: 16
                    focus: true
                    onTextChanged: win.query = text
                    Keys.onEscapePressed: win.dismissed()
                    Keys.onReturnPressed: win.launch(win.matches[0])
                    Keys.onEnterPressed: win.launch(win.matches[0])
                }
            }

            Repeater {
                model: win.matches
                Rectangle {
                    id: appRow
                    required property var modelData
                    width: parent.width
                    height: 34
                    radius: 7
                    color: appHover.containsMouse ? "#354565" : "transparent"
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#c0caf5"
                        font.pixelSize: 13
                        text: appRow.modelData.name
                    }
                    MouseArea {
                        id: appHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: win.launch(appRow.modelData)
                    }
                }
            }
        }
    }

    Component.onCompleted: search.forceActiveFocus()
}
