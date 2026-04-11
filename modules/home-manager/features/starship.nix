# Starship Prompt Configuration
# Enable with: myHomeManager.starship.enable = true;
#   OR set myHomeManager.zsh.promptType = "starship";
#
# Provides a fast, customizable prompt themed with nix-colors.
{ config, lib, pkgs, ... }:
let
  colors = config.colorScheme.palette;
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      # Prompt format
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$git_state"
        "$nix_shell"
        "$python"
        "$nodejs"
        "$rust"
        "$golang"
        "$java"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      # Right prompt
      right_format = "$time";

      # Add newline before prompt
      add_newline = true;

      # Character (prompt symbol)
      character = {
        success_symbol = "[](bold #${colors.base0B})";
        error_symbol = "[](bold #${colors.base08})";
        vimcmd_symbol = "[](bold #${colors.base0D})";
        vimcmd_replace_one_symbol = "[](bold #${colors.base0E})";
        vimcmd_replace_symbol = "[](bold #${colors.base0E})";
        vimcmd_visual_symbol = "[](bold #${colors.base0A})";
      };

      # Directory
      directory = {
        style = "bold #${colors.base0D}";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " ";
        read_only_style = "#${colors.base08}";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      # Git branch
      git_branch = {
        symbol = " ";
        style = "bold #${colors.base0E}";
        format = "on [$symbol$branch]($style) ";
      };

      # Git status
      git_status = {
        style = "#${colors.base08}";
        format = "([$all_status$ahead_behind]($style))";
        conflicted = "";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "*\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "\${count}";
      };

      # Git state (rebasing, merging, etc)
      git_state = {
        style = "bold #${colors.base0A}";
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        rebase = "REBASING";
        merge = "MERGING";
        revert = "REVERTING";
        cherry_pick = "CHERRY-PICKING";
        bisect = "BISECTING";
        am = "AM";
        am_or_rebase = "AM/REBASE";
      };

      # Nix shell indicator
      nix_shell = {
        symbol = " ";
        style = "bold #${colors.base0C}";
        format = "via [$symbol$state( \\($name\\))]($style) ";
        impure_msg = "impure";
        pure_msg = "pure";
      };

      # Command duration
      cmd_duration = {
        min_time = 2000;  # Show if > 2 seconds
        style = "bold #${colors.base0A}";
        format = "took [$duration]($style) ";
      };

      # Username (show on SSH or when not default user)
      username = {
        style_user = "bold #${colors.base0B}";
        style_root = "bold #${colors.base08}";
        format = "[$user]($style)";
        show_always = false;
      };

      # Hostname (show on SSH)
      hostname = {
        style = "bold #${colors.base0A}";
        format = "[@$hostname]($style) ";
        ssh_only = true;
      };

      # Time (right prompt)
      time = {
        disabled = false;
        style = "#${colors.base04}";
        format = "[$time]($style)";
        time_format = "%H:%M";
      };

      # Python
      python = {
        symbol = " ";
        style = "#${colors.base0A}";
        format = "via [$symbol$pyenv_prefix($version )(\\($virtualenv\\) )]($style)";
      };

      # Node.js
      nodejs = {
        symbol = " ";
        style = "#${colors.base0B}";
        format = "via [$symbol($version )]($style)";
      };

      # Rust
      rust = {
        symbol = " ";
        style = "#${colors.base08}";
        format = "via [$symbol($version )]($style)";
      };

      # Go
      golang = {
        symbol = " ";
        style = "#${colors.base0C}";
        format = "via [$symbol($version )]($style)";
      };

      # Java
      java = {
        symbol = " ";
        style = "#${colors.base08}";
        format = "via [$symbol($version )]($style)";
      };
    };
  };
}
