return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.everforest_background = "hard"
		vim.g.everforest_transparent_background = 2
		vim.cmd("colorscheme everforest")
	end,
}

-- return {
-- 	"AlexvZyl/nordic.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("nordic").setup({
-- 			transparent_bg = true,
-- 		})
-- 		vim.cmd("colorscheme nordic")
-- 	end,
-- }

-- return {
--   "rebelot/kanagawa.nvim",
--   config = function()
--     require("kanagawa").setup({
--       transparent = true,
--     })
--     vim.cmd("colorscheme kanagawa-dragon")
--   end,
-- }

-- return {
--   "catppuccin/nvim",
--   lazy = false,
--   name = "catppuccin",
--   priority = 1000,
--   config = function()
--     require('catppuccin').setup({
--       transparent_background = true
--     })
--     vim.cmd.colorscheme("catppuccin")
--   end
-- }
