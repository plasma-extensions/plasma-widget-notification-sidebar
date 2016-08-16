import QtQuick 2.0

Rectangle {
    property var target: parent

    anchors.fill: target

    border.color: target.activeFocus ? "green" : "red";
    border.width: 4
    color: "transparent"

    Text {
        anchors.centerIn: parent
        text: target.activeFocus ? "focused" : "not focused"
        color: "black"
    }
}
