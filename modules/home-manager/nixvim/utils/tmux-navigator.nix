{
  programs.nixvim.plugins.tmux-navigator = {
    enable = true;
    keymaps = [
      {
        action = "left";
        key = "<c-h>";
      }
      {
        action = "down";
        key = "<c-j>";
      }
      {
        action = "up";
        key = "<c-k>";
      }
      {
        action = "right";
        key = "<c-l>";
      }
      {
        action = "right";
        key = "<c-\\>";
      }
    ];
  };
}
