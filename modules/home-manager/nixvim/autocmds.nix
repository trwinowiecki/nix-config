{...}: {
  programs.nixvim = {
    autoGroups = {
      highlight_yank = {};

      # wrap and check for spell in text filetypes
      wrap_spell = {};

      # Fix conceallevel for json files
      json_conceal = {};

      # Auto create dir when saving a file, in case some intermediate directory does not exist
      auto_create_dir = {};
    };

    autoCmd = [
      {
        group = "highlight_yank";
        event = ["TextYankPost"];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        };
      }
      {
        group = "wrap_spell";
        event = ["FileType"];
        pattern = ["text" "plaintex" "typst" "gitcommit" "markdown"];
        callback = {
          __raw = ''
            function()
              vim.opt_local.wrap = true
              vim.opt_local.spell = true
            end
          '';
        };
      }
      {
        group = "json_conceal";
        event = ["FileType"];
        pattern = ["json" "jsonc" "json5"];
        callback = {
          __raw = ''
            function()
              vim.opt_local.conceallevel = 0
            end
          '';
        };
      }
      {
        group = "auto_create_dir";
        event = ["BufWritePre"];
        pattern = "*";
        callback = {
          __raw = ''
            function(event)
              if event.match:match("^%w%w+:[\\/][\\/]") then
                return
              end
              local file = vim.uv.fs_realpath(event.match) or event.match
              vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
            end
          '';
        };
      }
    ];
  };
}
