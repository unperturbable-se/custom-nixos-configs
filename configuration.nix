{ config, pkgs, ... }:

let
  nixpkgsCommit = "b134951a4c9f3c995fd7be05f3243f8ecd65d798";

  pinnedPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsCommit}.tar.gz";
    sha256 = "854a570860e89c1d649aa9f395f9a699e6d99ecd9829a7a0c1a27e5157b243ba";
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