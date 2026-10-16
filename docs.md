# Noridoc: hypr

Path: @/hypr

### Overview
- Central configuration directory for Hyprland compositor (version 0.56.2+).
- Uses Hyprland's native Lua configuration API (`hyprland.lua`) instead of legacy `hyprlang`.
- Structured around a modular domain architecture under `conf/` orchestrated by a root loader.
- Hosts automated test verification suites under `tests/` validating module hierarchy, live compositor animation states, keyboard layouts, and system font topology.

### How it fits into the larger codebase
- Serves as the primary window manager and Wayland compositor orchestrator for the desktop environment.
- Autostarts hyprpaper (`~/.config/hypr/hyprpaper.conf`) for desktop wallpaper management and coordinates with Quickshell top bar / Dynamic Island (`~/.config/quickshell/shell.qml`) via `hl.on("hyprland.start", ...)`.
- Integrates with the Vicinae application launcher daemon (`vicinae server`), invoking `vicinae toggle` via global keybindings.
- Directs audio and media keys to PipeWire/WirePlumber (`wpctl`) and MPRIS (`playerctl`).
- Coordinates system-wide typography (`SF Pro Display`) across Fontconfig, GTK-3, GTK-4, GSettings, KDE/Qt, and Quickshell.

### Core Implementation
- Root Orchestrator: `hyprland.lua` configures dynamic `package.path` resolution for submodules, establishes baseline environment variables (`XCURSOR_SIZE`, `HYPRCURSOR_SIZE`, Wayland backend flags), and synchronously imports domain modules.
- Modular Domain Architecture: System configuration is decoupled into specialized modules under `conf/`:
  - Display & Topology: Monitor resolutions, scaling, refresh rates, and positioning (`monitor`).
  - Window & Layout Rules: General window properties, dwindle tiling mechanics, and split controls (`window`, `layout`).
  - Aesthetics & Theming: Window rounding, active/inactive opacity, drop shadows, and active/inactive gradient border tokens (`decoration`).
  - Compositor Animation Engine: Native high-velocity bezier curves and snappy leaf transitions (`animations`).
  - Input Handling: Hardware device sensitivity, touchpad gestures, and Brazilian ABNT-2 layout configuration (`input`).
  - Process Lifecycles: Startup orchestrations for background services, IPC daemons, and desktop components (`autostart`).
  - Keybindings & Modals: Global shortcuts, directional navigation, window dispatchers, and interactive submaps (`keybinding`).
  - Window Rules: Application-specific floating rules, dialog centering, and Wayland/XWayland protocol fixups (`windowrule`).
- Animation System: Top-level `hl.curve` definitions register explosive deceleration profiles (`easeOutExpo`, `easeOutQuart`, `almostLinear`). Transitions use snappy timing thresholds (1.5 to 2.8 deciseconds); windows open with `popin 85%` and dismiss quickly at 1.5 ds, while workspace switching uses `slidefade 20%` to preserve spatial continuity without peripheral disorientation. Continuous border rotation (`borderangle`) is disabled to eliminate idle GPU wakeups.
- Color Tokens: Gradients in Lua must be declared in table form under `col`: `col = { active_border = { colors = { "...", "..." }, angle = 45 }, inactive_border = "..." }`. Border and shadow tokens are aligned with Quickshell's Light (Catppuccin Latte) palette (active border gradient `rgba(8839efee)` Mauve + `rgba(7287fdee)` Lavender, inactive border `rgba(ccd0daaa)` slate, and ambient drop shadow `rgba(4c4f6926)`) complementing the white desktop background.
- System Typography: `SF Pro Display` is established as the primary sans-serif and UI font across:
  - Fontconfig (`~/.config/fontconfig/fonts.conf` prefer rules for `sans-serif` and `system-ui`).
  - GSettings (`org.gnome.desktop.interface font-name` and `document-font-name`).
  - GTK 3.0 & 4.0 (`~/.config/gtk-3.0/settings.ini` and `~/.config/gtk-4.0/settings.ini`).
  - KDE / Qt (`~/.config/kdeglobals`).
  - Quickshell (`~/.config/quickshell/Theme/Theme.qml`).
- Navigation & Window Management: Vim keys (`H/J/K/L`) and arrow keys for focus and directional movement; dwindle tiling layout with split toggling.
- Scratchpad: Special workspace `magic` toggled via `SUPER + S` and populated via `SUPER + SHIFT + S`.
- Submaps: Interactive modal resize submap (`SUPER + R`) reset via `Escape` or `Return`.
- Testing & Verification:
  - `tests/verify_hyprland_config.sh`: Validates modular directory structure, module resolution via `package.path`, compositor syntax and error state (`hyprctl configerrors`), live animation curves and override speeds (`hyprctl animations`), keybind mappings, and daemon availability.
  - `tests/verify_font_config.sh`: Validates system-wide font resolution and toolkit bindings for `SF Pro Display`.

### Things to Know
- Hyprland 0.56.2 requires native Lua declarations using the `hl.*` API (`hl.config`, `hl.bind`, `hl.dsp`, `hl.window_rule`, `hl.curve`, `hl.animation`).
- Animation Declarations: Hyprland Lua ignores animation definitions nested inside `hl.config({ animations = { ... } })` except for the master `enabled = true` switch. Custom beziers and leaf animations must be registered via dedicated `hl.curve()` and `hl.animation()` functions. Speed values are expressed in deciseconds (1 ds = 100 ms).
- Module Resolution: Lua requires an explicit `package.path` setup at the top of the entrypoint file to reliably resolve local submodules (`conf.*`) regardless of the execution working directory.
- `hl.bind` expects `hl.bind(keys_str, dispatcher_func, [flags])`. Modifier keys must be concatenated into the single `keys_str` (e.g. `"Print"`, `"CTRL + Print"`), not passed as separate arguments.
- `pseudotile` is not a config table key under `dwindle` in Hyprland 0.56.2; it is controlled dynamically via `hl.dsp.window.pseudo()`.
- Keyboard layout `br` with model `abnt2` maps standard Brazilian keys (including `ç`, accented dead keys, and AltGr secondary keys).
- Continuous looping animations (like `borderangle`) trigger constant redraw cycles; keeping them disabled prevents unnecessary GPU utilization and battery drain.
- Vicinae is installed at `~/.local/bin/vicinae` (AppImage wrapper) and managed as a systemd user service (`vicinae.service`).

Created and maintained by Nori.
