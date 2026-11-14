-- Monitor (auto-detect resolution and scale)
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

-- Default programs
local terminal = "kitty"
local menu = "rofi -show drun"
local mainMod = "SUPER"

-- Environment variables (if not using UWSM, keep these; under UWSM, move to ~/.config/uwsm/env)
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Autostart processes (wrapped for UWSM session tracking)
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- waybar")
  hl.exec_cmd("uwsm app -- swaync")
  hl.exec_cmd("uwsm app -- nm-applet --indicator")
  hl.exec_cmd("uwsm app -- swww-daemon")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-- General, Decoration, Input & Misc settings
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col = {
      active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg",
      inactive_border = "rgba(595959aa)",
    },
    layout = "dwindle",
  },
  decoration = {
    rounding = 12,
    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      new_optimizations = true,
      ignore_opacity = true,
      vibrancy = 0.2,
    },
  },
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    touchpad = {
      natural_scroll = true,
    },
  },
  misc = {
    force_default_wallpaper = 1,
    disable_hyprland_logo = false,
  },
})

-- Layer rules (frosted glass blur for Waybar, Rofi, and SwayNC)
hl.layer_rule("blur", "waybar")
hl.layer_rule("ignorezero", "waybar")

hl.layer_rule("blur", "rofi")
hl.layer_rule("ignorezero", "rofi")

hl.layer_rule("blur", "swaync-control-center")
hl.layer_rule("ignorezero", "swaync-control-center")
hl.layer_rule("blur", "swaync-notification-window")
hl.layer_rule("ignorezero", "swaync-notification-window")

-- Core keybinds (using proper XKB keysyms and valid Hyprland dispatcher args)
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(0)) -- 0 = fullscreen, 1 = maximize (toggles automatically)
hl.bind(mainMod .. " + V", hl.dsp.window.float())        -- toggles floating automatically

-- Focus movement
hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-9
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Mouse move & resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.move(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })