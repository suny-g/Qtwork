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
        anchors.centerIn: parent
        spacing: 5

        Text {
            text: {
                var idx = musicManager.playlistModel.currentIndex
                if (idx >= 0 && idx < musicManager.playlistModel.count) {
                    var item = musicManager.playlistModel.get(idx)
                    return item.title || "未知歌曲"
                }
                return "未播放"
            }
            font.pixelSize: Style.fontSizeTitle
            font.bold: true
            color: Style.textPrimary
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: {
                var idx = musicManager.playlistModel.currentIndex
                if (idx >= 0 && idx < musicManager.playlistModel.count) {
                    var item = musicManager.playlistModel.get(idx)
                    return item.artist || "未知艺术家"
                }
                return "请选择音乐文件"
            }
            font.pixelSize: Style.fontSizeNormal
            color: Style.textSecondary
            horizontalAlignment: Text.AlignHCenter
        }
    }
}