pragma Singleton
import QtQuick

QtObject {
    readonly property color bgPrimary: "#13131a"
    readonly property color bgSecondary: "#1a1a21"
    readonly property color bgTertiary: "#2d2d37"
    readonly property color bgHover: "#27272d"
    
    readonly property color textPrimary: "#ffffff"
    readonly property color textSecondary: "#a1a1a3"
    readonly property color textTertiary: "#75777f"
    
    readonly property color accentRed: "#e84f50"
    readonly property color accentRedHover: "#ff5a5b"
    
    readonly property int fontSizeTitle: 20
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeSmall: 12
    
    readonly property int spacingNormal: 12
    readonly property int spacingSmall: 8
    readonly property int spacingLarge: 20
    
    readonly property int radiusNormal: 8
    
    function formatDuration(ms) {
        if (!ms || ms <= 0)
            return "0:00"
        var totalSeconds = Math.floor(ms / 1000)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)
    }
}
