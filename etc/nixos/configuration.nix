# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # AMD GPU
  hardware.graphics = 
  { 
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.opencl.enable = true;
  environment.variables = { ROC_ENABLE_PRE_VEGA = "1"; };

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = 
  {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Auto update
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Bootloader.
  boot.loader = 
  {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Cosmic desktop environment
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
    cosmic-player
    cosmic-reader
    cosmic-wallpapers
  ];

  # CUPS
  services.printing.enable = false;

  # DDC/CI
  hardware.i2c.enable = true;

  # Firewall.
  networking.firewall.enable = false;

  # Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-cosmic ];

  # Fonts
  fonts.packages = with pkgs;
  [
    nerd-fonts.jetbrains-mono
    corefonts
  ];

  # Garbage collector
  nix.gc = 
  {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;

  # GTK and Qt
  programs.dconf = {
    enable = true;
    profiles = {
      user = {
        databases = [
          {
            settings = {
              "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
              };
            };
          }
        ];
      };
    };
  };
  environment.sessionVariables = {
  QT_STYLE_OVERRIDE = "adwaita-dark";
    # for Qt6 specifically if adwaita-dark doesn't apply:
    # QT_QPA_PLATFORMTHEME = "gtk3"; 
  };

  # Hostname
  networking.hostName = "nixos";

  # KDE connect
  programs.kdeconnect.enable = true;
  
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # List packages installed in system profile. To search, run: nix search wget
  environment.systemPackages = with pkgs; 
  [
    android-tools
    brave
    celluloid
    curl
    ddcutil
    fastfetch
    fishPlugins.done
    fishPlugins.forgit
    fishPlugins.fzf-fish
    fishPlugins.grc
    fishPlugins.hydro
    fzf
    git
    grc
    kitty
    lact
    localsend
    nodejs
    obsidian
    onlyoffice-desktopeditors
    opencode
    polkit
    qview
    songrec
    uget
    vscode
    wget
  ];

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Networking
  networking.networkmanager.enable = true;

  # Nixos
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Polkit
  security.polkit.enable = true;

  # Services
  services = 
  {
    lact.enable = true;
  };

  # Time zone.
  time.timeZone = "Asia/Manila";

  # Udev Rules
  services.udev.extraRules = 
  ''
    # MCHOSE Jet75-II Keyboard (Vendor: 41e4, Product: 211a)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="211a", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # VXE R1 (Vendor: 373b, Product: 1085)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="1085", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # User account. Don't forget to set a password with ‘passwd’.
  users.users."czeux" = 
  {
    isNormalUser = true;
    description = "Lhord Czedrick";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "i2c"];
    shell = pkgs.fish;
    packages = with pkgs; 
    [
    #  thunderbird
    ];
  };

  # Zram
  zramSwap = 
  {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
