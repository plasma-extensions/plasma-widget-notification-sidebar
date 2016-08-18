set(notificationsapplet_SRCS
    notificationsapplet.cpp
)

add_library(plasma_light_applet_notifications MODULE ${notificationsapplet_SRCS})

kcoreaddons_desktop_to_json(plasma_light_applet_notifications ../plasmoid/metadata.desktop)

target_link_libraries(plasma_light_applet_notifications 
                      KF5::WindowSystem
                      KF5::Plasma
                      KF5::ConfigCore)

install(TARGETS plasma_light_applet_notifications DESTINATION ${PLUGIN_INSTALL_DIR})
