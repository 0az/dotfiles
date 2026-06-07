-- https://github.com/neovim/nvim-lspconfig/blob/5f7a8311dd6e67de74c12fa9ac2f1aa75f72b19e/README.md

-- Setup language servers.

if vim.env.VIM_LSP_DEBUG and vim.env.VIM_LSP_DEBUG ~= '' then
	vim.lsp.log.set_level 'debug'
end

vim.lsp.enable {
	'clangd',
	'hls',
	'lua_ls', -- See: ftplugin/lua.lua
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
	on_attach = function(client)
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

local lsp_format_on_save_allowlist = {
	tofu_ls = true,
}

--- Inlay hint denylist.
local lsp_inlay_hint_denylist = {
	lua_ls = true,
}

local function augroup_name(client)
	return 'UserLspConfig.' .. client.name .. '.' .. client.id .. '.Main'
end

require('initcore.lsp').on_attach('*', 'lspconfig', function(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(not lsp_inlay_hint_denylist[client.name], { bufnr = bufnr })
	end

	local lsp_augroup = vim.api.nvim_create_augroup(augroup_name(client), { clear = false })

	if lsp_format_on_save_allowlist[client.name] then
		if client:supports_method 'textDocument/formatting' then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = lsp_augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format { bufnr = bufnr, id = client.id, timeout_ms = 1000 }
				end,
			})
		end
	end
end)

require('initcore.lsp').on_detach('*', 'lspconfig', function(client, bufnr)
	vim.api.nvim_clear_autocmds { group = augroup_name(client), buf = bufnr }
end)
