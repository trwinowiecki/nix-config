# Kitty terminal configuration feature
# Enable with: myHomeManager.kitty.enable = true;
# Automatically uses your nix-colors colorScheme for theming
{ config, lib, pkgs, ... }:
let
  # Access the base16 colors from nix-colors
  colors = config.colorScheme.palette;
in {
  programs.kitty = {
    enable = true;
    font = {
      name = "MesloLGS NF";
      size = 12;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      window_padding_width = 4;
      confirm_os_window_close = 0;

      # Gruvbox/nix-colors theming
      foreground = "#${colors.base05}";
      background = "#${colors.base00}";
      selection_foreground = "#${colors.base00}";
      selection_background = "#${colors.base05}";

      # Cursor
      cursor = "#${colors.base05}";
      cursor_text_color = "#${colors.base00}";

      # URL underline color
      url_color = "#${colors.base0D}";

      # Tab bar colors
      active_tab_foreground = "#${colors.base00}";
      active_tab_background = "#${colors.base0B}";
      inactive_tab_foreground = "#${colors.base04}";
      inactive_tab_background = "#${colors.base01}";

      # Window border colors
      active_border_color = "#${colors.base0B}";
      inactive_border_color = "#${colors.base03}";

      # The 16 terminal colors
      # Black
      color0 = "#${colors.base00}";
      color8 = "#${colors.base03}";
      # Red
      color1 = "#${colors.base08}";
      color9 = "#${colors.base08}";
      # Green
      color2 = "#${colors.base0B}";
      color10 = "#${colors.base0B}";
      # Yellow
      color3 = "#${colors.base0A}";
      color11 = "#${colors.base0A}";
      # Blue
      color4 = "#${colors.base0D}";
      color12 = "#${colors.base0D}";
      # Magenta
      color5 = "#${colors.base0E}";
      color13 = "#${colors.base0E}";
      # Cyan
      color6 = "#${colors.base0C}";
      color14 = "#${colors.base0C}";
      # White
      color7 = "#${colors.base05}";
      color15 = "#${colors.base07}";
    };
  };
}
