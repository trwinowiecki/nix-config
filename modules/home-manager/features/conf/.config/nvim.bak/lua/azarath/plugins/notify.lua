return {
	"rcarriga/nvim-notify",
	config = function()
		vim.opt.termguicolors = true
		vim.notify = require("notify")
		local notify = require("notify")

		notify.setup({
			background_colour = "#000000",
			minimum_width = 50,
			stages = "fade",
			timeout = 2000,
			fps = 60,
		})
	end,
}
