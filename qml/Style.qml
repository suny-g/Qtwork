//Module
//File: Style.qml
//Created: Guang Yang 2087167099@qq.com        2026-07-13
//Version: 1.0      License: AGPLv3
// Description:Singleton style sheet for the whole application.
pragma Singleton
import QtQuick

// 全局样式单例，所有 UI 组件统一引用
QtObject {
    // 背景色
    readonly property color bgPrimary: "#13131a"
    readonly property color bgSecondary: "#1a1a21"
    readonly property color bgTertiary: "#2d2d37"
    readonly property color bgHover: "#27272d"
    // 文本颜色
    readonly property color textPrimary: "#ffffff"
    readonly property color textSecondary: "#a1a1a3"
    readonly property color textTertiary: "#75777f"
    // 强调色（红色系）
    readonly property color accentRed: "#e84f50"
    readonly property color accentRedHover: "#ff5a5b"
    // 字体大小
    readonly property int fontSizeTitle: 20
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeSmall: 12
    // 间距
    readonly property int spacingNormal: 12
    readonly property int spacingSmall: 8
    readonly property int spacingLarge: 20
    // 圆角
    readonly property int radiusNormal: 8
    // 工具：毫秒 → 分:秒
    function formatDuration(ms) {
        if (!ms || ms <= 0)
            return "0:00"
        var totalSeconds = Math.floor(ms / 1000)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)
    }
}