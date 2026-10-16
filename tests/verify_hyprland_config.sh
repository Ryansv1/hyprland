#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="/home/ryansv/.config/hypr"
CONFIG_FILE="$CONFIG_DIR/hyprland.lua"
CONF_DIR="$CONFIG_DIR/conf"
FAILURES=0

red() { echo -e "\033[31m[FAIL]\033[0m $*"; FAILURES=$((FAILURES + 1)); }
green() { echo -e "\033[32m[PASS]\033[0m $*"; }

echo "=== Hyprland Modular Architecture & Animation Verification Suite ==="

# 1. Modular Directory and Files Existence
if [ -d "$CONF_DIR" ]; then
    green "Specialized conf/ directory exists ($CONF_DIR)"
else
    red "Missing specialized conf/ directory ($CONF_DIR)"
fi

REQUIRED_MODULES=(
    "animations.lua"
    "autostart.lua"
    "decoration.lua"
    "input.lua"
    "keybinding.lua"
    "layout.lua"
    "monitor.lua"
    "window.lua"
    "windowrule.lua"
)

for mod in "${REQUIRED_MODULES[@]}"; do
    if [ -f "$CONF_DIR/$mod" ]; then
        green "Module exists: conf/$mod"
    else
        red "Missing required module: conf/$mod"
    fi
done

# 2. Check root hyprland.lua configuration and require statements
if [ -f "$CONFIG_FILE" ]; then
    green "Root configuration file exists ($CONFIG_FILE)"
else
    red "Missing root configuration file ($CONFIG_FILE)"
fi

if grep -q "package\.path" "$CONFIG_FILE" 2>/dev/null; then
    green "package.path configured in root hyprland.lua"
else
    red "package.path NOT configured in root hyprland.lua"
fi

for mod in "${REQUIRED_MODULES[@]}"; do
    mod_name="${mod%.lua}"
    if grep -E "require\([\"'](conf\.)?${mod_name}[\"']\)" "$CONFIG_FILE" >/dev/null 2>&1; then
        green "hyprland.lua requires conf.$mod_name"
    else
        red "hyprland.lua missing require for conf.$mod_name"
    fi
done

# 3. Compositor Runtime Syntax and Errors
if command -v hyprctl >/dev/null 2>&1; then
    CONFIG_ERRORS=$(hyprctl configerrors 2>&1 || true)
    if [ -n "$CONFIG_ERRORS" ] && [ "$CONFIG_ERRORS" != "ok" ]; then
        red "hyprctl reported config errors:\n$CONFIG_ERRORS"
    else
        green "hyprctl reported 0 config errors"
    fi
fi

# 4. Live Animation Verification (Confirming overrides & snappy speeds)
if command -v hyprctl >/dev/null 2>&1; then
    ANIM_OUTPUT=$(hyprctl animations 2>&1 || true)

    if echo "$ANIM_OUTPUT" | grep -q "easeOutExpo"; then
        green "Bezier curve 'easeOutExpo' registered in Hyprland"
    else
        red "Bezier curve 'easeOutExpo' missing in Hyprland"
    fi

    # Check windowsIn is overridden with fast speed (<= 3.0 ds)
    WIN_IN_INFO=$(echo "$ANIM_OUTPUT" | grep -A 5 "windowsIn" || true)
    if echo "$WIN_IN_INFO" | grep -q "overridden: 1"; then
        green "windowsIn animation is actively overridden"
        WIN_IN_SPEED=$(echo "$WIN_IN_INFO" | grep -o "speed: [0-9.]*" | awk '{print $2}' || true)
        if [ -n "$WIN_IN_SPEED" ] && (( $(echo "$WIN_IN_SPEED <= 3.0" | bc -l) )); then
            green "windowsIn speed is snappy: ${WIN_IN_SPEED}ds (<= 3.0ds)"
        else
            red "windowsIn speed is too slow: ${WIN_IN_SPEED:-none}"
        fi
    else
        red "windowsIn animation is NOT overridden (running slow defaults)"
    fi

    # Check windowsOut is overridden with fast speed (<= 2.0 ds)
    WIN_OUT_INFO=$(echo "$ANIM_OUTPUT" | grep -A 5 "windowsOut" || true)
    if echo "$WIN_OUT_INFO" | grep -q "overridden: 1"; then
        green "windowsOut animation is actively overridden"
        WIN_OUT_SPEED=$(echo "$WIN_OUT_INFO" | grep -o "speed: [0-9.]*" | awk '{print $2}' || true)
        if [ -n "$WIN_OUT_SPEED" ] && (( $(echo "$WIN_OUT_SPEED <= 2.0" | bc -l) )); then
            green "windowsOut speed is snappy: ${WIN_OUT_SPEED}ds (<= 2.0ds)"
        else
            red "windowsOut speed is too slow: ${WIN_OUT_SPEED:-none}"
        fi
    else
        red "windowsOut animation is NOT overridden"
    fi

    # Check workspaces animation is overridden with snappy speed (<= 3.0 ds)
    WS_INFO=$(echo "$ANIM_OUTPUT" | grep -A 5 "workspaces" | head -n 6 || true)
    if echo "$WS_INFO" | grep -q "overridden: 1"; then
        green "workspaces animation is actively overridden"
        WS_SPEED=$(echo "$WS_INFO" | grep -o "speed: [0-9.]*" | awk '{print $2}' || true)
        if [ -n "$WS_SPEED" ] && (( $(echo "$WS_SPEED <= 3.0" | bc -l) )); then
            green "workspaces speed is snappy: ${WS_SPEED}ds (<= 3.0ds)"
        else
            red "workspaces speed is too slow: ${WS_SPEED:-none}"
        fi
    else
        red "workspaces animation is NOT overridden"
    fi
