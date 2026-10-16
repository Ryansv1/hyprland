#!/usr/bin/env bash
set -euo pipefail

FAILURES=0

red() { echo -e "\033[31m[FAIL]\033[0m $*"; FAILURES=$((FAILURES + 1)); }
green() { echo -e "\033[32m[PASS]\033[0m $*"; }

echo "=== System Font Verification Suite: SF Pro Display ==="

# 1. Verify font exists in fontconfig cache
if fc-list "SF Pro Display" | grep -q .; then
    green "Font 'SF Pro Display' is registered in fontconfig"
else
    red "Font 'SF Pro Display' is NOT found in fontconfig cache"
fi

# 2. Verify sans-serif alias in fontconfig resolves to SF Pro Display
SANS_MATCH=$(fc-match sans-serif | awk -F'"' '{print $2}')
if [ "$SANS_MATCH" = "SF Pro Display" ]; then
    green "Default 'sans-serif' resolves to '$SANS_MATCH'"
else
    red "Default 'sans-serif' resolves to '$SANS_MATCH' instead of 'SF Pro Display'"
fi

# 3. Check GSettings font-name
GSETTINGS_FONT=$(gsettings get org.gnome.desktop.interface font-name 2>/dev/null || echo "")
if [[ "$GSETTINGS_FONT" == *"SF Pro Display"* ]]; then
    green "GSettings font-name is configured ($GSETTINGS_FONT)"
else
    red "GSettings font-name is NOT set to SF Pro Display (currently: '$GSETTINGS_FONT')"
fi

# 4. Check GTK-3.0 settings.ini
if grep -q "gtk-font-name=SF Pro Display" /home/ryansv/.config/gtk-3.0/settings.ini 2>/dev/null; then
    green "GTK-3.0 font configured to SF Pro Display"
else
    red "GTK-3.0 settings.ini missing SF Pro Display font"
fi

# 5. Check GTK-4.0 settings.ini
if grep -q "gtk-font-name=SF Pro Display" /home/ryansv/.config/gtk-4.0/settings.ini 2>/dev/null; then
    green "GTK-4.0 font configured to SF Pro Display"
else
    red "GTK-4.0 settings.ini missing SF Pro Display font"
fi

# 6. Check kdeglobals
if grep -q "^font=SF Pro Display" /home/ryansv/.config/kdeglobals 2>/dev/null; then
    green "KDE/Qt kdeglobals font configured to SF Pro Display"
else
    red "KDE/Qt kdeglobals missing SF Pro Display font"
fi

# 7. Check Quickshell Theme.qml
if grep -q "SF Pro Display" /home/ryansv/.config/quickshell/Theme/Theme.qml 2>/dev/null; then
    green "Quickshell Theme.qml configured with SF Pro Display"
else
    red "Quickshell Theme.qml missing SF Pro Display in fontFamily"
fi

echo "======================================================="
if [ $FAILURES -eq 0 ]; then
    echo -e "\033[32mAll font verification tests passed!\033[0m"
    exit 0
else
    echo -e "\033[31m$FAILURES font test(s) failed.\033[0m"
    exit 1
fi
