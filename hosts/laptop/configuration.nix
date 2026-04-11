{ inputs
, outputs
, lib
, config
, pkgs
, myLib
, ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  myNixOS = {
    canon-printer.enable = true;
    desktop.hyprland.enable = true;  # Toggleable: gnome, kde, hyprland, niri
  };

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "hp-nixos";

  users.users = {
    taylor = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      description = "Taylor Schwick";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
        firefox
        iio-sensor-proxy
      ];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth  = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Sensors
  hardware.sensor.iio.enable = true;

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Coding
    cargo
    clang
    docker
    eslint_d
    git
    lazygit
    # neovim
    nodejs
    prettierd
    stylua
    supabase-cli
    vim
    yarn
    python3
    zulu21 # java

    # nvim Tools
    fd
    fzf
    ripgrep
    shfmt
    tree-sitter

    # CLI Tools
    bat
    eza
    neofetch
    stow
    tmux
    unzip
    wget
    xclip
    zoxide
    zsh
    gnumake

    # MISC
    home-manager
    gtk-engine-murrine
    xdg-utils
    quickemu
    solaar
    immersed
  ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # Vial required rule
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess"
  '';

  services.flatpak.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
