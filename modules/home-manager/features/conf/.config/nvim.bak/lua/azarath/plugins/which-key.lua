return {
	"folke/which-key.nvim",
	dependencies = {
		"akinsho/toggleterm.nvim",
	},
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300

		local wk = require("which-key")
		-- border
		wk.setup({
			window = {
				border = "double",
			},
		})

		local terminal = require("toggleterm.terminal").Terminal

		local toggle_lazygit = function()
			local lazygit = terminal:new({ cmd = "lazygit", direction = "float" })
			return lazygit:toggle()
		end

		local mappings = {
			-- Basic Operations
			q = { ":q<cr>", "Quit File" },
			Q = { ":q!<cr>", "Force Quit File" },
			w = { ":w<cr>", "Save File" },
			W = { ":w!<cr>", "Force Save File" },

			g = {
				g = { toggle_lazygit, "LazyGit" },
			},

			c = {
				name = "+Code",
				a = { vim.lsp.buf.code_action, "Code Action" },
				d = { vim.lsp.buf.definition, "Definition" },
				D = { vim.lsp.buf.declaration, "Declaration" },
				i = { vim.lsp.buf.implementation, "Implementation" },
				r = { vim.lsp.buf.rename, "Rename" },
				t = { "<cmd>TroubleToggle<cr>", "Trouble" },
				o = { "<cmd>OrganizeImports<cr>", "Organize Imports" },
			},

			-- Buffers
			b = {
				name = "+Buffers",
				n = { "<cmd>bn<cr>", "Next Buffer" },
				p = { "<cmd>bp<cr>", "Previous Buffer" },
				d = { "<cmd>bd<cr>", "Delete Buffer" },
				D = { "<cmd>bd!<cr>", "Force Delete Buffer" },
				s = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
			},

			-- Telescope
			f = {
				name = "+Find",
				f = { "<cmd>Telescope git_files<cr>", "Find Files (git)" },
				a = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", "Find Files (all)" },
				g = { "<cmd>Telescope live_grep<cr>", "Grep Files" },
				b = { "<cmd>Telescope buffers<cr>", "Find Buffers" },
				h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
				t = { "<cmd>Telescope treesitter<cr>", "Find Treesitter" },
				c = { "<cmd>Telescope colorscheme<cr>", "Find Colorscheme" },
				s = { "<cmd>Telescope lsp_document_symbols<cr>", "Find Symbols" },
				S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Find Workspace Symbols" },
			},
		}

		local opts = { prefix = "<leader>" }
		wk.register(mappings, opts)
	end,
}
