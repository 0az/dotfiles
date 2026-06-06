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
	'ty',
}

vim.lsp.config('gopls', {
	settings = {
		gopls = {
			['ui.inlayhint.hints'] = {
				['assignVariableTypes'] = true,
				['constantValues'] = true,
				['functionTypeParameters'] = true,
			},
			['staticcheck'] = true,
		},
	},
})
vim.lsp.enable 'gopls'

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

vim.lsp.enable 'tofu_ls'

vim.lsp.config('ts_ls', {
	on_attach = function()
		local client = assert(vim.lsp.get_clients({ name = 'ts_ls' })[1])
		vim.api.nvim_create_user_command('TsOrganizeImports', function()
			client:exec_cmd(
				{ title = 'Organize Imports', command = '_typescript.organizeImports' },
				{ bufnr = vim.api.nvim_get_current_buf() }
			)
		end, {})
	end,
})
vim.lsp.enable 'ts_ls'

vim.diagnostic.config {
	virtual_text = {
		source = 'if_many',
	},
	float = {
		source = true, -- Truthy means always
	},
}
