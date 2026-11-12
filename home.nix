{ config, pkgs, lib, ... }:

let
  dotsPath = "/etc/nixos/dots";
in
{
  home.username = "raed";
  home.homeDirectory = "/home/raed";
  home.stateVersion = "25.11";

  xdg.configFile = lib.mapAttrs
    (name: type: {
      source = "${dotsPath}/${name}";
      recursive = type == "directory";
      force = true;
    })
    (builtins.readDir dotsPath);

  programs.home-manager.enable = true;
}
