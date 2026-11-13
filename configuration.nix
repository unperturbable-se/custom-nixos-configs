{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.hostName = "reproducible-box";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Karachi";

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

  # Display Manager (ReGreet + Greetd) & Hyprland
  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Required for screen sharing, GTK theming, and Electron apps
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Audio (Required for Waybar audio controls)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Docker since "docker" is in your user's extraGroups
  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;
  services.openssh.enable = true;

  # Enable Fish if you use your fish dotfiles
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    # Core CLI & Dev
    vim
    git
    htop
    btop
    fastfetch
    tmux
    curl
    jq
    oh-my-posh

    # Apps
    vscodium
    firefox
    kitty
    kdePackages.kate

    # Hyprland & Dotfile Ecosystem
    waybar
    rofi
    swaynotificationcenter
    hyprpaper
    wlogout
    matugen
    wl-clipboard
    grim
    slurp
    networkmanagerapplet
    pavucontrol
    swww
    quickshell
    libnotify
    hyprpolkitagent
  ];

  users.users.raed = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  system.stateVersion = "25.11";
}
