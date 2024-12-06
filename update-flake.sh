#! /bin/bash

if [ $0 ]; then

echo sudo nixos-rebuild switch --flake ~/dotfiles/nix-config#hp-nixos --show-trace
sudo nixos-rebuild switch --flake ~/dotfiles/nix-config#hp-nixos --show-trace

echo home-manager switch --flake ~/dotfiles/nix-config#taylor --show-trace
home-manager switch --flake ~/dotfiles/nix-config#taylor --show-trace

else

echo sudo nixos-rebuild switch --flake ~/dotfiles/nix-config#hp-nixos;
sudo nixos-rebuild switch --flake ~/dotfiles/nix-config#hp-nixos;

echo home-manager switch --flake ~/dotfiles/nix-config#taylor
home-manager switch --flake ~/dotfiles/nix-config#taylor

fi
