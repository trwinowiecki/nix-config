# Zsh configuration feature
# Enable with: myHomeManager.zsh.enable = true;
#
# Provides zsh with enhanced plugins and configurable prompt (powerlevel10k or starship).
#
# Options:
#   myHomeManager.zsh.promptType = "powerlevel10k" | "starship" | "none"
#   myHomeManager.zsh.enableViMode = true/false
#   myHomeManager.zsh.enableFzfTab = true/false
{ config, lib, pkgs, ... }:
let
  cfg = config.myHomeManager.zsh;
in {
  options.myHomeManager.zsh = {
    promptType = lib.mkOption {
      type = lib.types.enum [ "powerlevel10k" "starship" "none" ];
      default = "powerlevel10k";
      description = "Which prompt to use (powerlevel10k, starship, or none)";
    };

    enableViMode = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh-vi-mode plugin for better vi keybindings";
    };

    enableFzfTab = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fzf-tab for enhanced tab completions";
    };
  };

  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      # Use fast-syntax-highlighting instead of regular syntaxHighlighting
      syntaxHighlighting.enable = false;

      shellAliases = {
        ls = "eza -la";
        ll = "eza -l";
        la = "eza -la";
        lt = "eza -laT";
        cat = "bat";
        please = "sudo !!";
        ".." = "cd ..";
        "..." = "cd ../..";
      };

      # History configuration
      history = {
        size = 50000;
        save = 50000;
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        share = true;
      };

      initExtraFirst = lib.mkIf (cfg.promptType == "powerlevel10k") ''
        # Enable Powerlevel10k instant prompt (must be at top of .zshrc)
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      '';

      initExtra = ''
        # fzf-tab configuration
        ${lib.optionalString cfg.enableFzfTab ''
          # Disable sort when completing `git checkout`
          zstyle ':completion:*:git-checkout:*' sort false
          # Set descriptions format to enable group support
          zstyle ':completion:*:descriptions' format '[%d]'
          # Set list-colors to enable filename colorizing
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          # Force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
          zstyle ':completion:*' menu no
          # Preview directory contents with eza
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
          zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
          # Use fzf default options
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          # Switch groups with < and >
          zstyle ':fzf-tab:*' switch-group '<' '>'
        ''}

        # history-substring-search keybindings
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey '^P' history-substring-search-up
        bindkey '^N' history-substring-search-down

        ${lib.optionalString cfg.enableViMode ''
          # zsh-vi-mode configuration
          # Restore fzf keybindings after vi-mode initialization
          function zvm_after_init() {
            # Source fzf keybindings if available
            [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
            # Restore Ctrl+R for fzf history search
            bindkey '^R' fzf-history-widget 2>/dev/null || true
            # Re-bind history-substring-search for vi mode
            bindkey -M viins '^[[A' history-substring-search-up
            bindkey -M viins '^[[B' history-substring-search-down
            bindkey -M vicmd 'k' history-substring-search-up
            bindkey -M vicmd 'j' history-substring-search-down
          }
          # Change cursor shape for different vi modes
          ZVM_CURSOR_STYLE_ENABLED=true
        ''}

        ${lib.optionalString (cfg.promptType == "powerlevel10k") ''
          # Source powerlevel10k configuration
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        ''}

        # Initialize zoxide
        eval "$(zoxide init zsh)"
      '';

      plugins = [
        # fzf-tab (load after compinit but before other plugins)
      ] ++ lib.optional cfg.enableFzfTab {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      } ++ [
        # history-substring-search
        {
          name = "history-substring-search";
          src = pkgs.zsh-history-substring-search;
          file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
        }
      ] ++ lib.optional cfg.enableViMode {
        # zsh-vi-mode
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      } ++ [
        # fast-syntax-highlighting (load last)
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
      ] ++ lib.optional (cfg.promptType == "powerlevel10k") {
        # powerlevel10k theme
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      };
    };

    # Enable starship if selected as prompt
    programs.starship = lib.mkIf (cfg.promptType == "starship") {
      enable = true;
      enableZshIntegration = true;
    };

    # Required packages for enhanced shell experience
    home.packages = with pkgs; [
      fzf
      zoxide
    ];
  };
}
