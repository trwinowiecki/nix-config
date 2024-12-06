{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./options.nix
    ./autocmds.nix
    ./keymaps.nix

    ./lsp/lsp.nix
    ./lsp/conform.nix

    ./cmp/autopairs.nix
    ./cmp/cmp.nix
    ./cmp/lspkind.nix

    ./editor/treesitter.nix
    ./editor/illuminate.nix
    ./editor/oil.nix

    ./git/lazygit.nix

    ./snippets/luasnip.nix

    ./ui/lualine.nix
    ./ui/bufferline.nix
    ./ui/startup.nix

    ./utils/telescope.nix
    ./utils/which-key.nix
    ./utils/toggleterm.nix
    ./utils/tmux-navigator.nix
    ./utils/mini.nix
    # ./utils/flash.nix
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.everforest = {
      enable = true;
      settings.transparent_background = 2;
    };
  };
}
