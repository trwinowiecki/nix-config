# Git configuration feature
# Enable with: myHomeManager.git.enable = true;
#
# This provides a basic git setup. For custom user/email,
# configure programs.git directly in your home.nix.
{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  programs.lazygit.enable = true;
}
