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
  networking.networkmanager.enable = true;
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.openssh.enable = true;

  environment.systemPackages = with pinnedPkgs; [
  vim git htop tmux
  wget curl jq ripgrep fd tree unzip file rsync
  btop fastfetch lsof pciutils usbutils
  gcc gnumake gdb python3
  firefox
  vscode uv openssh
  fzf bat eza zoxide
  nmap tcpdump dig traceroute
  strace ltrace valgrind
  nodejs rustup go
  docker-compose
  p7zip zip
  neovim
];

virtualisation.docker.enable = true;
users.users.raed.extraGroups = [ "wheel" "networkmanager" "docker" ];

  system.stateVersion = "24.05";
}