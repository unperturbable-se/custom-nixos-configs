{ config, pkgs, ... }:

{
  home.username = "raed";
  home.homeDirectory = "/home/raed";
  home.stateVersion = "25.11";

  # Link entire directories from ./dots to ~/.config/
  xdg.configFile = {
    "btop".source = ./dots/btop;
    "fastfetch".source = ./dots/fastfetch;
    "fish".source = ./dots/fish;
    "gtk-3.0".source = ./dots/gtk-3.0;
    "gtk-4.0".source = ./dots/gtk-4.0;
    "hypr".source = ./dots/hypr;
    "kitty".source = ./dots/kitty;
    "matugen".source = ./dots/matugen;
    "ml4w".source = ./dots/ml4w;
    "ml4w-dotfiles-settings".source = ./dots/ml4w-dotfiles-settings;
    "ohmyposh".source = ./dots/ohmyposh;
    "qt6ct".source = ./dots/qt6ct;
    "quickshell".source = ./dots/quickshell;
    "rofi".source = ./dots/rofi;
    "swaync".source = ./dots/swaync;
    "walker".source = ./dots/walker;
    "waybar".source = ./dots/waybar;
    "wlogout".source = ./dots/wlogout;
    "xsettingsd".source = ./dots/xsettingsd;
  };

  # Individual standalone files or loose dotfiles in home directory
  home.file = {
    ".bashrc".source = ./dots/bashrc/30-autostart; # Or map your bashrc structure accordingly
    ".zshrc".source = ./dots/zshrc/30-autostart;
    ".config/chromium-flags.conf".source = ./dots/chromium-flags.conf;
    ".config/edge-flags.conf".source = ./dots/edge-flags.conf;
  };

  programs.home-manager.enable = true;
}
