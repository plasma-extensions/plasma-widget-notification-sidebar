import QtQuick 2.0
import QtQuick.Window 2.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents


/*
* Provides a side panel positioned at right of the screen
*/
PlasmaCore.Dialog {
    id: rootWindow

    location: PlasmaCore.Types.Floating
    flags: Qt.Popup
    hideOnWindowDeactivate: true

    x: Screen.desktopAvailableWidth - width
    y: 0

    Component.onCompleted: {
        mainItem.width = Qt.binding(function () {
            return Screen.desktopAvailableWidth / 3.8
        })

        mainItem.height = Qt.binding(function () {
            // TODO: find a way to resolve the inner dialog maring and remove the "- 12"
            return Screen.desktopAvailableHeight - 12
        })
    }

    function display() {
        rootWindow.show()
        rootWindow.requestActivate()
    }
}
