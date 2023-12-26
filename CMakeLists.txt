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
    android/src/org/sonegx/sonegxplayer/MyUtils.java
    ${ADDITIONAL_SOURCE_FILES}
    ${QMLRC}
    ${ICONSRC}

)
# Determine the architecture-specific suffix
if(DEFINED ANDROID_ABI)
    message("Detected Android ABI: ${ANDROID_ABI}")

    # Set ARCH variable based on the detected ANDROID_ABI
    if(${ANDROID_ABI} STREQUAL "armeabi-v7a")
        set(ARCH "armeabi_v7a")
    elseif(${ANDROID_ABI} STREQUAL "arm64-v8a")
        set(ARCH "arm64_v8a")
    else()
        message(FATAL_ERROR "Unsupported Android ABI: ${ANDROID_ABI}")
    endif()
else()
    message(FATAL_ERROR "ANDROID_ABI not defined. Make sure you are using the Qt CMake toolchain for Android.")
endif()
set(APPLICATION_LIBS_BIN
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libMpvQt_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libmpv_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libswscale_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libswresample_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavutil_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavformat_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavfilter_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavdevice_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libavcodec_${ARCH}.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libpostproc_${ARCH}.so
)
set(QT_ANDROID_PACKAGE_SOURCE
${CMAKE_CURRENT_SOURCE_DIR}/android/
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
    QT_ANDROID_PACKAGE_SOURCE_DIR "${QT_ANDROID_PACKAGE_SOURCE}"
    QT_ANDROID_EXTRA_LIBS "${APPLICATION_LIBS_BIN}"
)

target_link_libraries(appsonegx-player-android
    PRIVATE  Qt6::Quick Qt6::Core  Qt6::Concurrent Qt6::Widgets   ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/libMpvQt_${ARCH}.so
)

install(TARGETS appsonegx-player-android
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
