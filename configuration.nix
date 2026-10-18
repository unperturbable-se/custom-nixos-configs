{ config, pkgs, ... }:

let
  nixpkgsCommit = "b134951a4c9f3c995fd7be05f3243f8ecd65d798";

  pinnedPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsCommit}.tar.gz";
    sha256 = "0zydsqiaz8qi4zd63zsb2gij2p614cgkcaisnk11wjy3nmiq0x1s";
  }) {
    config = { allowUnfree = true; };
  };
in
{
  imports = [ ./hardware-configuration.nix ];

  nix.nixPath = [
    "nixpkgs=https://github.com/NixOS/nixpkgs/archive/${nixpkgsCommit}.tar.gz"
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  networking.hostName = "reproducible-box";
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pinnedPkgs; [ vim git htop tmux ];

  users.users.raed = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pinnedPkgs; [ curl jq ];
  };

  system.stateVersion = "24.05";
}