-- Leader
vim.g.mapleader = " "
vim.opt.timeoutlen = 2000 -- Timeout for leader key input
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Appearance
vim.opt.termguicolors = true
vim.o.pumheight = 10 -- Max items to show in pop up menu
vim.o.cmdheight = 0 -- Max items to show in command menu

-- Files and Others
vim.o.fileencoding = "utf-8" -- File Encoding
vim.g.loaded_netrw = 1 -- Helps opening links in the internet (probabilly -_-)
vim.g.loaded_netrwPlugin = 1
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.hidden = true
vim.o.whichwrap = "b,s,<,>,[,],h,l"
vim.opt.iskeyword:append("-,_")
vim.opt.virtualedit = "block"

-- Split Windows
vim.o.splitbelow = true
vim.o.splitright = true

-- Update and backups
vim.o.showmode = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300
vim.o.timeoutlen = 100

-- clipboard
vim.o.clipboard = "unnamedplus"

-- Backspace key
vim.o.backspace = "indent,eol,start"

-- Search
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Mouse and Scrolling
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.o.mouse = "a"

-- Wrapping
vim.wo.wrap = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.cursorline = true
vim.o.cursorcolumn = false
vim.wo.signcolumn = "yes"

-- Tabs and indentations
vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.showtabline = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.bo.shiftwidth = 2
vim.o.smartindent = true
vim.bo.smartindent = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.expandtab = true
vim.bo.expandtab = true

vim.opt.fillchars = { eob = " " }

-- keep cursor unchanged after quiting
vim.api.nvim_create_autocmd("ExitPre", {
	group = vim.api.nvim_create_augroup("Exit", { clear = true }),
	command = "set guicursor=a:ver90",
	desc = "Set cursor back to beam when leaving Neovim.",
})

local opt = vim.opt

vim.opt.autowrite = true -- Enable auto write
vim.opt.autoindent = true -- Enable auto indent
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.laststatus = 0 -- global statusline
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.number = true -- Print line number
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.spelllang = { "en" }
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	-- fold = "⸱",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

if vim.fn.has("nvim-0.10") == 1 then
	opt.smoothscroll = true
end

-- Autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true }),
	callback = function()
		vim.lsp.buf.format()
	end,
	desc = "Auto format on save",
})
