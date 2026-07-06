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

  # HP laptop MediaTek MT7921 USB BT (13d3:3567) fails HCI init on 6.12.x
  # (hci0 stuck at 00:00:00:00:00:00, bluetoothctl: no default controller).
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  hardware.enableRedistributableFirmware = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Sensors
  hardware.sensor.iio.enable = true;

  # Power profiles (battery saver / performance in QuickShell battery widget)
  services.power-profiles-daemon.enable = true;

  # Reset stuck MT7921 USB BT before bluetoothd starts (kernel/driver race on boot).
  systemd.services.bluetooth-usb-reset = {
    description = "Reset MediaTek USB Bluetooth if HCI is uninitialized";
    before = [ "bluetooth.service" ];
    after = [ "systemd-modules-load.service" "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      sleep 3
      if ! ${pkgs.usbutils}/bin/lsusb -d 13d3:3567 >/dev/null 2>&1; then
        exit 0
      fi

      needs_reset=0
      if ${pkgs.bluez}/bin/hciconfig hci0 2>/dev/null | grep -q "00:00:00:00:00:00"; then
        needs_reset=1
      elif ${pkgs.bluez}/bin/hciconfig hci0 2>/dev/null | grep -q "DOWN"; then
        needs_reset=1
      elif ! ${pkgs.bluez}/bin/bluetoothctl list 2>/dev/null | grep -q "^Controller"; then
        needs_reset=1
      fi

      if [ "$needs_reset" = "1" ]; then
        ${pkgs.kmod}/bin/modprobe -r btusb || true
        sleep 2
        ${pkgs.kmod}/bin/modprobe btusb
        sleep 2
      fi
    '';
  };

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
