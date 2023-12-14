cmake_minimum_required(VERSION 3.16)

project(sonegx-player-android VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
find_package(Qt6 6.4 REQUIRED COMPONENTS Core Quick Concurrent Widgets)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/QMpv/include)
# Link against the MPV library
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib)

qt_standard_project_setup()
qt_add_resources(QMLRC qml.qrc)
qt_add_resources(ICONSRC icons.qrc)


if(ANDROID)
    set(ADDITIONAL_SOURCE_FILES utils.cpp utils.h)

endif()

qt_add_executable(appsonegx-player-android
    main.cpp
    aes.h aes.cpp
    clipboardextension.h clipboardextension.cpp
    jsonfile.h jsonfile.cpp
    serialgenerator.h serialgenerator.cpp
    qaesencryption.cpp qaesencryption.h
    QMpv/qmpv.cpp
    QMpv/qmpv.h
    ${ADDITIONAL_SOURCE_FILES}
    ${QMLRC}
    ${ICONSRC}

)
set(APPLICATION_LIBS_BIN
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libMpvQt.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libmpv.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libswscale.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libswresample.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavutil.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavformat.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavfilter.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavdevice.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavcodec.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libpostproc.so
)
qt_add_qml_module(appsonegx-player-android
    URI sonegx-player-android
    VERSION 1.0
)

set_target_properties(appsonegx-player-android PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
    QT_ANDROID_EXTRA_LIBS "${APPLICATION_LIBS_BIN}"
)

target_link_libraries(appsonegx-player-android
    PRIVATE  Qt6::Quick Qt6::Core  Qt6::Concurrent Qt6::Widgets   ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libMpvQt.so
)

install(TARGETS appsonegx-player-android
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
