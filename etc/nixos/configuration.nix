# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # AMD GPU
  environment.variables = { ROC_ENABLE_PRE_VEGA = "1"; };
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Audio
  security.rtkit.enable = true;
  services = {
    pulseaudio.enable = false;
    pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
  
  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      consoleMode = "keep";
    };
  };

  # CPU Microcode
  hardware.cpu.intel.updateMicrocode = true;

  # CUPS
  services.printing.webInterface = false;

  # DDC/CI
  hardware.i2c.enable = true;

  # Firewall.
  networking.firewall.enable = false;

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    corefonts
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    unstable.noto-fonts
  ];

  # Hostname
  networking.hostName = "nixos";

  # KDE
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    khelpcenter
    konsole
    ktexteditor
    kwin-x11
    kwrited
    okular
    plasma-browser-integration
    plasma-workspace-wallpapers
    print-manager
    qrca
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # List packages installed in system profile. To search, run: nix search wget
  environment.systemPackages = with pkgs; [
    android-tools
    bottles
    brave
    btop
    curl
    ddcutil
    fastfetch
    fzf
    grc
    haruna
    kitty
    obsidian
    onlyoffice-desktopeditors
    polkit
    protonplus
    qbittorrent
    songrec
    uget
    unstable.nodejs
    unstable.opencode
    unstable.zed-editor-fhs
    wget
    wl-clipboard
    zsh-powerlevel10k
  ];

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Networking
  networking.networkmanager.enable = true;

  # NixOS
  nix.gc = {
    automatic = true;
    dates = "weekly 06:00";
    options = "--delete-older-than 7d";
    persistent = true;
  };
  nix.optimise = {
    automatic = true;
    dates = "weekly 06:00";
    persistent = true;
  };
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # OBS Studio
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-gstreamer
      obs-pipewire-audio-capture
      obs-vaapi # AMD hardware acceleration
      obs-vkcapture
      wlrobs
    ];
  };

  # Polkit
  security.polkit.enable = true;

  # Programs
  programs = {
    gamemode.enable = true;
    git.enable = true;
    kdeconnect.enable = true;
    localsend.enable = true;
    steam.enable = true;
  };

  # Services
  services = {
    lact.enable = true;
  };

  # Time zone.
  time.timeZone = "Asia/Manila";

  # Udev Rules
  services.udev.extraRules = ''
    # MCHOSE Jet75-II Keyboard (Vendor: 41e4, Product: 211a)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="211a", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # VXE R1 Mouse (Vendor: 373b, Product: 1085)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="1085", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # User account
  users.users."czeux" = {
    isNormalUser = true;
    description = "Lhord Czedrick";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "i2c"];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  firefox
    ];
  };

  # Zram
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  # Zsh
  programs.zsh = {
    autosuggestions.enable = true;
    enable = true;
    enableBashCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "fzf"
        "git"
        "z"
      ];
    };
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}