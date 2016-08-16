/***************************************************************************
 *   Copyright 2011 Davide Bettio <davide.bettio@kdemail.net>              *
 *   Copyright 2011 Marco Martin <mart@kde.org>                            *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU Library General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.plasma.private.notifications 1.0

import "../code/uiproperties.js" as UiProperties

MouseEventListener {
    id: notificationsApplet
    //width: units.gridUnit.width * 10
    //height: units.gridUnit.width * 15

    //Layout.minimumWidth: mainScrollArea.implicitWidth
    //Layout.minimumHeight: mainScrollArea.implicitHeight
    Layout.minimumWidth: 256 // FIXME: use above
    Layout.minimumHeight: 256
    Layout.maximumWidth: -1
    Layout.maximumHeight: mainScrollArea.implicitHeight

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int toolIconSize: UiProperties.toolIconSize
    property int layoutSpacing: UiProperties.layoutSpacing

    property real globalProgress: 0

    property Item notifications: notificationsLoader.item
    property Item jobs: jobsLoader.item

    //notifications + jobs
    property int totalCount: (notifications ? notifications.count : 0) + (jobs ? jobs.count : 0)

    // property Item notificationIcon

    Plasmoid.switchWidth: units.gridUnit * 20
    Plasmoid.switchHeight: units.gridUnit * 30
    Plasmoid.icon: {
        if (jobs && jobs.count) {
            return "notification-active"
        }
        return totalCount ? "notification-inactive" : "notification-disabled"
    }

    Plasmoid.compactRepresentation: Component {
        NotificationIcon {
            id: notificationIcon
        }
    }

    state: "default"
    hoverEnabled: !UiProperties.touchInput

    onTotalCountChanged: {
        print(" totalCountChanged " + totalCount)
        if (totalCount > 0) {
            state = "new-notifications"
        } else {
            state = "default"
            //plasmoid.hidePopup()
            plasmoid.expanded = false;
        }

        var data = new Object
        data["image"] = "preferences-desktop-notification"
        data["mainText"] = i18n("Notifications and Jobs")

        if (totalCount == 0) {
            data["subText"] = i18n("No notifications or jobs")
        } else if (!notifications.count) {
            data["subText"] = i18np("%1 running job", "%1 running jobs", jobs.count)
        } else if (!jobs.count) {
            data["subText"] = i18np("%1 notification", "%1 notifications", notifications.count)
        } else  {
            data["subText"] = i18np("%1 running job", "%1 running jobs", jobs.count) + "<br/>" + i18np("%1 notification", "%1 notifications", notifications.count)
        }
        //plasmoid.popupIconToolTip = data
        //plasmoid.passivePopup = jobs.count != 0

        if (totalCount > 0) {
            plasmoid.status = PlasmaCore.Types.ActiveStatus;
        } else {
            plasmoid.status = PlasmaCore.Types.PassiveStatus;
        }
    }

    SidePanel {
        id: sidePanel
        Item {
            PlasmaCore.Svg {
                id: configIconsSvg
                imagePath: "widgets/configuration-icons"
            }

            PlasmaExtras.Heading {
                width: parent.width
                level: 3
                opacity: 0.6
                visible: notificationsApplet.totalCount == 0
                text: i18n("No new notifications.")
            }

            PlasmaExtras.ScrollArea {
                id: mainScrollArea
                anchors.fill: parent

                implicitWidth: theme.mSize(theme.defaultFont).width * 40
                implicitHeight: Math.min(theme.mSize(theme.defaultFont).height * 40, Math.max(theme.mSize(theme.defaultFont).height * 6, contentsColumn.height))
                state: ""

                Flickable {
                    id: popupFlickable
                    anchors.fill:parent

                    contentWidth: width
                    contentHeight: contentsColumn.height
                    clip: true

                    Column {
                        id: contentsColumn
                        width: popupFlickable.width

                        Loader {
                            id: jobsLoader
                            width: parent.width
                            source: "Jobs.qml"
                            active: notificationsApplet.Plasmoid.configuration.showJobs
                        }

                        Loader {
                            id: notificationsLoader
                            width: parent.width
                            source: "Notifications.qml"
                            active: notificationsApplet.Plasmoid.configuration.showNotifications
                        }
                    }
                }

                states: [
                    State {
                        name: "underMouse"
                        when: notificationsApplet.containsMouse
                        PropertyChanges {
                            target: mainScrollArea
                            implicitHeight: implicitHeight
                        }
                    },
                    State {
                        name: ""
                        when: !notificationsApplet.containsMouse
                        PropertyChanges {
                            target: mainScrollArea
                            implicitHeight: Math.min(theme.mSize(theme.defaultFont).height * 40, Math.max(theme.mSize(theme.defaultFont).height * 6, contentsColumn.height))
                        }
                    }
                ]
            }

            Rectangle {
                anchors {
                    right: parent.right
                    left: parent.left
                    bottom: parent.bottom
                }
                height: 50
                color: "transparent"
                // opacity: 0.6

                visible: notificationsApplet.totalCount > 0

                PlasmaComponents.Button {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 12
                    }

                    text: i18n("Clear all")
                }
            }

        }
    }


    function action_notificationskcm() {
        ProcessRunner.runNotificationsKCM()
    }

    Component.onCompleted: {
        //plasmoid.popupIcon = QIcon("preferences-desktop-notification")
        plasmoid.status = PlasmaCore.Types.PassiveStatus
        //var allApplications = new Object
        plasmoid.setAction("notificationskcm", i18n("&Configure Event Notifications and Actions..."), "preferences-desktop-notification")
    }
}
