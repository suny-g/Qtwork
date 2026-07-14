cmake_minimum_required(VERSION 4.1.1)

project(My_Music VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT_QML_GENERATE_QMLLS_INI ON)

set_source_files_properties(qml/Style.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

find_package(Qt6 6.11.1 REQUIRED COMPONENTS Quick Multimedia)
qt_standard_project_setup(REQUIRES 6.11)

set(SOURCES_CXX
    src/musicmanager.cpp
    src/playlistmodel.cpp
    src/metadatareader.cpp
    src/lyricssearcher.cpp
)

qt_add_executable(appMy_Music
    main.cpp
    ${SOURCES_CXX}
)

qt_add_qml_module(appMy_Music
    URI Music
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/Style.qml
        qml/components/SongInfoPanel.qml
        qml/components/ProgressBar.qml
        qml/components/PlaybackControls.qml
        qml/components/PlaylistView.qml
        qml/components/VolumeControl.qml
        qml/components/LyricsDisplay.qml
        QML_FILES qml/Sidebar.qml
        QML_FILES qml/components/LikedSongsView.qml
)

target_sources(appMy_Music PRIVATE
    src/musicmanager.h
    src/playlistmodel.h
    src/metadatareader.h
    src/lyricssearcher.h
)

target_include_directories(appMy_Music PRIVATE src)

target_link_libraries(appMy_Music
    PRIVATE
        Qt6::Quick
        Qt6::Multimedia
)

install(TARGETS appMy_Music
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
