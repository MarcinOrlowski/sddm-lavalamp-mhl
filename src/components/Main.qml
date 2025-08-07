import QtQuick 2.15
import SddmComponents 2.0
import QtQuick.VirtualKeyboard 2.4
import QtGraphicalEffects 1.15
import "../shaders"

/**
 * Lava Lamp MHL: SDDM dynamic login theme
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2025 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/sddm-lavalamp-mhl
 */

Rectangle {
    id: container
    focus: true  // Enable keyboard focus for the container
    color: "transparent"  // Let background gradient show through

    // Hide mouse cursor when UI is hidden
    property bool shouldHideCursor: themeConfig.uiAutoHide && !uiVisible

    TextConstants { id: textConstants }

    // Global simulation parameters (not theme-specific)
    readonly property QtObject simulationConfig: QtObject {
        readonly property int metaballCount: 35
        readonly property real metaballMinSize: 0.02
        readonly property real metaballMaxSize: 0.07
        readonly property real metaballMinSpeed: 32
        readonly property real metaballMaxSpeed: 83
        readonly property real metaballThreshold: 0.99
        readonly property real metaballBaseColorR: 1.0
        readonly property real metaballBaseColorG: 1.0
        readonly property real metaballBaseColorB: 1.0
        readonly property real animationSpeed: 0.5
        readonly property real verticalBias: 2.0
        readonly property real horizontalScale: 0.5
        readonly property bool uiAutoHide: true
        readonly property int uiHideTimeout: 7500
        readonly property bool uiHideOnStart: false
        readonly property bool actionButtonsAlwaysVisible: true
        readonly property bool useIconButtons: true
        readonly property bool clockEnabled: true
        readonly property string clockFont: "Arial"
        readonly property string uiFont: "Arial"
        readonly property real formOpacity: 0.85
        readonly property bool debugAlwaysShowSessionSelector: false
    }

    // Visual themes (colors and rendering only)
    readonly property QtObject themes: QtObject {
        readonly property QtObject heat: QtObject {
            readonly property string gradientType: "vertical"
            readonly property string gradientColor1: "#ff6b00"
            readonly property string gradientColor2: "#ff0000"
            readonly property string gradientColor3: "#ff6b00"
            readonly property string gradientColor4: "#ff0000"
            readonly property bool backgroundGradientEnabled: true
            readonly property string backgroundGradientType: "vertical"
            readonly property string backgroundColor1: "#381c0e"
            readonly property string backgroundColor2: "#1c0e07"
            readonly property string backgroundColor3: "#381c0e"
            readonly property string backgroundColor4: "#1c0e07"
            readonly property string iconColor: "#ddFF6b00"
            readonly property string suspendIconColor: "#ddFF6b00"
            readonly property string hibernateIconColor: "#ddFF6b00"
            readonly property string shutdownIconColor: "#ddFF6b00"
            readonly property string rebootIconColor: "#ddFF6b00"
            readonly property int clockFontSize: 90
            readonly property string clockColor: "#ddFF6b00"
            readonly property string uiPrimaryColor: "#8B4513"
            readonly property string uiSecondaryColor: "#FF6B35"
            readonly property string uiTextColor: "#FFE4CC"
            readonly property string uiBackgroundColor: "#2A1A0F"
            readonly property string welcomeTextColor: "#FF6B00"
            readonly property string inputLabelColor: "#CC5500"
            readonly property string copyrightTextColor: "#FF7A7A"
            readonly property bool glowEffectEnabled: true
            readonly property real glowIntensity: 3.0
            readonly property real glowInnerThreshold: 0.7
            readonly property real glowMidThreshold: 0.3
            readonly property real glowOuterThreshold: 0.05
            readonly property real glowMinFieldStrength: 0.005
        }

        readonly property QtObject ocean: QtObject {
            readonly property string gradientType: "rainbow"
            readonly property string gradientColor1: "#00FFFF"
            readonly property string gradientColor2: "#0080FF"
            readonly property string gradientColor3: "#FF00FF"
            readonly property string gradientColor4: "#8000FF"
            readonly property bool backgroundGradientEnabled: true
            readonly property string backgroundGradientType: "rainbow"
            readonly property string backgroundColor1: "#001a2a"
            readonly property string backgroundColor2: "#000510"
            readonly property string backgroundColor3: "#2a001a"
            readonly property string backgroundColor4: "#100005"
            readonly property string iconColor: "#00FFFF"
            readonly property string suspendIconColor: "#00FFFF"
            readonly property string hibernateIconColor: "#00FFFF"
            readonly property string shutdownIconColor: "#FF8080"
            readonly property string rebootIconColor: "#80FF80"
            readonly property int clockFontSize: 90
            readonly property string clockColor: "#00FFFF"
            readonly property string uiPrimaryColor: "#0080C0"
            readonly property string uiSecondaryColor: "#00FFFF"
            readonly property string uiTextColor: "#FFFFFF"
            readonly property string uiBackgroundColor: "#1a0040"
            readonly property string welcomeTextColor: "#00FFFF"
            readonly property string inputLabelColor: "#80C0FF"
            readonly property string copyrightTextColor: "#C080FF"
            readonly property bool glowEffectEnabled: true
            readonly property real glowIntensity: 2.0
            readonly property real glowInnerThreshold: 0.75
            readonly property real glowMidThreshold: 0.4
            readonly property real glowOuterThreshold: 0.1
            readonly property real glowMinFieldStrength: 0.01
        }

        readonly property QtObject forest: QtObject {
            readonly property string gradientType: "corners"
            readonly property string gradientColor1: "#80FF80"
            readonly property string gradientColor2: "#006600"
            readonly property string gradientColor3: "#CCFF80"
            readonly property string gradientColor4: "#408040"
            readonly property bool backgroundGradientEnabled: true
            readonly property string backgroundGradientType: "corners"
            readonly property string backgroundColor1: "#1a2a1a"
            readonly property string backgroundColor2: "#0f1f0f"
            readonly property string backgroundColor3: "#1a2a1a"
            readonly property string backgroundColor4: "#0f1f0f"
            readonly property string iconColor: "#80FF80"
            readonly property string suspendIconColor: "#80FF80"
            readonly property string hibernateIconColor: "#80FF80"
            readonly property string shutdownIconColor: "#FF8080"
            readonly property string rebootIconColor: "#FFFF80"
            readonly property int clockFontSize: 90
            readonly property string clockColor: "#C0FFC0"
            readonly property string uiPrimaryColor: "#408040"
            readonly property string uiSecondaryColor: "#60A060"
            readonly property string uiTextColor: "#E0FFE0"
            readonly property string uiBackgroundColor: "#203020"
            readonly property string welcomeTextColor: "#80FF80"
            readonly property string inputLabelColor: "#60C060"
            readonly property string copyrightTextColor: "#A0C0A0"
            readonly property bool glowEffectEnabled: true
            readonly property real glowIntensity: 3.5
            readonly property real glowInnerThreshold: 0.7
            readonly property real glowMidThreshold: 0.3
            readonly property real glowOuterThreshold: 0.05
            readonly property real glowMinFieldStrength: 0.005
        }
    }

    // Theme cycling state
    property string currentTheme: {
        var configTheme = config.stringValue("theme")
        if (!configTheme || availableThemes.indexOf(configTheme) === -1) {
            // Invalid or empty theme - pick random one
            var randomIndex = Math.floor(Math.random() * availableThemes.length)
            console.log("Invalid/empty theme '" + configTheme + "', randomly selected:", availableThemes[randomIndex])
            return availableThemes[randomIndex]
        }
        return configTheme
    }
    readonly property var availableThemes: ["heat", "ocean", "forest"]

    // Active theme selection
    readonly property QtObject activeTheme: {
        switch(currentTheme) {
            case "ocean": return themes.ocean
            case "forest": return themes.forest
            case "heat":
            default: return themes.heat
        }
    }

    // Theme cycling function
    function cycleTheme() {
        var currentIndex = availableThemes.indexOf(currentTheme)
        var nextIndex = (currentIndex + 1) % availableThemes.length
        currentTheme = availableThemes[nextIndex]
        console.log("Theme changed to:", currentTheme)
    }

    // Gradient mode constants  
    readonly property int gradientModeVertical: 0
    readonly property int gradientModeCorners: 1
    readonly property int gradientModeRainbow: 2

    // Gradient mode mapping function
    function getGradientMode(gradientType) {
        switch(gradientType) {
            case "vertical": return gradientModeVertical
            case "corners": return gradientModeCorners  
            case "rainbow": return gradientModeRainbow
            default: return gradientModeRainbow    // fallback to rainbow
        }
    }

    // Centralized configuration combining simulation and visual theme
    readonly property QtObject themeConfig: QtObject {
        // Simulation parameters (global, not theme-specific)
        readonly property int metaballCount: simulationConfig.metaballCount
        readonly property real metaballMinSize: simulationConfig.metaballMinSize
        readonly property real metaballMaxSize: simulationConfig.metaballMaxSize
        readonly property real metaballMinSpeed: simulationConfig.metaballMinSpeed / 100.0  // Convert to internal scale
        readonly property real metaballMaxSpeed: simulationConfig.metaballMaxSpeed / 100.0  // Convert to internal scale
        readonly property real metaballThreshold: simulationConfig.metaballThreshold
        readonly property real animationSpeed: simulationConfig.animationSpeed
        readonly property real metaballBaseColorR: simulationConfig.metaballBaseColorR
        readonly property real metaballBaseColorG: simulationConfig.metaballBaseColorG
        readonly property real metaballBaseColorB: simulationConfig.metaballBaseColorB
        readonly property real verticalBias: simulationConfig.verticalBias
        readonly property real horizontalScale: simulationConfig.horizontalScale
        readonly property bool uiAutoHide: simulationConfig.uiAutoHide
        readonly property int uiHideTimeout: simulationConfig.uiHideTimeout
        readonly property bool uiHideOnStart: simulationConfig.uiHideOnStart
        readonly property bool actionButtonsAlwaysVisible: simulationConfig.actionButtonsAlwaysVisible
        readonly property bool useIconButtons: simulationConfig.useIconButtons
        readonly property bool clockEnabled: simulationConfig.clockEnabled
        readonly property string clockFont: simulationConfig.clockFont
        readonly property string uiFont: simulationConfig.uiFont
        readonly property real formOpacity: simulationConfig.formOpacity
        readonly property bool debugAlwaysShowSessionSelector: simulationConfig.debugAlwaysShowSessionSelector

        // Visual properties (theme-specific)
        readonly property string iconColor: activeTheme.iconColor
        readonly property string suspendIconColor: activeTheme.suspendIconColor
        readonly property string hibernateIconColor: activeTheme.hibernateIconColor
        readonly property string shutdownIconColor: activeTheme.shutdownIconColor
        readonly property string rebootIconColor: activeTheme.rebootIconColor
        readonly property int clockFontSize: activeTheme.clockFontSize
        readonly property string clockColor: activeTheme.clockColor
        readonly property string gradientType: activeTheme.gradientType
        readonly property string gradientColor1: activeTheme.gradientColor1
        readonly property string gradientColor2: activeTheme.gradientColor2
        readonly property string gradientColor3: activeTheme.gradientColor3
        readonly property string gradientColor4: activeTheme.gradientColor4

        // Convert hex colors to RGB vectors for shader
        function hexToRgb(hex) {
            var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
            return result ? {
                r: parseInt(result[1], 16) / 255.0,
                g: parseInt(result[2], 16) / 255.0,
                b: parseInt(result[3], 16) / 255.0
            } : {r: 1.0, g: 1.0, b: 1.0};
        }

        readonly property bool backgroundGradientEnabled: activeTheme.backgroundGradientEnabled
        readonly property string backgroundGradientType: activeTheme.backgroundGradientType
        readonly property string backgroundColor1: activeTheme.backgroundColor1
        readonly property string backgroundColor2: activeTheme.backgroundColor2
        readonly property string backgroundColor3: activeTheme.backgroundColor3
        readonly property string backgroundColor4: activeTheme.backgroundColor4
        readonly property bool glowEffectEnabled: activeTheme.glowEffectEnabled
        readonly property real glowIntensity: activeTheme.glowIntensity
        readonly property real glowInnerThreshold: activeTheme.glowInnerThreshold
        readonly property real glowMidThreshold: activeTheme.glowMidThreshold
        readonly property real glowOuterThreshold: activeTheme.glowOuterThreshold
        readonly property real glowMinFieldStrength: activeTheme.glowMinFieldStrength
        readonly property string uiPrimaryColor: activeTheme.uiPrimaryColor
        readonly property string uiSecondaryColor: activeTheme.uiSecondaryColor
        readonly property string uiTextColor: activeTheme.uiTextColor
        readonly property string uiBackgroundColor: activeTheme.uiBackgroundColor
        readonly property string welcomeTextColor: activeTheme.welcomeTextColor
        readonly property string inputLabelColor: activeTheme.inputLabelColor
        readonly property string copyrightTextColor: activeTheme.copyrightTextColor

        // RGB conversions for colors
        readonly property var gradientColor1Rgb: hexToRgb(gradientColor1)
        readonly property var gradientColor2Rgb: hexToRgb(gradientColor2)
        readonly property var gradientColor3Rgb: hexToRgb(gradientColor3)
        readonly property var gradientColor4Rgb: hexToRgb(gradientColor4)
        readonly property var backgroundColor1Rgb: hexToRgb(backgroundColor1)
        readonly property var backgroundColor2Rgb: hexToRgb(backgroundColor2)
        readonly property var backgroundColor3Rgb: hexToRgb(backgroundColor3)
        readonly property var backgroundColor4Rgb: hexToRgb(backgroundColor4)

        // Convert UI colors to RGB
        readonly property var uiPrimaryColorRgb: hexToRgb(uiPrimaryColor)
        readonly property var uiSecondaryColorRgb: hexToRgb(uiSecondaryColor)
        readonly property var uiTextColorRgb: hexToRgb(uiTextColor)
        readonly property var uiBackgroundColorRgb: hexToRgb(uiBackgroundColor)

        // Gradient mode values for shaders
        readonly property int gradientModeValue: getGradientMode(activeTheme.gradientType)
        readonly property int backgroundGradientModeValue: getGradientMode(activeTheme.backgroundGradientType)

        // Debug gradient modes
        Component.onCompleted: {
            console.log("Theme:", currentTheme, "gradientType:", activeTheme.gradientType, "→ mode:", gradientModeValue)
        }
    }

    // Dynamic screen dimensions - uses primary screen geometry with fallback
    width: screenModel ? screenModel.geometry(screenModel.primary).width : 1920
    height: screenModel ? screenModel.geometry(screenModel.primary).height : 1080

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    // Auto-hide UI properties
    property bool uiVisible: !themeConfig.uiHideOnStart  // Start hidden if configured
    property bool enableAnimations: true  // Enable animations

    // Auto-focus when UI becomes visible
    onUiVisibleChanged: {
        if (uiVisible && enableAnimations) {
            Qt.callLater(focusFirstVisibleFormControl)
        }
    }

    Timer {
        id: hideTimer
        interval: themeConfig.uiHideTimeout
        running: themeConfig.uiAutoHide
        repeat: false
        onTriggered: {
            if (themeConfig.uiAutoHide) {
                uiVisible = false
            }
        }
    }

    // Activity tracking timer - clears focus after inactivity
    Timer {
        id: activityTimer
        interval: 3000  // Clear focus after 3 seconds of inactivity
        running: false
        repeat: false
        onTriggered: {
            if (themeConfig.uiAutoHide && isInputFieldFocused()) {
                clearInputFocus()
            }
        }
    }

    // Track if user has been active recently
    property bool recentActivity: false

    function isInputFieldFocused() {
        return name.activeFocus || password.activeFocus
    }

    function clearInputFocus() {
        // Transfer focus to the main container to clear input focus
        container.forceActiveFocus(Qt.OtherFocusReason)
    }

    function focusFirstVisibleFormControl() {
        // Auto-focus logic: username first if empty, otherwise password
        const nextControl = (name.text.length === 0) ? name : password
        nextControl.forceActiveFocus(Qt.TabFocusReason)
    }

    // Shader components
    MetaballsVertexShader {
        id: vertexShaderSource
    }

    MetaballsFragmentShader {
        id: fragmentShaderSource
    }

    BackgroundGradientShader {
        id: backgroundShaderSource
    }

    function resetHideTimer() {
        if (themeConfig.uiAutoHide) {
            uiVisible = true
            // Always restart hide timer - it will be managed by activity detection
            hideTimer.interval = themeConfig.uiHideTimeout
            hideTimer.restart()
        }
    }

    function recordActivity() {
        if (themeConfig.uiAutoHide) {
            uiVisible = true
            recentActivity = true

            // Restart both timers on activity
            hideTimer.interval = themeConfig.uiHideTimeout
            hideTimer.restart()

            activityTimer.restart()
        }
    }

    function setInitialUIState() {
        if (themeConfig.uiHideOnStart) {
            uiVisible = false
        } else {
            uiVisible = true
        }
    }

    // Global mouse area to detect activity and handle focus clearing
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: container.shouldHideCursor ? Qt.BlankCursor : Qt.ArrowCursor
        z: container.shouldHideCursor ? 1000 : -1  // Bring to front when hiding cursor
        onPositionChanged: recordActivity()
        onClicked: {
            recordActivity()
            // Clear focus from input fields when clicking on background
            clearInputFocus()
        }
    }

    // Global key event handler
    Keys.onPressed: recordActivity()

    // Cursor hiding overlay - only visible when we want to hide cursor
    MouseArea {
        anchors.fill: parent
        visible: container.shouldHideCursor
        hoverEnabled: true
        cursorShape: Qt.BlankCursor
        z: 2000  // Above everything
        onPositionChanged: recordActivity()
        onClicked: recordActivity()
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }
        function onLoginFailed() {
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }

    // Background gradient (behind metaballs) - reuses same gradient logic as metaballs
    ShaderEffect {
        anchors.fill: parent
        visible: themeConfig.backgroundGradientEnabled

        property size resolution: Qt.size(container.width, container.height)
        property vector3d baseColor: Qt.vector3d(themeConfig.metaballBaseColorR, themeConfig.metaballBaseColorG, themeConfig.metaballBaseColorB)
        property vector3d gradientColor1: Qt.vector3d(themeConfig.backgroundColor1Rgb.r, themeConfig.backgroundColor1Rgb.g, themeConfig.backgroundColor1Rgb.b)
        property vector3d gradientColor2: Qt.vector3d(themeConfig.backgroundColor2Rgb.r, themeConfig.backgroundColor2Rgb.g, themeConfig.backgroundColor2Rgb.b)
        property vector3d gradientColor3: Qt.vector3d(themeConfig.backgroundColor3Rgb.r, themeConfig.backgroundColor3Rgb.g, themeConfig.backgroundColor3Rgb.b)
        property vector3d gradientColor4: Qt.vector3d(themeConfig.backgroundColor4Rgb.r, themeConfig.backgroundColor4Rgb.g, themeConfig.backgroundColor4Rgb.b)
        property int gradientMode: themeConfig.backgroundGradientModeValue

        vertexShader: vertexShaderSource.source
        fragmentShader: backgroundShaderSource.source
    }

    // Metaballs background effect
    ShaderEffect {
        anchors.fill: parent

        property real time: 0
        property real randomSeed: Math.random() * 10000.0  // Random seed for varied initial positions
        // Direct binding to config values to ensure shader gets updated
        property int numMetaballs: themeConfig.metaballCount
        property size resolution: Qt.size(container.width, container.height)
        property real minSize: themeConfig.metaballMinSize * container.height
        property real maxSize: themeConfig.metaballMaxSize * container.height
        property real minSpeed: themeConfig.metaballMinSpeed
        property real maxSpeed: themeConfig.metaballMaxSpeed
        property real threshold: themeConfig.metaballThreshold
        property vector3d baseColor: Qt.vector3d(themeConfig.metaballBaseColorR, themeConfig.metaballBaseColorG, themeConfig.metaballBaseColorB)
        property string gradientType: themeConfig.gradientType
        property vector3d gradientColor1: Qt.vector3d(themeConfig.gradientColor1Rgb.r, themeConfig.gradientColor1Rgb.g, themeConfig.gradientColor1Rgb.b)
        property vector3d gradientColor2: Qt.vector3d(themeConfig.gradientColor2Rgb.r, themeConfig.gradientColor2Rgb.g, themeConfig.gradientColor2Rgb.b)
        property vector3d gradientColor3: Qt.vector3d(themeConfig.gradientColor3Rgb.r, themeConfig.gradientColor3Rgb.g, themeConfig.gradientColor3Rgb.b)
        property vector3d gradientColor4: Qt.vector3d(themeConfig.gradientColor4Rgb.r, themeConfig.gradientColor4Rgb.g, themeConfig.gradientColor4Rgb.b)
        property int gradientMode: themeConfig.gradientModeValue
        property real verticalBias: themeConfig.verticalBias
        property real horizontalScale: themeConfig.horizontalScale
        property bool backgroundGradientEnabled: themeConfig.backgroundGradientEnabled
        property vector3d backgroundGradientColor1: Qt.vector3d(themeConfig.backgroundColor1Rgb.r, themeConfig.backgroundColor1Rgb.g, themeConfig.backgroundColor1Rgb.b)
        property vector3d backgroundGradientColor2: Qt.vector3d(themeConfig.backgroundColor2Rgb.r, themeConfig.backgroundColor2Rgb.g, themeConfig.backgroundColor2Rgb.b)
        property vector3d backgroundGradientColor3: Qt.vector3d(themeConfig.backgroundColor3Rgb.r, themeConfig.backgroundColor3Rgb.g, themeConfig.backgroundColor3Rgb.b)
        property vector3d backgroundGradientColor4: Qt.vector3d(themeConfig.backgroundColor4Rgb.r, themeConfig.backgroundColor4Rgb.g, themeConfig.backgroundColor4Rgb.b)
        property bool glowEffectEnabled: themeConfig.glowEffectEnabled
        property real glowIntensity: themeConfig.glowIntensity
        property real glowInnerThreshold: themeConfig.glowInnerThreshold
        property real glowMidThreshold: themeConfig.glowMidThreshold
        property real glowOuterThreshold: themeConfig.glowOuterThreshold
        property real glowMinFieldStrength: themeConfig.glowMinFieldStrength

        // Debug output to verify values
        // onNumMetaballsChanged: console.log("Shader numMetaballs changed to:", numMetaballs)
        // onBaseColorChanged: console.log("Shader baseColor changed to:", baseColor)

        // Force shader recompilation when key properties change
        property string shaderKey: numMetaballs + "_" + minSize + "_" + maxSize

        vertexShader: vertexShaderSource.source

        fragmentShader: {
            var shader = fragmentShaderSource.source.replace("{{MAX_METABALLS}}", themeConfig.metaballCount.toString())
            return shader
        }

        // Use SequentialAnimation with very large duration to avoid resets
        SequentialAnimation on time {
            loops: Animation.Infinite
            NumberAnimation {
                from: 0
                to: 1000000  // Very large number
                duration: Math.floor(1000000 / (themeConfig.animationSpeed * 0.1))  // Scale to make 1.0 = current speed
            }
        }
    }


    // Login form container
    Rectangle {
        id: loginForm
        anchors.centerIn: parent
        width: 420
        height: 380
        color: Qt.rgba(themeConfig.uiBackgroundColorRgb.r, themeConfig.uiBackgroundColorRgb.g, themeConfig.uiBackgroundColorRgb.b, themeConfig.formOpacity)
        radius: 15
        border.color: Qt.rgba(themeConfig.uiSecondaryColorRgb.r, themeConfig.uiSecondaryColorRgb.g, themeConfig.uiSecondaryColorRgb.b, 0.6)
        border.width: 1

        opacity: themeConfig.uiAutoHide ? (uiVisible ? 1.0 : 0.0) : 1.0
        Behavior on opacity {
            NumberAnimation {
                duration: enableAnimations ? 800 : 0
                easing.type: Easing.InOutQuad
            }
        }

        // MouseArea to prevent clicks from passing through to background
        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Just consume the click, don't clear focus
                resetHideTimer()
            }
        }

        // Subtle inner glow effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius - 1
            color: "transparent"
            border.color: Qt.rgba(themeConfig.uiSecondaryColorRgb.r, themeConfig.uiSecondaryColorRgb.g, themeConfig.uiSecondaryColorRgb.b, 0.3)
            border.width: 1
        }

        Column {
            anchors.centerIn: parent
            spacing: 25
            width: 350

            // Welcome text
            Text {
                text: "Welcome"
                color: themeConfig.welcomeTextColor
                font.pixelSize: 36
                font.bold: true
                font.family: themeConfig.uiFont
                anchors.horizontalCenter: parent.horizontalCenter

                // Strong text shadow for better contrast
                style: Text.Raised
                styleColor: Qt.rgba(0, 0, 0, 0.8)
            }

            // Username section
            Column {
                spacing: 8
                width: parent.width

                Text {
                    text: textConstants.userName || "Username"
                    color: themeConfig.inputLabelColor
                    font.pixelSize: 14
                    font.family: themeConfig.uiFont
                }

                Rectangle {
                    id: name
                    width: parent.width
                    height: 45
                    radius: 6
                    color: themeConfig.uiBackgroundColor
                    border.color: nameInput.activeFocus ? themeConfig.uiSecondaryColor : themeConfig.uiPrimaryColor
                    border.width: 2

                    property alias text: nameInput.text

                    function forceActiveFocus(reason) {
                        nameInput.forceActiveFocus(reason)
                    }

                    TextInput {
                        id: nameInput
                        anchors.fill: parent
                        anchors.margins: 8

                        text: userModel.lastUser || ""
                        color: themeConfig.uiTextColor
                        font.pixelSize: 16
                        font.family: "Arial"
                        selectByMouse: true
                        verticalAlignment: TextInput.AlignVCenter

                        KeyNavigation.backtab: rebootButton
                        KeyNavigation.tab: password

                        onActiveFocusChanged: resetHideTimer()
                        onTextChanged: recordActivity()

                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            } else {
                                // Record activity on any keystroke
                                recordActivity()
                            }
                        }
                    }
                }
            }

            // Password section
            Column {
                spacing: 8
                width: parent.width

                Text {
                    text: textConstants.password || "Password"
                    color: themeConfig.inputLabelColor
                    font.pixelSize: 14
                    font.family: themeConfig.uiFont
                }

                Rectangle {
                    id: password
                    width: parent.width
                    height: 45
                    radius: 6
                    color: themeConfig.uiBackgroundColor
                    border.color: passwordInput.activeFocus ? themeConfig.uiSecondaryColor : themeConfig.uiPrimaryColor
                    border.width: 2

                    property alias text: passwordInput.text

                    function forceActiveFocus(reason) {
                        passwordInput.forceActiveFocus(reason)
                    }

                    TextInput {
                        id: passwordInput
                        anchors.fill: parent
                        anchors.margins: 8

                        color: themeConfig.uiTextColor
                        font.pixelSize: 16
                        font.family: "Arial"
                        selectByMouse: true
                        echoMode: TextInput.Password
                        verticalAlignment: TextInput.AlignVCenter

                        KeyNavigation.backtab: name
                        KeyNavigation.tab: session

                        onActiveFocusChanged: resetHideTimer()
                        onTextChanged: recordActivity()

                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            } else {
                                // Record activity on any keystroke
                                recordActivity()
                            }
                        }
                    }
                }
            }

            // Session and login button row
            Row {
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    id: session
                    width: 200
                    height: 40
                    radius: 6
                    color: themeConfig.uiBackgroundColor
                    border.color: sessionMouseArea.containsMouse ? themeConfig.uiSecondaryColor : themeConfig.uiPrimaryColor
                    border.width: 2
                    visible: themeConfig.debugAlwaysShowSessionSelector || sessionModel.count > 1

                    property alias model: sessionListView.model
                    property alias index: sessionListView.currentIndex
                    property bool expanded: false

                    Text {
                        id: sessionLabel
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        color: themeConfig.uiTextColor
                        font.pixelSize: 14
                        font.family: themeConfig.uiFont
                        text: sessionListView.currentItem ? sessionListView.currentItem.itemText : ""
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        color: themeConfig.uiTextColor
                        font.pixelSize: 12
                        text: session.expanded ? "▲" : "▼"
                    }

                    MouseArea {
                        id: sessionMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: session.expanded = !session.expanded
                    }

                    Rectangle {
                        id: sessionDropdown
                        anchors.top: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: session.expanded ? Math.min(120, sessionListView.contentHeight) : 0
                        radius: 6
                        color: themeConfig.uiBackgroundColor
                        border.color: themeConfig.uiPrimaryColor
                        border.width: 2
                        clip: true
                        visible: height > 0

                        Behavior on height {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }

                        ListView {
                            id: sessionListView
                            anchors.fill: parent
                            anchors.margins: 2
                            model: sessionModel
                            currentIndex: sessionModel.lastIndex || 0

                            delegate: Rectangle {
                                width: sessionListView.width
                                height: 30
                                color: delegateMouseArea.containsMouse ? Qt.darker(themeConfig.uiPrimaryColor, 1.3) : "transparent"

                                property string itemText: model.name || model.modelData || model

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: themeConfig.uiTextColor
                                    font.pixelSize: 13
                                    font.family: themeConfig.uiFont
                                    text: parent.itemText
                                }

                                MouseArea {
                                    id: delegateMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        sessionListView.currentIndex = index
                                        session.expanded = false
                                    }
                                }
                            }
                        }
                    }

                    Keys.onPressed: function(event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                            expanded = !expanded
                            event.accepted = true
                        } else if (event.key === Qt.Key_Up && sessionListView.currentIndex > 0) {
                            sessionListView.currentIndex--
                            event.accepted = true
                        } else if (event.key === Qt.Key_Down && sessionListView.currentIndex < sessionListView.count - 1) {
                            sessionListView.currentIndex++
                            event.accepted = true
                        }
                    }

                    KeyNavigation.backtab: password
                    KeyNavigation.tab: loginButton
                }

                CustomButton {
                    id: loginButton
                    themeConfig: container.themeConfig
                    text: textConstants.login || "Login"
                    width: 120
                    height: 40

                    onClicked: sddm.login(name.text, password.text, sessionIndex)

                    KeyNavigation.backtab: session
                    KeyNavigation.tab: shutdownButton
                }
            }

            // Error message
            Text {
                id: errorMessage
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#FFB8B8"
                font.pixelSize: 13
                font.family: "Arial"
                wrapMode: Text.WordWrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // Power buttons (bottom right) - Text buttons (default)
    Row {
        id: powerButtons
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 30
        spacing: 15
        visible: !themeConfig.useIconButtons

        opacity: themeConfig.uiAutoHide ? (uiVisible ? 1.0 : 0.0) : 1.0
        Behavior on opacity {
            NumberAnimation {
                duration: enableAnimations ? 800 : 0
                easing.type: Easing.InOutQuad
            }
        }

        CustomButton {
            id: suspendButton
            themeConfig: container.themeConfig
            text: textConstants.suspend || "Sleep"
            width: 80
            height: 35
            visible: themeConfig.actionButtonsAlwaysVisible || sddm.canSuspend
            onClicked: sddm.suspend()

            KeyNavigation.backtab: loginButton
            KeyNavigation.tab: hibernateButton.visible ? hibernateButton : shutdownButton
        }

        CustomButton {
            id: hibernateButton
            themeConfig: container.themeConfig
            text: textConstants.hibernate || "Hibernate"
            width: 90
            height: 35
            visible: themeConfig.actionButtonsAlwaysVisible || sddm.canHibernate
            onClicked: sddm.hibernate()

            KeyNavigation.backtab: suspendButton.visible ? suspendButton : loginButton
            KeyNavigation.tab: shutdownButton
        }

        CustomButton {
            id: shutdownButton
            themeConfig: container.themeConfig
            text: textConstants.shutdown || "Shutdown"
            width: 100
            height: 35
            visible: themeConfig.actionButtonsAlwaysVisible || sddm.canPowerOff
            onClicked: sddm.powerOff()

            KeyNavigation.backtab: hibernateButton.visible ? hibernateButton : (suspendButton.visible ? suspendButton : loginButton)
            KeyNavigation.tab: rebootButton
        }

        CustomButton {
            id: rebootButton
            themeConfig: container.themeConfig
            text: textConstants.reboot || "Reboot"
            width: 80
            height: 35
            visible: themeConfig.actionButtonsAlwaysVisible || sddm.canReboot
            onClicked: sddm.reboot()

            KeyNavigation.backtab: shutdownButton
            KeyNavigation.tab: name
        }
    }

    // Power buttons (bottom right) - Icon buttons (optional)
    Row {
        id: powerIconButtons
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 30
        spacing: 15
        visible: themeConfig.useIconButtons

        opacity: themeConfig.uiAutoHide ? (uiVisible ? 1.0 : 0.0) : 1.0
        Behavior on opacity {
            NumberAnimation {
                duration: enableAnimations ? 800 : 0
                easing.type: Easing.InOutQuad
            }
        }

        Item {
            id: suspendIconButton
            width: 48
            height: 48
            visible: themeConfig.actionButtonsAlwaysVisible || sddm.canSuspend

            property bool hasFocus: suspendIconMouseArea.activeFocus

            Image {
                id: suspendIcon
                anchors.centerIn: parent
                width: 40
                height: 40
                source: "../assets/suspend.svgz"
                smooth: true
                visible: false
            }

            ColorOverlay {
                anchors.fill: suspendIcon
                source: suspendIcon
                color: themeConfig.suspendIconColor
                opacity: suspendIconMouseArea.containsMouse ? 1.0 : 0.8

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            MouseArea {
                id: suspendIconMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    recordActivity()
                    sddm.suspend()
                }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        sddm.suspend()
                        event.accepted = true
                    }
                }

                KeyNavigation.backtab: loginButton
                KeyNavigation.tab: hibernateIconButton.visible ? hibernateIconMouseArea : shutdownIconMouseArea
            }
        }

        Item {
            id: hibernateIconButton
            width: 48
            height: 48
            visible: themeConfig.actionButtonsAlwaysVisible || sddm.canHibernate

            property bool hasFocus: hibernateIconMouseArea.activeFocus

            Image {
                id: hibernateIcon
                anchors.centerIn: parent
                width: 40
                height: 40
                source: "../assets/hibernate.svgz"
                smooth: true
                visible: false
            }

            ColorOverlay {
                anchors.fill: hibernateIcon
                source: hibernateIcon
                color: themeConfig.hibernateIconColor
                opacity: hibernateIconMouseArea.containsMouse ? 1.0 : 0.8

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            MouseArea {
                id: hibernateIconMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    recordActivity()
                    sddm.hibernate()
                }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        sddm.hibernate()
                        event.accepted = true
                    }
                }

                KeyNavigation.backtab: suspendIconButton.visible ? suspendIconMouseArea : loginButton
                KeyNavigation.tab: shutdownIconMouseArea
            }
        }

        Item {
            id: shutdownIconButton
            width: 48
            height: 48
            visible: themeConfig.actionButtonsAlwaysVisible || sddm.canPowerOff

            property bool hasFocus: shutdownIconMouseArea.activeFocus

            Image {
                id: shutdownIcon
                anchors.centerIn: parent
                width: 40
                height: 40
                source: "../assets/shutdown.svgz"
                smooth: true
                visible: false
            }

            ColorOverlay {
                anchors.fill: shutdownIcon
                source: shutdownIcon
                color: themeConfig.shutdownIconColor
                opacity: shutdownIconMouseArea.containsMouse ? 1.0 : 0.8

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            MouseArea {
                id: shutdownIconMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    recordActivity()
                    sddm.powerOff()
                }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        sddm.powerOff()
                        event.accepted = true
                    }
                }

                KeyNavigation.backtab: hibernateIconButton.visible ? hibernateIconMouseArea : (suspendIconButton.visible ? suspendIconMouseArea : loginButton)
                KeyNavigation.tab: rebootIconMouseArea
            }
        }

        Item {
            id: rebootIconButton
            width: 48
            height: 48
            visible: themeConfig.actionButtonsAlwaysVisible || sddm.canReboot

            property bool hasFocus: rebootIconMouseArea.activeFocus

            Image {
                id: rebootIcon
                anchors.centerIn: parent
                width: 40
                height: 40
                source: "../assets/reboot.svgz"
                smooth: true
                visible: false
            }

            ColorOverlay {
                anchors.fill: rebootIcon
                source: rebootIcon
                color: themeConfig.rebootIconColor
                opacity: rebootIconMouseArea.containsMouse ? 1.0 : 0.8

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            MouseArea {
                id: rebootIconMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    recordActivity()
                    sddm.reboot()
                }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        sddm.reboot()
                        event.accepted = true
                    }
                }

                KeyNavigation.backtab: shutdownIconMouseArea
                KeyNavigation.tab: name
            }
        }
    }

    // Settings button (top left)
    Item {
        id: settingsButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30
        width: 48
        height: 48

        opacity: themeConfig.uiAutoHide ? (uiVisible ? 1.0 : 0.0) : 1.0
        Behavior on opacity {
            NumberAnimation {
                duration: enableAnimations ? 800 : 0
                easing.type: Easing.InOutQuad
            }
        }

        Image {
            id: settingsIcon
            anchors.centerIn: parent
            width: 40
            height: 40
            source: "../assets/random.svgz"
            smooth: true
            visible: false
        }

        ColorOverlay {
            anchors.fill: settingsIcon
            source: settingsIcon
            color: themeConfig.iconColor
            opacity: settingsMouseArea.containsMouse ? 1.0 : 0.8

            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
        }

        MouseArea {
            id: settingsMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                recordActivity()
                cycleTheme()
            }

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                    cycleTheme()
                    event.accepted = true
                }
            }
        }
    }

    // Clock (top right)
    Text {
        id: clock
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 30
        color: themeConfig.clockColor
        font.pixelSize: themeConfig.clockFontSize
        font.family: themeConfig.clockFont
        visible: themeConfig.clockEnabled

        opacity: themeConfig.uiAutoHide ? (uiVisible ? 1.0 : 0.0) : 1.0
        Behavior on opacity {
            NumberAnimation {
                duration: enableAnimations ? 800 : 0
                easing.type: Easing.InOutQuad
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: recordActivity()
        }

        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm")
        }

        Timer {
            interval: 1000
            running: themeConfig.clockEnabled
            repeat: true
            onTriggered: clock.updateTime()
        }

        Component.onCompleted: updateTime()
    }

    // Theme attribution (bottom left)
    Item {
        id: themeAttribution
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 30
        width: childrenRect.width
        height: childrenRect.height

        opacity: themeConfig.uiAutoHide ? (uiVisible ? 1.0 : 0.0) : 1.0
        Behavior on opacity {
            NumberAnimation {
                duration: enableAnimations ? 800 : 0
                easing.type: Easing.InOutQuad
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: recordActivity()
        }

        Row {
            spacing: 15

            // Left column: Writer icon
            Item {
                width: 40
                height: 40
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: copyrightIcon
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    source: "../assets/cat.svgz"
                    smooth: true
                    visible: false
                }

                ColorOverlay {
                    anchors.fill: copyrightIcon
                    source: copyrightIcon
                    color: themeConfig.copyrightTextColor
                    opacity: 0.8
                }
            }

            // Right column: Text lines
            Column {
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "Lava Lamp MHL v1.0.0"
                    color: themeConfig.copyrightTextColor
                    font.pixelSize: 18
                    font.bold: true
                    font.family: themeConfig.uiFont
                }

                Text {
                    text: "©2025 Marcin Orlowski"
                    color: themeConfig.copyrightTextColor
                    font.pixelSize: 15
                    font.family: themeConfig.uiFont
                }
            }
        }
    }

    // Initialize when component is ready
    Component.onCompleted: {
        console.log("Screen dimensions:", width, "x", height)
        if (screenModel) {
            console.log("Primary screen index:", screenModel.primary)
            console.log("Number of screens:", screenModel.count)
            for (var i = 0; i < screenModel.count; i++) {
                var geo = screenModel.geometry(i)
                console.log("Screen", i, "geometry:", geo.x, geo.y, geo.width, "x", geo.height)
            }
        } else {
            console.warn("screenModel not available, using fallback dimensions")
        }


        // Set initial UI state based on config
        setInitialUIState()

        // Auto-focus after initial load
        Qt.callLater(focusFirstVisibleFormControl)
    }

    // Virtual keyboard control - manually managed like breeze theme
    InputPanel {
        id: inputPanel
        property bool activated: false
        active: activated && Qt.inputMethod.visible
        visible: active
        width: parent.width
        anchors.bottom: parent.bottom

        states: [
            State {
                name: "visible"
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    opacity: 1
                }
            },
            State {
                name: "hidden"
                when: !inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    opacity: 0
                }
            }
        ]

        transitions: [
            Transition {
                to: "visible"
                OpacityAnimator {
                    duration: 250
                    easing.type: Easing.OutQuad
                }
            },
            Transition {
                to: "hidden"
                OpacityAnimator {
                    duration: 250
                    easing.type: Easing.InQuad
                }
            }
        ]
    }
}  // Main Rectangle closing brace
