# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix  # Include the results of the hardware scan.
      ./stevenblack-hosts.nix
    ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
#  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "room101"; # Define your hostname.
  networking.networkmanager.enable = true;
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  hardware.pulseaudio.package = pkgs.pulseaudioFull; # support for bluetooth headsets
  hardware.bluetooth.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      inconsolata
      fira-mono
      ubuntu_font_family
    ];
  };

  programs.zsh.enable = true;

  nixpkgs.config = {
    allowUnfree = true; # Allow "unfree" packages.

    firefox.enableAdobeFlash = true;
    chromium.enablePepperFlash = true;
  };


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    tree
    wget
    git
    gnupg
    gnupg1
    emacs25
    conkeror
    curl
    chromium
    firefox
    rxvt_unicode-with-plugins
    tmux
    gnumake
    unzip
    aspell
    aspellDicts.en
    aspellDicts.es
    aspellDicts.ca
    imagemagick
    offlineimap
    mu
    youtube-dl
    vlc
    ag
    xclip
    xorg.xbacklight
    lightlocker
    gparted
    uget
    qtox
    gimp
    blueman
    pavucontrol
    pass
    ghostscript
    zuki-themes
    faba-icon-theme
    faba-mono-icons
    wirelesstools

    (texlive.combine {
      inherit (pkgs.texlive) scheme-medium wrapfig ulem capt-of
      enumitem preprint titlesec;
    })

    ruby
    sbcl
    leiningen
    sbt
    go

    openjdk
    nodejs
    watchman

    android-studio
    genymotion
  ];

  environment.variables = { GOROOT = [ "${pkgs.go.out}/share/go" ]; };

  environment.pathsToLink = [
    "/share/xfce4"
    "/share/themes"
    "/share/mime"
    "/share/desktop-directories"
    "/share/gtksourceview-2.0"
  ];

  virtualisation.virtualbox.host.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # battery management
  services.tlp.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,es";
  services.xserver.xkbOptions = "grp:shifts_toggle,ctrl:nocaps";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    # Set GTK_PATH so that GTK+ can find the theme engines.
    export GTK_PATH="${config.system.path}/lib/gtk-2.0:${config.system.path}/lib/gtk-3.0"
    # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
    export GTK_DATA_PREFIX=${config.system.path}
    # SVG loader for pixbuf
    export GDK_PIXBUF_MODULE_FILE=$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)
    # Set XDG menu prefix
    export XDG_MENU_PREFIX="lxde-"
  '';
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      theme.package = pkgs.zuki-themes;
      theme.name = "Zukitre";
    };
  };
  services.xserver.desktopManager.gnome3.enable = true;
  environment.gnome3.excludePackages = with pkgs.gnome3; [
    epiphany
    evolution
    gnome-maps
    gnome-music
    gnome-photos
    gedit
    totem
    gnome-calendar
    gnome-weather
    accerciser
    gnome-software
  ];

  services.xserver.desktopManager.xfce = {
    enable = true;
    thunarPlugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar_volman
    ];

    # "Don't install XFCE desktop components (xfdesktop, panel and notification
    # daemon).";
    # As I'm using stumpwm as a windowmanager, I don't need those
    # xfce components.
    noDesktop = true;
  };

  services.xserver.windowManager.stumpwm.enable = true;

  services.journald.extraConfig = ''
    MaxRetentionSec=4day
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.toni = {
    isNormalUser = true;
    home = "/home/toni";
    description = "Toni Reina";
    extraGroups = ["wheel" "networkmanager" "vboxusers"];
    createHome = true;
    shell = "/run/current-system/sw/bin/zsh";
  };


  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";

}
