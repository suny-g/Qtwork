//Module
//File: Style.qml
//Created: Guang Yang 2087167099@qq.com        2026-07-14
//Version: 3.0      License: AGPLv3
// Description: Singleton style sheet — NetEase Cloud Music inspired dark theme.
//
pragma Singleton
import QtQuick

QtObject {
    // 背景色 — 五层递进，构建视觉深度
    // 最底层：窗口/页面大背景，最暗
    readonly property color bgPrimary:     "#16181c"
    // 第二层：Sidebar、GroupBox、卡片等容器背景
    readonly property color bgSecondary:   "#1e2025"
    // 第三层：文本框、Slider 轨道、输入框等控件底色
    readonly property color bgTertiary:    "#262830"
    // 第四层：鼠标悬停反馈，列表行/按钮 hover 态
    readonly property color bgHover:       "#2e3038"
    // 第五层：按下态 / 选中态（最亮）
    readonly property color bgActive:      "#363840"
    // 边框 & 分割线 — 细致分隔，不抢眼
    // 列表行之间的轻分割线，或卡片内部分隔
    readonly property color borderLight:   "#2a2c33"
    // 面板/输入框外边框，比 borderLight 稍明显
    readonly property color borderNormal:  "#353840"
    // 文本颜色 — 三级灰度，清晰有层次

    // 标题、歌曲名、当前播放项等主要文字
    readonly property color textPrimary:   "#e8e8ea"

    // 艺术家名、时长、次要标签等辅助文字
    readonly property color textSecondary: "#9b9da3"

    // 占位符、提示文字、禁用态文字，最弱
    readonly property color textTertiary:  "#63666e"

    // 强调色 — 网易云品牌红，四种状态
    // 默认态：播放/暂停按钮、当前播放行高亮、进度条滑块
    readonly property color accentRed:       "#ec4141"
    // 悬停态：鼠标悬停在红色按钮上
    readonly property color accentRedHover:  "#ff5353"
    // 按下态：按钮被点击瞬间
    readonly property color accentRedActive: "#d43838"
    // 高亮文字
    readonly property color accentRedLight:  "#ff6b6b"

    // 字体大小 — 四档，覆盖所有场景
    readonly property int fontSizeTitle:  20   // 歌曲标题
    readonly property int fontSizeNormal: 14   // 正文、列表项标题
    readonly property int fontSizeSmall:  12   // 辅助信息（艺术家、时长、序号）
    readonly property int fontSizeMini:   10   // 极小文字（版权信息、ToolTip
    // 间距
    readonly property int spacingMini:    4    // 图标与文字之间
    readonly property int spacingSmall:   8    // 列表项内部元素间距
    readonly property int spacingNormal:  12   // 面板内边距、组件间距
    readonly property int spacingLarge:   20   // 大区域间距、窗口外边距
    readonly property int spacingXLarge:  32   // 超大留白，仅特殊场景

    // 圆角
    readonly property int radiusSmall:    4    // 列表行、小标签
    readonly property int radiusNormal:   8    // 按钮、面板、卡片
    readonly property int radiusLarge:    12   // 大卡片、弹出层
    // 工具函数
    // 毫秒 → 分:秒 格式化，例如 245000 → "4:05"
    function formatDuration(ms) {
        if (!ms || ms <= 0)
            return "0:00"
        var totalSeconds = Math.floor(ms / 1000)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)
    }
}