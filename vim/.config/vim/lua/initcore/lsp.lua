local M = {}

--- @param lsp_name string The name of a specific LSP or '*' for all LSPs.
--- @param callback_name string The name of this callback.
--- @param callback fun(client: vim.lsp.Client, bufnr: number) The LspAttach callback.
function M.on_attach(lsp_name, callback_name, callback)
	local augroup_name = 'UserLspConfig.OnAttach.' .. lsp_name .. '.' .. callback_name

	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup(augroup_name, {}),
		callback = function(args)
			local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
			if lsp_name == client.name or lsp_name == '*' then
				callback(client, args.buf)
			end
		end,
	})
end

--- @param lsp_name string The name of a specific LSP or '*' for all LSPs.
--- @param callback_name string The name of this callback.
--- @param callback fun(client: vim.lsp.Client, bufnr: number) The LspDetach callback.
function M.on_detach(lsp_name, callback_name, callback)
	local augroup_name = 'UserLspConfig.OnDetach.' .. lsp_name .. '.' .. callback_name

	vim.api.nvim_create_autocmd('LspDetach', {
		group = vim.api.nvim_create_augroup(augroup_name, {}),
		callback = function(args)
			local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
			if lsp_name == client.name or lsp_name == '*' then
				callback(client, args.buf)
			end
		end,
	})
end

return M
