#!/usr/bin/env bash
# Update script for Taylor's NixOS configuration
# Usage: ./update-flake.sh [--trace]
#   --trace: Enable --show-trace for debugging build errors

set -e

FLAKE_DIR=~/dotfiles/nix-config

if [ "$1" = "--trace" ] || [ "$1" = "-t" ]; then
  TRACE_FLAG="--show-trace"
else
  TRACE_FLAG=""
fi

echo "==> Rebuilding NixOS system..."
echo "sudo nixos-rebuild switch --flake ${FLAKE_DIR}#hp-nixos ${TRACE_FLAG}"
sudo nixos-rebuild switch --flake "${FLAKE_DIR}#hp-nixos" ${TRACE_FLAG}

echo ""
echo "==> Switching home-manager configuration..."
echo "home-manager switch --flake ${FLAKE_DIR}#taylor ${TRACE_FLAG}"
home-manager switch --flake "${FLAKE_DIR}#taylor" ${TRACE_FLAG}

echo ""
echo "==> Update complete!"
