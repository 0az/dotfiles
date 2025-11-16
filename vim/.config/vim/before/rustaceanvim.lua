local M = {}

function M.setup()
	vim.g.rustaceanvim = function()
		local rust_hooks = try_require 'local.ftplugin-hooks.rust' or {}

		local config = {
			server = {},
			tools = {
				code_actions = {
					ui_select_fallback = true,
				},
				test_executor = 'background',
			},
		}

		if rust_hooks.rust_analyzer and rust_hooks.rust_analyzer.cmd then
			config.server.cmd = rust_hooks.rust_analyzer.cmd
		end

		return config
	end
end

return M
