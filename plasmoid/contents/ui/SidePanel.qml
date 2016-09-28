import QtQuick 2.0
import QtQuick.Window 2.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents


/*
* Provides a side panel positioned at right of the screen
*/
PlasmaCore.Dialog {
    id: rootWindow

    location: PlasmaCore.Types.RightEdge
    flags: Qt.FramelessWindowHint
    hideOnWindowDeactivate: true

    x: Screen.desktopAvailableWidth - width
    // Uri: Changed the value to 1
    y: 1

    Component.onCompleted: {
        mainItem.width = Qt.binding(function () {
            return Screen.desktopAvailableHeight / 2
        })

        mainItem.height = Qt.binding(function () {
            return Screen.desktopAvailableHeight
        })
    }

    function display() {
        rootWindow.show()
        rootWindow.requestActivate()
    }
}
