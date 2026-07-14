//Module
//File: Sidebar.qml
//Created:Guang Yang 2087167099@qq.com        2026-07-14
//Version: 1.0      License: AGPLv3
//descripition:侧边栏
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgSecondary
    Layout.fillHeight: true
    Layout.preferredWidth: 180

    signal viewChanged(int view)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingSmall
        spacing: 0

        Text {
            text: "周易音乐播放器"
            font.pixelSize: Style.fontSizeTitle
            font.bold: true
            color: Style.textPrimary
            Layout.leftMargin: Style.spacingNormal
            Layout.topMargin: Style.spacingSmall
            Layout.bottomMargin: Style.spacingLarge
        }

        //推荐
        Text {
            text: "推荐"
            font.pixelSize: Style.fontSizeSmall
            color: Style.textTertiary
            leftPadding: Style.spacingNormal
            topPadding: Style.spacingSmall
            bottomPadding: Style.spacingMini
        }

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
            TapHandler { onTapped: viewChanged(0) }
        }

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
            TapHandler { onTapped: viewChanged(0) }
        }

        //我的音乐
        Text {
            text: "我的音乐"
            font.pixelSize: Style.fontSizeSmall
            color: Style.textTertiary
            leftPadding: Style.spacingNormal
            topPadding: Style.spacingLarge
            bottomPadding: Style.spacingMini
        }

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
            TapHandler { onTapped: viewChanged(0) }
        }

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
            TapHandler { onTapped: viewChanged(1) }
        }

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
            TapHandler { onTapped: viewChanged(2) }
        }

        Item { Layout.fillHeight: true }
    }
}
