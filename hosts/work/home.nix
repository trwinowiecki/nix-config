# Taylor's Home Manager Configuration (Work)
#
# This is a home-manager only config (no NixOS) for the work machine.
#
# Color scheme is set via nix-colors. Override with:
#   colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;
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
    desktop.gnome.enable = true;      # GNOME keybindings and theming
    zsh.enable = true;                # Enhanced ZSH with plugins
    # zsh.promptType = "starship";    # Uncomment to use Starship instead of powerlevel10k
  };

  # nixpkgs.config.allowUnfree is set in myLib/default.nix via mkHome

  # ============================= User Info ========================== #
  home = {
    username = "jzl3lr";
    homeDirectory = lib.mkDefault "/home/jzl3lr/";
    packages =
      (with pkgs; [
        # GUI Apps
        gimp
        inkscape
        vscode

        # Work apps
        microsoft-edge
        slack
        teams-for-linux  # Community wrapper since native Teams was discontinued on Linux

        # Development
        cargo
        clang
        docker
        eslint_d
        git
        postgresql
        nodejs
        prettierd
        stylua
        vim
        yarn
        python3
        zulu21  # Java
        lazygit

        # CLI utilities
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
        zsh

        # Fun
        lolcat

        # MISC
        # Note: home-manager is provided by programs.home-manager.enable = true
      ])
      ++ (with pkgsUnstable; [
        neovim
      ]);
  };

  # ========================== Programs ============================== #
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Taylor Winowiecki";
    userEmail = "taylor.winowiecki@gm.com";
  };

  # Host-specific shell aliases (base config from myHomeManager.zsh module)
  programs.zsh.shellAliases = {
    update-flake = "home-manager switch --flake ~/dotfiles/nix-config#jzl3lr";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
