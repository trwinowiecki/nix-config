# General bundle - common CLI tools and utilities
# Enable with: myHomeManager.bundles.general.enable = true
{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI utilities
    bat          # Better cat
    eza          # Better ls (maintained fork of exa)
    fd           # Better find
    fzf          # Fuzzy finder
    ripgrep      # Better grep
    zoxide       # Smart cd
    tmux         # Terminal multiplexer
    neofetch     # System info
    unzip
    wget
    xclip

    # Development tools
    gnumake
    tree-sitter
    shfmt
  ];
}
