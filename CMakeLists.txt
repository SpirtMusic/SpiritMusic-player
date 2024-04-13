cmake_minimum_required(VERSION 3.16)

project(sonegx-player VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
find_package(Qt6 6.4 REQUIRED COMPONENTS Core Quick Concurrent Widgets Sql )
if(ANDROID)
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/QMpv/include)
    # Link against the MPV library
    link_directories(${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib)
else()
    link_directories("/usr/local/lib")
    find_package(MpvQt REQUIRED)
endif()



qt_standard_project_setup()
qt_add_resources(QMLRC qml.qrc)
qt_add_resources(ICONSRC icons.qrc)


qt_add_executable(sonegx-player
    main.cpp
    #aes.h aes.cpp
    clipboardextension.h clipboardextension.cpp
    jsonfile.h jsonfile.cpp
    serialgenerator.h serialgenerator.cpp
    utilsunix.h utilsunix.cpp
    utilswin.h utilswin.cpp
    # qaesencryption.cpp qaesencryption.h
    QMpv/qmpv.cpp
    QMpv/qmpv.h

    ${QMLRC}
    ${ICONSRC}
)

if(ANDROID)
    target_sources(sonegx-player PRIVATE
        utilsandroid.cpp utilsandroid.h
        android/src/org/sonegx/sonegxplayer/MyUtils.java
        android/res/xml/qtprovider_paths.xml
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
qt_add_qml_module(sonegx-player
    URI sonegx-player
    VERSION 1.0

)

set(APPLICATION_LIBS_BIN
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libmpv.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libMpvQt.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libswscale.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libswresample.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libavutil.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libavformat.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libavfilter.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libavdevice.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libavcodec.so
    ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libpostproc.so
)
set(QT_ANDROID_PACKAGE_SOURCE
    ${CMAKE_CURRENT_SOURCE_DIR}/android/
)
set_target_properties(sonegx-player PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR "${QT_ANDROID_PACKAGE_SOURCE}"
    QT_ANDROID_EXTRA_LIBS "${APPLICATION_LIBS_BIN}"
    QT_ANDROID_VERSION_NAME "1.6"
)

target_link_libraries(sonegx-player
    PRIVATE  Qt6::Quick Qt6::Core  Qt6::Concurrent Qt6::Widgets  Qt6::Sql  ${CMAKE_CURRENT_SOURCE_DIR}/QMpv/lib/${ARCH}/libMpvQt.so
)
else()
    set_target_properties(sonegx-player PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
    )

target_link_libraries(sonegx-player
    PRIVATE Qt6::Quick Qt6::Core  Qt6::Concurrent Qt6::Widgets Qt6::Sql  MpvQt::MpvQt
)
endif()


install(TARGETS sonegx-player
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
