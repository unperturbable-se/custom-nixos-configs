{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Allow unfree packages (proprietary software, drivers, etc.)
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.hostName = "reproducible-box";
  networking.networkmanager.enable = true;
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ur_PK";
    LC_IDENTIFICATION = "ur_PK";
    LC_MEASUREMENT = "ur_PK";
    LC_MONETARY = "ur_PK";
    LC_NAME = "ur_PK";
    LC_NUMERIC = "ur_PK";
    LC_PAPER = "ur_PK";
    LC_TELEPHONE = "ur_PK";
    LC_TIME = "ur_PK";
  };
  # Enable Windowing & Display Manager
  services.xserver.enable = true;
  programs.hyprland.enable = true;
  programs.nix-ld.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    tmux
    vscodium
    firefox
    kitty
    rofi
    waybar
    dunst
    hyprpaper
  ];

  users.users.raed = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = with pkgs; [ curl jq ];
  };

  system.stateVersion = "25.11";
}
