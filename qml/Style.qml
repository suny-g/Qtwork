//Module

//File: Style.qml

//Created: Guang Yang 2087167099@qq.com        2026-07-13

//Version: 1.0      License: AGPLv3

// Description:Singleton style sheet for the whole application.

//Version: 2.0      License: AGPLv3

// Description: Singleton style sheet — Netease Cloud Music inspired dark theme.

pragma Singleton

import QtQuick
QtObject {
// ── 背景色（网易云暗色系） ──
readonly property color bgPrimary:     "#16181c"   // 主窗口背景
readonly property color bgSecondary:   "#1e2025"   // 面板/卡片背景
readonly property color bgTertiary:    "#262830"   // 输入区/滑块轨道
readonly property color bgHover:       "#2e3038"   // 悬停高亮
readonly property color bgActive:      "#363840"   // 按下/选中
// ── 边框 & 分割线 ──
readonly property color borderLight:   "#2a2c33"   // 浅分割线
readonly property color borderNormal:  "#353840"   // 常规边框
// ── 文本颜色 ──
readonly property color textPrimary:   "#e8e8ea"   // 主文本（略暖，非纯白）
readonly property color textSecondary: "#9b9da3"   // 次要文本
readonly property color textTertiary:  "#63666e"   // 辅助/占位文本
// ── 强调色（网易云品牌红） ──

readonly property color accentRed:       "#ec4141"   // 主红色
readonly property color accentRedHover:  "#ff5353"   // 悬停红
readonly property color accentRedActive: "#d43838"   // 按下红
readonly property color accentRedLight:  "#ff6b6b"   // 浅红（高亮文字）
// ── 字体大小 ──
readonly property int fontSizeTitle:  20//歌曲标题
readonly property int fontSizeNormal: 14//正文
readonly property int fontSizeSmall:  12//辅助信息，艺术家名
readonly property int fontSizeMini:   10//极小文字
// ── 间距 ──
readonly property int spacingMini:    4//图标与文字
readonly property int spacingSmall:   8//列表项内元素间距
readonly property int spacingNormal:  12//面板内边距，组件间距
readonly property int spacingLarge:   20//大区域间距，窗口外边距
readonly property int spacingXLarge:  32//超大留白，仅特殊场景
// ── 圆角 ──
readonly property int radiusSmall:    4//列表行，小标签
readonly property int radiusNormal:   8//按钮，面板，卡片
readonly property int radiusLarge:    12//大卡片，弹出层
// ── 工具函数 ──
function formatDuration(ms) {
    if (!ms || ms <= 0)
    return "0:00"
    var totalSeconds = Math.floor(ms / 1000)
    var minutes = Math.floor(totalSeconds / 60)
    var seconds = totalSeconds % 60
    return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)
}

}