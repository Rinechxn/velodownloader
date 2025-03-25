cmake_minimum_required(VERSION 3.16)
project(framelesswidget LANGUAGES CXX)

# Add Qt directory from QTDIR environment variable
if(DEFINED ENV{QTDIR})
    set(CMAKE_PREFIX_PATH $ENV{QTDIR})
else()
    message(WARNING "QTDIR environment variable is not set")
endif()

# Set C++ standard to C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure build types
set(CMAKE_CONFIGURATION_TYPES Debug Release RelWithDebInfo MinSizeRel)
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build" FORCE)
endif()

# Set compiler flags for Debug and Release
if(MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG "/Zi /Ob0 /Od /RTC1 /MTd /D_DEBUG")
    set(CMAKE_CXX_FLAGS_RELEASE "/O2 /Ob2 /DNDEBUG /MT")
    set(CMAKE_EXE_LINKER_FLAGS_DEBUG "/DEBUG /INCREMENTAL")
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "/INCREMENTAL:NO")
else()
    set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -fno-inline")
    set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
endif()

# Disable manifest generation by CMake
if(MSVC)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /MANIFEST:NO")
endif()

# Enable automoc for Qt
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt6 packages
find_package(Qt6 REQUIRED COMPONENTS 
    Core
    Gui
    Widgets
    Quick
    QuickControls2
    Sql
    Qml
    Network
)

get_target_property(Qt6_PREFIX Qt6::Core INTERFACE_INCLUDE_DIRECTORIES)
string(REGEX REPLACE "(.*)/include.*" "\\1" Qt6_PREFIX "${Qt6_PREFIX}")

# Source files
file(GLOB_RECURSE SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp")
file(GLOB_RECURSE RESOURCES "${CMAKE_CURRENT_SOURCE_DIR}/resources/*.qrc")

# Define the executable
add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${HEADERS}
    ${RESOURCES}
)

# Set debug postfix
set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")

# Configure PDB files for MSVC
if(MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES 
        COMPILE_PDB_NAME ${PROJECT_NAME}
        COMPILE_PDB_NAME_DEBUG "${PROJECT_NAME}d"
    )
endif()

# Link Qt libraries
target_link_libraries(${PROJECT_NAME} PRIVATE 
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql
    Qt6::Qml
    Qt6::Network
)

# Add definitions
target_compile_definitions(${PROJECT_NAME} PRIVATE
    QT_NO_CAST_FROM_ASCII
    QT_NO_CAST_TO_ASCII
    QT_USE_PRIVATE_HEADERS
    $<$<CONFIG:Debug>:QT_QML_DEBUG>
    $<$<CONFIG:Debug>:_DEBUG>
    $<$<CONFIG:Release>:QT_NO_DEBUG>
    $<$<CONFIG:Release>:NDEBUG>
)

# Add include directories
target_include_directories(${PROJECT_NAME} PRIVATE
    ${Qt6_PREFIX}/include
    ${Qt6_PREFIX}/include/QtCore
    ${Qt6_PREFIX}/include/QtGui
    ${Qt6_PREFIX}/include/QtWidgets
    ${Qt6_PREFIX}/include/QtQuick
    ${Qt6_PREFIX}/include/QtQuickControls2
    ${Qt6_PREFIX}/include/QtSql
    ${Qt6_PREFIX}/include/QtQml
    ${Qt6_PREFIX}/include/QtNetwork
    ${Qt6_PREFIX}/include/QtCore/${Qt6Core_VERSION}
    ${Qt6_PREFIX}/include/QtCore/${Qt6Core_VERSION}/QtCore
    ${Qt6_PREFIX}/include/QtGui/${Qt6Gui_VERSION}
    ${Qt6_PREFIX}/include/QtGui/${Qt6Gui_VERSION}/QtGui
    ${Qt6_PREFIX}/include/QtWidgets/${Qt6Widgets_VERSION}
    ${Qt6_PREFIX}/include/QtWidgets/${Qt6Widgets_VERSION}/QtWidgets
    ${Qt6_PREFIX}/include/QtQuick/${Qt6Quick_VERSION}
    ${Qt6_PREFIX}/include/QtQuick/${Qt6Quick_VERSION}/QtQuick
    ${Qt6_PREFIX}/include/QtQuickControls2/${Qt6QuickControls2_VERSION}
    ${Qt6_PREFIX}/include/QtQuickControls2/${Qt6QuickControls2_VERSION}/QtQuickControls2
    ${Qt6_PREFIX}/include/QtSql/${Qt6Sql_VERSION}
    ${Qt6_PREFIX}/include/QtSql/${Qt6Sql_VERSION}/QtSql
    ${Qt6_PREFIX}/include/QtQml/${Qt6Qml_VERSION}
    ${Qt6_PREFIX}/include/QtQml/${Qt6Qml_VERSION}/QtQml
    ${Qt6_PREFIX}/include/QtNetwork/${Qt6Network_VERSION}
    ${Qt6_PREFIX}/include/QtNetwork/${Qt6Network_VERSION}/QtNetwork
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gui
    ${CMAKE_CURRENT_SOURCE_DIR}/src/utils
    ${CMAKE_CURRENT_SOURCE_DIR}/src/database
)

# Set Windows-specific properties
if(WIN32)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        WIN32_EXECUTABLE TRUE
        VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        VS_DEBUGGER_COMMAND_ARGUMENTS ""
        VS_DEBUGGER_ENVIRONMENT "PATH=${Qt6_PREFIX}/bin;%PATH%"
    )
        # Windows version definitions
    target_compile_definitions(${PROJECT_NAME} PRIVATE
        WINVER=0x0601
        _WIN32_WINNT=0x0601
        _CRT_SECURE_NO_WARNINGS
    )

    # Set application icon
    set(APP_ICON_RESOURCE_WINDOWS "${CMAKE_CURRENT_SOURCE_DIR}/resources/icons/app2.ico")
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/resource.rc"
        "IDI_ICON1 ICON \"${APP_ICON_RESOURCE_WINDOWS}\"")
    target_sources(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/resource.rc")
endif()

# Install rules
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# Install debug symbols for Windows
if(MSVC)
    install(FILES $<TARGET_PDB_FILE:${PROJECT_NAME}> 
        DESTINATION bin 
        CONFIGURATIONS Debug RelWithDebInfo
    )
endif()

# Print configuration information
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Project: ${PROJECT_NAME}")
message(STATUS "Qt6 PREFIX: ${Qt6_PREFIX}")
message(STATUS "Source files: ${SOURCES}")
message(STATUS "Header files: ${HEADERS}")

# Enable testing
option(BUILD_TESTING "Build tests" OFF)
if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(tests)
endif()