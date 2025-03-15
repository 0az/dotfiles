-- https://github.com/neovim/nvim-lspconfig/blob/5f7a8311dd6e67de74c12fa9ac2f1aa75f72b19e/README.md

-- Setup language servers.
local lspconfig = require 'lspconfig'

lspconfig.clangd.setup {}
lspconfig.hls.setup {}
lspconfig.pyright.setup {}

lspconfig.gopls.setup {
	settings = {
		gopls = {
			['ui.inlayhint.hints'] = {
				['assignVariableTypes'] = true,
				['constantValues'] = true,
				['functionTypeParameters'] = true,
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
}

lspconfig.ruff.setup {
	on_attach = function(client, bufnr)
		client.server_capabilities.hoverProvider = false
	end,
}

lspconfig.rust_analyzer.setup {
	-- Server-specific settings. See `:help lspconfig-setup`
	settings = {
		['rust-analyzer'] = {},
	},
}
lspconfig.sourcekit.setup {
	filetypes = { 'swift', 'objective-c', 'objective-cpp' },
}

lspconfig.ts_ls.setup {
	on_attach = function()
		vim.api.nvim_create_user_command('TsOrganizeImports', function()
			vim.lsp.buf.execute_command {
				'_typescript.organizeImports',
				{ vim.api.nvim_buf_get_name(0) },
				'',
			}
		end, {})
	end,
}

vim.diagnostic.config {
	virtual_text = {
		source = 'if_many',
	},
	float = {
		source = 'always',
	},
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})
