// File:LyricsView.qml   Version: 0.1.0   License: AGPLv3
// Created:Junfeng Tu  2150139603@qq.com
// Description: Lyrics display component for showing lyrics content

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgPrimary
    radius: Style.radiusNormal

    property string lyricsText: ""
    property string title: ""
    property string artist: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingLarge
        spacing: Style.spacingNormal

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingNormal

            Text {
                text: title || "歌词"
                font.pixelSize: Style.fontSizeTitle
                font.bold: true
                color: Style.textPrimary
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: artist
                font.pixelSize: Style.fontSizeNormal
                color: Style.textSecondary
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
                anchors.margins: Style.spacingNormal
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }

                TextArea {
                    text: lyricsText || "暂无歌词内容"
                    font.pixelSize: Style.fontSizeNormal
                    color: Style.textPrimary
                    background: Rectangle {
                        color: Style.bgSecondary
                    }
                    readOnly: true
                    selectByMouse: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                }
            }
        }
    }
}
