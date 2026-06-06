-- Derived from https://github.com/neovim/nvim-lspconfig/blob/229b79051b380377664edc4cbd534930154921a1/lsp/lua_ls.lua#L15
-- SPDX-License-Identifier: Apache-2.0

local nvim_luals_settings = function()
	return {
		runtime = {
			-- Tell the language server which version of Lua you're using (most
			-- likely LuaJIT in the case of Neovim)
			version = 'LuaJIT',
			-- Tell the language server how to find Lua modules same way as Neovim
			-- (see `:h lua-module-load`)
			path = {
				'lua/?.lua',
				'lua/?/init.lua',
			},
		},
		-- Make the server aware of Neovim runtime files
		workspace = {
			checkThirdParty = false,
			library = {
				vim.env.VIMRUNTIME,
				-- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
				vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
			},
			-- Or pull in all of 'runtimepath'.
			-- NOTE: this is a lot slower and will cause issues when working on
			-- your own configuration.
			-- See https://github.com/neovim/nvim-lspconfig/issues/3189
			-- library = vim.api.nvim_get_runtime_file('', true),
		},
	}
end

local in_any_runtime_directory = function(path)
	for _, runtime_path in ipairs(vim.api.nvim_get_runtime_file('', true)) do
		if path ~= runtime_path then
			return true
		end
	end
	return false
end

vim.lsp.config('lua_ls', {
	on_init = function(client)
		if not client.workspace_folders then
			return
		end

		local path = client.workspace_folders[1].name

		-- Load neovim LSP settings if the current workspace is under the usual dotfiles directory,
		-- or if it's under the currently-loaded dotfiles directory.
		if
			path ~= vim.fn.expand '$HOME/dotfiles/vim/.config'
			or path ~= vim.g.vim_dotfiles_root
			or in_any_runtime_directory(path)
		then
			client.config.settings.Lua =
				vim.tbl_deep_extend('force', client.config.settings.Lua, nvim_luals_settings())
		end
	end,
	settings = {
		Lua = {},
	},
})
