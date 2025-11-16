-- https://github.com/neovim/nvim-lspconfig/blob/5f7a8311dd6e67de74c12fa9ac2f1aa75f72b19e/README.md

-- Setup language servers.

if vim.env.VIM_LSP_DEBUG and vim.env.VIM_LSP_DEBUG ~= '' then
	vim.lsp.set_log_level 'debug'
end

vim.lsp.enable {
	'clangd',
	'hls',
	'nixd',
	'pyright',
}

vim.lsp.config('ruff', {
	on_attach = function(client, bufnr)
		client.server_capabilities.hoverProvider = false
	end,
})
vim.lsp.enable 'ruff'

if not vim.g.loaded_rustaceanvim then
	vim.lsp.config('rust_analyzer', {
		-- Server-specific settings. See `:help lspconfig-setup`
		settings = {
			['rust-analyzer'] = {},
		},
	})
end

vim.lsp.config('sourcekit', {
	filetypes = { 'swift', 'objective-c', 'objective-cpp' },
})
vim.lsp.enable 'sourcekit'

vim.lsp.config('ts_ls', {
	on_attach = function()
		vim.api.nvim_create_user_command('TsOrganizeImports', function()
			vim.lsp.buf.execute_command {
				'_typescript.organizeImports',
				{ vim.api.nvim_buf_get_name(0) },
				'',
			}
		end, {})
	end,
})
vim.lsp.enable 'ts_ls'
