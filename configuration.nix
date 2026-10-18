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
  imports = [
    ./hardware-configuration.nix
  ];

  # Forces system evaluations to use the pinned release without needing -I
  nix.nixPath = [
    "nixpkgs=https://github.com/NixOS/nixpkgs/archive/${nixpkgsCommit}.tar.gz"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "reproducible-box";
  time.timeZone = "UTC";

  environment.systemPackages = [
    pinnedPkgs.vim
    pinnedPkgs.git
    pinnedPkgs.htop
    pinnedPkgs.tmux
  ];

  users.users.raed = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = [
      pinnedPkgs.curl
      pinnedPkgs.jq
    ];
  };

  system.stateVersion = "24.05";
}