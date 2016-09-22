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
            // Uri: I've changed the value to 6 because with the value at 3.8 the sidepanel is too wide on my ultrawide screen. I've tested it // on 16:9 and 21:9 resolutions and it looks good enough. Only in low 4:3 resolutions like 1024x768 and 800x600 it's going to look // too crammed.
            return Screen.desktopAvailableWidth / 3.8
        })

        mainItem.height = Qt.binding(function () {
            // TODO: find a way to resolve the inner dialog maring and remove the "- 12"
            // Uri: I've changed the value to / 1.03 it seems to me this value keeps the sidepanel from covering the Plasma panel even at resolutions
            // as low as 800x600
            return Screen.desktopAvailableHeight / 1.03
        })
    }

    function display() {
        rootWindow.show()
        rootWindow.requestActivate()
    }
}
