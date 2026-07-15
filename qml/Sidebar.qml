// Module
// File: Sidebar.qml
// Created: Guang Yang 2087167099@qq.com        2026-07-14
// Version: 1.0      License: AGPLv3
// descripition:侧边栏
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgSecondary
    Layout.fillHeight: true
    Layout.preferredWidth: 180

    //视图切换信号（参数：view 0=发现/本地, 1=歌词, 2=我喜欢）
    signal viewChanged(int view)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingSmall
        spacing: 0

        //顶部标题
        Text {
            text: "周易音乐播放器"
            font.pixelSize: Style.fontSizeTitle
            font.bold: true
            color: Style.textPrimary
            Layout.leftMargin: Style.spacingNormal
            Layout.topMargin: Style.spacingSmall
            Layout.bottomMargin: Style.spacingLarge
        }

        //分组标题：推荐
        Text {
            text: "推荐"
            font.pixelSize: Style.fontSizeSmall
            color: Style.textTertiary
            leftPadding: Style.spacingNormal
            topPadding: Style.spacingSmall
            bottomPadding: Style.spacingMini
        }

        //菜单项：发现音乐
        Rectangle {
            width: parent.width
            height: 36
            radius: Style.radiusSmall
            color: hovered1 ? Style.bgHover : "transparent"
            property bool hovered1: false
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.spacingNormal
                anchors.rightMargin: Style.spacingNormal
                spacing: Style.spacingNormal
                Text { text: "\u266B"; font.pixelSize: 14; color: Style.textSecondary }
                Text { text: "发现音乐"; font.pixelSize: Style.fontSizeNormal; color: Style.textPrimary; Layout.fillWidth: true }
            }
            HoverHandler { onHoveredChanged: parent.hovered1 = hovered }
            TapHandler { onTapped: viewChanged(0) }   //切换至发现/本地视图
        }

        //菜单项：本地音乐（目前与发现音乐共用视图0）
        Rectangle {
            Layout.fillWidth: true
            height: 36
            radius: Style.radiusSmall
            color: hovered2 ? Style.bgHover : "transparent"
            property bool hovered2: false
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.spacingNormal
                anchors.rightMargin: Style.spacingNormal
                spacing: Style.spacingNormal
                Text { text: "\u{1F4C1}"; font.pixelSize: 14; color: Style.textSecondary }
                Text { text: "本地音乐"; font.pixelSize: Style.fontSizeNormal; color: Style.textPrimary; Layout.fillWidth: true }
            }
            HoverHandler { onHoveredChanged: parent.hovered2 = hovered }
            TapHandler { onTapped: viewChanged(0) }   //切换至发现/本地视图
        }

        //分组标题：我的音乐
        Text {
            text: "我的音乐"
            font.pixelSize: Style.fontSizeSmall
            color: Style.textTertiary
            leftPadding: Style.spacingNormal
            topPadding: Style.spacingLarge
            bottomPadding: Style.spacingMini
        }

        //菜单项：播放列表
        Rectangle {
            Layout.fillWidth: true
            height: 36
            radius: Style.radiusSmall
            color: hovered3 ? Style.bgHover : "transparent"
            property bool hovered3: false
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.spacingNormal
                anchors.rightMargin: Style.spacingNormal
                spacing: Style.spacingNormal
                Text { text: "\u{1F3B6}"; font.pixelSize: 14; color: Style.textSecondary }
                Text { text: "播放列表"; font.pixelSize: Style.fontSizeNormal; color: Style.textPrimary; Layout.fillWidth: true }
            }
            HoverHandler { onHoveredChanged: parent.hovered3 = hovered }
            TapHandler { onTapped: viewChanged(0) }   //切换至发现/本地视图
        }

        //菜单项：歌词
        Rectangle {
            Layout.fillWidth: true
            height: 36
            radius: Style.radiusSmall
            color: hovered4 ? Style.bgHover : "transparent"
            property bool hovered4: false
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.spacingNormal
                anchors.rightMargin: Style.spacingNormal
                spacing: Style.spacingNormal
                Text { text: "\u{1F3A4}"; font.pixelSize: 14; color: Style.textSecondary }
                Text { text: "歌词"; font.pixelSize: Style.fontSizeNormal; color: Style.textPrimary; Layout.fillWidth: true }
            }
            HoverHandler { onHoveredChanged: parent.hovered4 = hovered }
            TapHandler { onTapped: viewChanged(1) }   //切换至歌词视图
        }

        //菜单项：我喜欢
        Rectangle {
            Layout.fillWidth: true
            height: 36
            radius: Style.radiusSmall
            color: hovered5 ? Style.bgHover : "transparent"
            property bool hovered5: false
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.spacingNormal
                anchors.rightMargin: Style.spacingNormal
                spacing: Style.spacingNormal
                Text { text: "\u2665"; font.pixelSize: 14; color: Style.textSecondary }
                Text { text: "我喜欢"; font.pixelSize: Style.fontSizeNormal; color: Style.textPrimary; Layout.fillWidth: true }
            }
            HoverHandler { onHoveredChanged: parent.hovered5 = hovered }
            TapHandler { onTapped: viewChanged(2) }   //切换至我喜欢视图
        }

        //底部弹性空间（将上方内容顶起）
        Item { Layout.fillHeight: true }
    }
}