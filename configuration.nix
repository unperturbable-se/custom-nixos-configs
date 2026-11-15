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
  networking.networkmanager = {
  enable = true;
  wifi.backend = "iwd";
  };
  networking.wireless.enable = false;
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

  # Fonts (Registered properly via fontconfig for ReGreet, Waybar, & Urdu support)
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

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
  programs.hyprlock.enable=true;
  # Required for screen sharing, GTK theming, and Electron apps
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  # Audio (Required for Waybar audio controls)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nm-applet = {
  enable = true;
  indicator = true;
  };
  services.openssh.enable = true;

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
    uv
    gcc
    python314
    cmake
    gnumake
    ninja
       
    # Audio & Wayland Qt Support
    wireplumber
    qt5.qtwayland
    qt6.qtwayland

    # Apps
    vscodium
    zed-editor
    google-chrome
    keepassxc
    firefox
    kitty
    kdePackages.kate
    vlc
    imv
    libreoffice
    joplin-desktop
    kdePackages.dolphin
    kdePackages.kio-extras
    kdePackages.kdegraphics-thumbnailers
    kdePackages.breeze-icons
    kdePackages.kdenlive

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
    awww
    quickshell
    libnotify
    hyprpolkitagent
    papirus-icon-theme
    hyprlock
    hyprlandPlugins.hyprbars
    libdbusmenu-gtk3
    libappindicator-gtk3
    iwgtk
  ];

  users.users.raed = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  system.stateVersion = "25.11";
}
