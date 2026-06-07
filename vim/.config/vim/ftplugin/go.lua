require('go').setup {}

-- TODO: Migrate to native nvim LSP
local go_format = vim.api.nvim_create_augroup('GoFormat', {})
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = '*.go',
	callback = function()
		require('go.format').goimports()
	end,
	group = go_format,
})
