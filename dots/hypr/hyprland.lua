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

-- Environment variables
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("NIXOS_OZONE_WL", "1")

-- Autostart processes
hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("swaync")
  hl.exec_cmd("nm-applet --indicator")
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
    rounding = 8,
  },
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    touchpad = {
      natural_scroll = true,
    },
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})

-- Core keybinds
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Focus movement
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-9 (generated via Lua loop)
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Mouse move & resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.move(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
