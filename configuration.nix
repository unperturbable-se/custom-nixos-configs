{ config, pkgs, ... }:

let
  nixpkgsCommit = "ac588ef1c914";

  pinnedPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsCommit}.tar.gz";
    sha256 = "1sxd2sqlpy1bx6b5xiwy1pbyygazl9d1a5yy0rvqfsihqpcibq2y";
  }) {
    config = { allowUnfree = true; };
  };
in
{
  imports = [ ./hardware-configuration.nix ];

  nix.nixPath = [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=https://github.com/NixOS/nixpkgs/archive/${nixpkgsCommit}.tar.gz"
  ];

  boot.loader.grub = {
  enable = true;
  devices = [ "/dev/vda" ]; # Changed from 'device' to 'devices' list

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
};

  networking.hostName = "reproducible-box";
  networking.networkmanager.enable = true;
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.openssh.enable = true;

  environment.systemPackages = with pinnedPkgs; [ vim git htop tmux vscode firefox     kitty rofi waybar dunst hyprpaper];

  users.users.raed = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" "docker" ];
  packages = with pinnedPkgs; [ curl jq ];
};

  system.stateVersion = "24.05";
}
