# Taylor's Home Manager Configuration (Laptop)
#
# Color scheme is set via nix-colors. Override with:
#   colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;
# See: https://github.com/tinted-theming/base16-schemes for options
{ inputs
, outputs
, pkgs
, pkgsUnstable
, lib
, ...
}: {
  # Note: outputs.homeManagerModules.default is already imported by mkHome in myLib

  # Enable features via myHomeManager options
  myHomeManager = {
    kitty.enable = true;              # Themed kitty terminal
    desktop.hyprland.enable = true;   # Hyprland with QuickShell widgets
    matugen.enable = true;            # Dynamic wallpaper-based theming
    zsh.enable = true;                # Enhanced ZSH with plugins
    zsh.promptType = "starship";      # Use Starship prompt
  };

  # nixpkgs.config.allowUnfree is set in myLib/default.nix via mkHome

  # ======================== nix-colors Theme ======================== #
  # Default is gruvbox-dark-medium (set in modules/home-manager/default.nix)
  # Uncomment to use a different scheme:
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;

  # ============================= User Info ========================== #
  home = {
    username = "taylor";
    homeDirectory = lib.mkDefault "/home/taylor/";
    packages =
      (with pkgs; [
        # GUI Apps
        discord
        gimp
        inkscape
        libreoffice
        google-chrome
        vivaldi
        remmina
        makemkv
        galaxy-buds-client

        # Development
        neovim
        lazydocker
        maven
        zulu21  # Java

        # Hardware tools
        vial       # Keyboard configurator
        mouseless  # Mouse-free workflow

        # CLI utilities (from general bundle)
        bat
        eza
        fd
        fzf
        ripgrep
        zoxide
        tmux
        neofetch
        unzip
        wget
        xclip
        gnumake
        tree-sitter
        shfmt
      ])
      ++ (with pkgsUnstable; [
        # 3D/Modeling (from unstable for latest versions)
        prusa-slicer
        freecad
        openscad
        blender

        # Tools
        rpi-imager
        code-cursor
        go
      ]);
  };

  # ========================== Programs ============================== #
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "trwinowiecki";
    userEmail = "trw0511@gmail.com";
  };

  # Host-specific shell aliases (base config from myHomeManager.zsh module)
  programs.zsh.shellAliases = {
    update = "sudo nixos-rebuild switch";
    update-flake = "sudo nixos-rebuild switch --flake ~/dotfiles/nix-config#hp-nixos; home-manager switch --flake ~/dotfiles/nix-config#taylor";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}
