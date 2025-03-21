-- vim: set noexpandtab ts=4 sw=4:
local bufnr = vim.api.nvim_get_current_buf()

local opts = { buffer = bufnr }

if vim.g.loaded_rustaceanvim then
	vim.keymap.set({ 'n', 'v' }, 'J', function()
		vim.cmd.RustLsp 'joinLines'
	end, opts)

	vim.keymap.set({ 'n', 'v' }, '<space>ca', function()
		vim.cmd.RustLsp 'codeAction'
	end, opts)

	vim.keymap.set('n', '<C-k>d', function()
		vim.cmd.RustLsp 'debuggables'
	end, opts)

	vim.keymap.set('n', '<C-k>D', function()
		vim.cmd.RustLsp 'debug'
	end, opts)

	vim.keymap.set('n', '<C-k>r', function()
		vim.cmd.RustLsp 'runnables'
	end, opts)

	vim.keymap.set('n', '<C-k>R', function()
		vim.cmd.RustLsp 'run'
	end, opts)

	vim.keymap.set('n', '<C-k>t', function()
		vim.cmd.RustLsp 'testables'
	end, opts)

	vim.keymap.set('n', '<C-k>T', function()
		vim.cmd.RustLsp { 'testables', bang = true }
	end, opts)
end
