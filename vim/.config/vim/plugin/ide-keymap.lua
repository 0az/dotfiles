local lsp_keymap = require 'user.lsp-keymap'

vim.diagnostic.config {
	virtual_text = {
		source = 'if_many',
	},
	float = {
		source = true,
	},
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump { count = 1, float = true }
end)
vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump { count = -1, float = true }
end)
vim.keymap.set('n', '<Space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
require('initcore.lsp').on_attach('*', 'ide-keymap', function(_client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
	lsp_keymap.apply(bufnr)
end)
