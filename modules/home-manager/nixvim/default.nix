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

    ./lsp/lsp.nix
    ./lsp/conform.nix

    ./cmp/autopairs.nix
    ./cmp/cmp.nix
    ./cmp/lspkind.nix
  ];

  programs.nixvim = {
    enable = true;
    plugins = {
      lualine.enable = true;
    };
    colorschemes.everforest.enable = true;
  };
}
