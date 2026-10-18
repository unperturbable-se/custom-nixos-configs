{ config, pkgs, ... }:

let
  nixpkgsCommit = "6314f0840b86e082000877702234c90383163fcd";

  pinnedPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsCommit}.tar.gz";
    sha256 = "1433f443a5043a1a1f0a28f328905a3b2e5917462a6e9742a7872e429188a38a";
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