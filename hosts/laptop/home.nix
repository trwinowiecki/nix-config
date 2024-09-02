{ 
  inputs, 
  outputs, 
  pkgs, 
  pkgsUnstable, 
  lib, 
  user,
  ...
}: {
  imports = [
    outputs.homeManagerModules.default
    ../../modules/home-manager/nixvim
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "taylor";
    homeDirectory = lib.mkDefault "/home/taylor/";
    packages = (with pkgs; [
      discord
      gimp
      inkscape
      kitty
      libreoffice
    ]) ++ (with pkgsUnstable; [
        # neovim
      ]);
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "trwinowiecki";
    userEmail = "trw0511@gmail.com";
  };

  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch";
      update-flake = "sudo nixos-rebuild switch --flake ~/dotfiles/nix-config#hp-nixos; home-manager switch --flake ~/dotfiles/nix-config#taylor";
      ls = "exa -la";
      cat = "bat";
      please = "sudo !!";
    };

    initExtra = ''
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  # Keyboard Shortcuts
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "kitty";
      name = "open-terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "nautilus";
      name = "open-nautilus";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