fi

# 5. Application Launchers & Autostart
if command -v vicinae >/dev/null 2>&1; then
    green "vicinae launcher binary is found in PATH ($(which vicinae))"
else
    red "vicinae launcher binary is NOT found in PATH"
fi

AUTOSTART_TARGET="$CONF_DIR/autostart.lua"
if [ -f "$AUTOSTART_TARGET" ]; then
    if grep -q "hl\.exec_cmd(.*quickshell" "$AUTOSTART_TARGET"; then
        green "quickshell autostart configured in autostart.lua"
    else
        red "quickshell autostart missing in autostart.lua"
    fi

    if grep -q "hl\.exec_cmd(.*vicinae server" "$AUTOSTART_TARGET"; then
        green "vicinae server autostart configured in autostart.lua"
    else
        red "vicinae server autostart missing in autostart.lua"
    fi
else
    red "Missing autostart.lua file for autostart verification"
fi

# 6. Keybindings Verification in conf/keybinding.lua
KEYBIND_TARGET="$CONF_DIR/keybinding.lua"
if [ -f "$KEYBIND_TARGET" ]; then
    if grep -E 'hl\.bind\(.*(SUPER|\+).*(vicinae toggle|menu)' "$KEYBIND_TARGET" >/dev/null && \
       grep -E '("vicinae toggle"|vicinae toggle)' "$KEYBIND_TARGET" >/dev/null; then
        green "vicinae toggle keybinding configured in keybinding.lua"
    else
        red "vicinae toggle keybinding missing in keybinding.lua"
    fi

    VIM_NAV_OK=true
    for key in h j k l; do
        if ! grep -iE "hl\.bind\(.*mainMod \.\. \" \+ $key\".*focus" "$KEYBIND_TARGET" >/dev/null; then
            VIM_NAV_OK=false
            break
        fi
    done
    if [ "$VIM_NAV_OK" = true ]; then
        green "Vim directional focus bindings (H, J, K, L) configured in keybinding.lua"
    else
        red "Vim directional focus bindings missing in keybinding.lua"
    fi

    VIM_MOVE_OK=true
    for key in h j k l; do
        if ! grep -iE "hl\.bind\(.*mainMod \.\. \" \+ SHIFT \+ $key\"" "$KEYBIND_TARGET" >/dev/null; then
            VIM_MOVE_OK=false
            break
        fi
    done
    if [ "$VIM_MOVE_OK" = true ]; then
        green "Vim window movement bindings (SHIFT + H, J, K, L) configured in keybinding.lua"
    else
        red "Vim window movement bindings missing in keybinding.lua"
    fi

    if grep -E "hl\.bind\(.*mainMod \.\. \" \+ S\".*toggle_special" "$KEYBIND_TARGET" >/dev/null && \
       grep -E "hl\.bind\(.*mainMod \.\. \" \+ SHIFT \+ S\".*special" "$KEYBIND_TARGET" >/dev/null; then
        green "Scratchpad / special workspace bindings configured in keybinding.lua"
    else
        red "Scratchpad / special workspace bindings missing in keybinding.lua"
    fi

    if grep -E "grim.*slurp.*wl-copy" "$KEYBIND_TARGET" >/dev/null; then
        green "Screenshot area-to-clipboard binding configured in keybinding.lua"
    else
        red "Screenshot area-to-clipboard binding missing in keybinding.lua"
    fi

    if grep -q 'hl\.define_submap("resize"' "$KEYBIND_TARGET" && \
       grep -q 'hl\.dsp\.submap("reset")' "$KEYBIND_TARGET"; then
        green "Interactive resize submap configured in keybinding.lua"
    else
        red "Interactive resize submap missing in keybinding.lua"
    fi
else
    red "Missing keybinding.lua file for keybindings verification"
fi

# 7. Keyboard Layout in conf/input.lua
INPUT_TARGET="$CONF_DIR/input.lua"
if [ -f "$INPUT_TARGET" ]; then
    if grep -q 'kb_layout\s*=\s*"br"' "$INPUT_TARGET"; then
        green "Keyboard layout is configured to 'br' (ABNT-2) in input.lua"
    else
        red "Keyboard layout is NOT configured to 'br' in input.lua"
    fi
else
    red "Missing input.lua file for input verification"
fi

# 8. Window Rules in conf/windowrule.lua
RULE_TARGET="$CONF_DIR/windowrule.lua"
if [ -f "$RULE_TARGET" ]; then
    if grep -q "suppress-maximize-events" "$RULE_TARGET" && \
       grep -q "fix-xwayland-drags" "$RULE_TARGET" && \
       grep -q "vicinae-floating" "$RULE_TARGET"; then
        green "Window rules configured in windowrule.lua"
    else
        red "Missing essential window rules in windowrule.lua"
    fi
else
    red "Missing windowrule.lua file for windowrule verification"
fi

echo "======================================================="
if [ $FAILURES -eq 0 ]; then
    echo -e "\033[32mAll verification tests passed successfully!\033[0m"
    exit 0
else
    echo -e "\033[31m$FAILURES verification test(s) failed.\033[0m"
    exit 1
fi
