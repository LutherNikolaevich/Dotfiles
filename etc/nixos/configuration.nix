# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # AMD GPU
  hardware.graphics = 
  { 
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.opencl.enable = true;
  environment.variables = { ROC_ENABLE_PRE_VEGA = "1"; };

  # Bootloader.
  boot.loader = 
  {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Hostname
  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = 
  {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services = 
  {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Gnome
  environment.gnome.excludePackages = with pkgs;
  [
    gnome-tour
    gnome-weather
    gnome-contacts
    gnome-maps
    gnome-connections
    gnome-logs
    gnome-music
    gnome-console
    gnome-user-docs
    gnome-software
    epiphany
    evince
    simple-scan
    snapshot
    seahorse
    yelp
    decibels
    showtime
  ];

  # Debloat
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Configure keymap in X11
  services.xserver.xkb = 
  {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = 
  {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."czeux" = 
  {
    isNormalUser = true;
    description = "Lhord Czedrick";
    extraGroups = [ "networkmanager" "wheel" "video" "render" ];
    shell = pkgs.zsh;
    packages = with pkgs; 
    [
    #  thunderbird
    ];
  };

  # Zsh
  programs.zsh = 
  {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [ "HIST_IGNORE_ALL_DUPS" ];
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
    ohMyZsh = 
    {
      enable = true;
      plugins = [ "git" ];
    };
  };  

  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; 
  [
    wget
    neovim
    brave
    kitty
    onlyoffice-desktopeditors
    uget
    songrec
    mission-center
    lact
    warehouse
    vscode
    gnomeExtensions.blur-my-shell
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.gsconnect
    opencode
    git
    curl
    zsh-powerlevel10k
    fastfetch
    android-tools
    nodejs
    localsend
    obs-studio
    celluloid
    recordbox
  ];

  # Garbage collector
  nix.gc = 
  {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;

  # Zram
  zramSwap = 
  {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  # Udev Rules
  services.udev.extraRules = 
  ''
    # MCHOSE Jet75-II Keyboard (Vendor: 41e4, Product: 211a)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="211a", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # VXE R1 (Vendor: 373b, Product: 1085)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="1085", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # Fonts
  fonts.packages = with pkgs;
  [
    nerd-fonts.jetbrains-mono
    corefonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services = 
  {
    flatpak.enable = true;
    lact.enable = true;
  };

  # Open ports in the firewall.
  networking.firewall = 
  {
    enable = true;
    allowedTCPPorts = 
    [
      1714 1715 1716 1717 1718 1719 1720 1721 1722 1723 1724
      1725 1726 1727 1728 1729 1730 1731 1732 1733 1734 1735
      1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746
      1747 1748 1749 1750 1751 1752 1753 1754 1755 1756 1757
      1758 1759 1760 1761 1762 1763 1764
    ];
    allowedUDPPorts = 
    [
      1714 1715 1716 1717 1718 1719 1720 1721 1722 1723 1724
      1725 1726 1727 1728 1729 1730 1731 1732 1733 1734 1735
      1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746
      1747 1748 1749 1750 1751 1752 1753 1754 1755 1756 1757
      1758 1759 1760 1761 1762 1763 1764
    ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
