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
