//Module
//File: SongInfoPanel.qml
//Created:Guang Yang 2087167099@qq.com &&JunFeng Tu 2150319601@qq.com       2026-07-13
//Version: 1.0      License: AGPLv3
//change the siza and location.
import QtQuick
import QtQuick.Layouts
import Music

Rectangle {
    id: root
    color: Style.bgSecondary
    radius: Style.radiusNormal

    Layout.fillWidth: true
    Layout.preferredHeight: 100

    ColumnLayout {
        anchors.fill: parent  //改为 fill parent，使布局填充整个区域
        anchors.leftMargin: Style.spacingNormal   //加一点左边距
        anchors.rightMargin: Style.spacingNormal
        spacing: 5

        Text {
            text: {
                var idx = musicManager.playlistModel.currentIndex
                if (idx >= 0 && idx < musicManager.playlistModel.count) {
                    var item = musicManager.playlistModel.get(idx)
                    return item.title ||"未知歌曲"
                }
                return "未播放"
            }
            font.pixelSize: Style.fontSizeTitle
            font.bold: true
            color: Style.textPrimary
            horizontalAlignment: Text.AlignLeft //改为左对齐
            Layout.fillWidth: true             //让文本占据整行宽度
        }

        Text {
            text: {
                var idx = musicManager.playlistModel.currentIndex
                if (idx >= 0 && idx < musicManager.playlistModel.count) {
                    var item = musicManager.playlistModel.get(idx)
                    return item.artist ||"未知艺术家"
                }
                return "请选择音乐文件"
            }
            font.pixelSize: Style.fontSizeNormal
            color: Style.textSecondary
            horizontalAlignment: Text.AlignLeft//改为左对齐
            Layout.fillWidth: true             //让文本占据整行宽度
        }
    }
}