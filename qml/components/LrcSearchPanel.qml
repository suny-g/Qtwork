// File:LrcSearchPanel.qml   Version: 0.1.0   License: AGPLv3
// Created:Junfeng Tu  2150139603@qq.com
// Description: Lyrics search panel component with search input and results list

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgPrimary
    radius: Style.radiusNormal

    property var searchResults: []
    property string currentKeyword: ""

    signal lyricsSelected(string filePath, string title, string artist)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingLarge
        spacing: Style.spacingNormal

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingNormal

            TextField {
                id: searchInput
                placeholderText: "搜索歌词（歌曲名、歌手名）"
                font.pixelSize: Style.fontSizeNormal
                Layout.fillWidth: true
                background: Rectangle {
                    color: Style.bgSecondary
                    radius: Style.radiusSmall
                    border.color: Style.borderNormal
                    border.width: 1
                }

                onTextChanged: {
                    currentKeyword = text.trim()
                    performSearch()
                }
            }

            Button {
                text: "搜索"
                font.pixelSize: Style.fontSizeNormal
                onClicked: performSearch()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgSecondary
            radius: Style.radiusNormal
            border.color: Style.borderNormal
            border.width: 1

            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.spacingSmall
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }

                ListView {
                    id: resultsList
                    model: searchResults
                    delegate: Item {
                        width: parent.width
                        height: 60
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.spacingSmall
                            spacing: 2

                            Text {
                                text: model.title || model.fileName
                                font.pixelSize: Style.fontSizeNormal
                                font.bold: true
                                color: Style.textPrimary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: model.artist || "未知歌手"
                                font.pixelSize: Style.fontSizeSmall
                                color: Style.textSecondary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: model.filePath
                                font.pixelSize: Style.fontSizeSmall
                                color: Style.textSecondary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                lyricsSelected(model.filePath, model.title || model.fileName, model.artist)
                            }
                            hoverEnabled: true
                            onHoveredChanged: {
                                parent.color = hovered ? Style.accentRed : Style.bgSecondary
                            }
                        }
                    }

                    Component {
                        id: emptyDelegate
                        Item {
                            width: parent.width
                            height: 100
                            Text {
                                anchors.centerIn: parent
                                text: "未找到歌词文件，请添加.lrc文件到音乐目录"
                                font.pixelSize: Style.fontSizeNormal
                                color: Style.textSecondary
                            }
                        }
                    }

                    Component.onCompleted: {
                        if (model.length === 0) {
                            resultsList.currentIndex = -1
                        }
                    }
                }
            }
        }
    }

    function performSearch() {
        searchResults = musicManager.lyricsSearcher.searchLyrics(currentKeyword)
    }

    Component.onCompleted: {
        performSearch()
    }
}
