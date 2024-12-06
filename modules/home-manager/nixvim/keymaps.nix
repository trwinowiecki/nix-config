{
  programs.nixvim = {
    keymaps = [
      # better up/down
      {
        mode = ["n" "x"];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          desc = "Down";
          expr = true;
          silent = true;
        };
      }
      {
        mode = ["n" "x"];
        key = "<Down>";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          desc = "Down";
          expr = true;
          silent = true;
        };
      }
      {
        mode = ["n" "x"];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          desc = "Up";
          expr = true;
          silent = true;
        };
      }
      {
        mode = ["n" "x"];
        key = "<Up>";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          desc = "Up";
          expr = true;
          silent = true;
        };
      }

      # Move to window using the <ctrl> hjkl keys
      {
        mode = ["n"];
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          desc = "Go to Left Window";
          remap = true;
        };
      }
      {
        mode = ["n"];
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          desc = "Go to Lower Window";
          remap = true;
        };
      }
      {
        mode = ["n"];
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          desc = "Go to Upper Window";
          remap = true;
        };
      }
      {
        mode = ["n"];
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          desc = "Go to Right Window";
          remap = true;
        };
      }

      # Resize window using <ctrl> arrow keys
      {
        mode = ["n"];
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options = {
          desc = "Increase Window Height";
        };
      }
      {
        mode = ["n"];
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options = {
          desc = "Decrease Window Height";
        };
      }
      {
        mode = ["n"];
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options = {
          desc = "Decrease Window Width";
        };
      }
      {
        mode = ["n"];
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options = {
          desc = "Increase Window Width";
        };
      }

      # Move Lines
      {
        mode = ["n"];
        key = "<A-j>";
        action = "<cmd>m .+1<cr>==";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = ["n"];
        key = "<A-k>";
        action = "<cmd>m .-2<cr>==";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = ["i"];
        key = "<A-j>";
        action = "<esc><cmd>m .+1<cr>==gi";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = ["i"];
        key = "<A-k>";
        action = "<esc><cmd>m .-2<cr>==gi";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = ["v"];
        key = "<A-j>";
        action = ":m '>+1<cr>gv=gv";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = ["v"];
        key = "<A-k>";
        action = ":m '<-2<cr>gv=gv";
        options = {
          desc = "Move Up";
        };
      }

      # buffers
      {
        mode = ["n"];
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options = {
          desc = "Prev Buffer";
        };
      }
      {
        mode = ["n"];
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options = {
          desc = "Next Buffer";
        };
      }
      {
        mode = ["n"];
        key = "[b";
        action = "<cmd>bprevious<cr>";
        options = {
          desc = "Prev Buffer";
        };
      }
      {
        mode = ["n"];
        key = "]b";
        action = "<cmd>bnext<cr>";
        options = {
          desc = "Next Buffer";
        };
      }
      {
        mode = ["n"];
        key = "<leader>bb";
        action = "<cmd>e #<cr>";
        options = {
          desc = "Switch to Other Buffer";
        };
      }
      {
        mode = ["n"];
        key = "<leader>`";
        action = "<cmd>e #<cr>";
        options = {
          desc = "Switch to Other Buffer";
        };
      }
      {
        mode = ["n"];
        key = "<leader>bD";
        action = "<cmd>:bd<cr>";
        options = {
          desc = "Delete Buffer and Window";
        };
      }

      # Clear search with <esc>
      {
        mode = ["i" "n"];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options = {
          desc = "Escape and Clear hlsearch";
        };
      }

      # Clear search, diff update and redraw
      # taken from runtime/lua/_editor.lua
      {
        mode = ["n"];
        key = "<leader>ur";
        action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
        options = {
          desc = "Redraw / Clear hlsearch / Diff Update";
        };
      }

      # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      {
        mode = ["n"];
        key = "n";
        action = "'Nn'[v:searchforward].'zv'";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = ["x"];
        key = "n";
        action = "'Nn'[v:searchforward]";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = ["o"];
        key = "n";
        action = "'Nn'[v:searchforward]";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = ["n"];
        key = "N";
        action = "'nN'[v:searchforward].'zv'";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }
      {
        mode = ["x"];
        key = "N";
        action = "'nN'[v:searchforward]";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }
      {
        mode = ["o"];
        key = "N";
        action = "'nN'[v:searchforward]";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }

      # Add undo break-points
      {
        mode = ["i"];
        key = ",";
        action = ",<c-g>u";
      }
      {
        mode = ["i"];
        key = ".";
        action = ".<c-g>u";
      }
      {
        mode = ["i"];
        key = ";";
        action = ";<c-g>u";
      }

      # save file
      {
        mode = ["i" "x" "n" "s"];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options = {
          desc = "Save File";
        };
      }

      # keywordprg
      {
        mode = ["n"];
        key = "<leader>K";
        action = "<cmd>norm! K<cr>";
        options = {
          desc = "Keywordprg";
        };
      }

      # better indenting
      {
        mode = ["v"];
        key = "<";
        action = "<gv";
      }
      {
        mode = ["v"];
        key = ">";
        action = ">gv";
      }

      # commenting
      {
        mode = ["n"];
        key = "gco";
        action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
        options = {
          desc = "Add Comment Below";
        };
      }
      {
        mode = ["n"];
        key = "gcO";
        action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
        options = {
          desc = "Add Comment Above";
        };
      }

      # new file
      {
        mode = ["n"];
        key = "<leader>fn";
        action = "<cmd>enew<cr>";
        options = {
          desc = "New File";
        };
      }

      {
        mode = ["n"];
        key = "<leader>xl";
        action = "<cmd>lopen<cr>";
        options = {
          desc = "Location List";
        };
      }
      {
        mode = ["n"];
        key = "<leader>xq";
        action = "<cmd>copen<cr>";
        options = {
          desc = "Quickfix List";
        };
      }

      {
        mode = ["n"];
        key = "[q";
        action.__raw = "vim.cmd.cprev";
        options = {
          desc = "Previous Quickfix";
        };
      }
      {
        mode = ["n"];
        key = "]q";
        action.__raw = "vim.cmd.cnext";
        options = {
          desc = "Next Quickfix";
        };
      }

      # Formatting
      {
        mode = ["n" "v"];
        key = "<leader>cf";
        action.__raw = ''
          function()
            require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
          end
        '';
        options = {
          desc = "Format Injected Langs";
        };
      }
    ];
  };
}
