local M = {}

function M.setup()
	local rust_hooks = try_require 'local.ftplugin-hooks.rust' or {}

	vim.g.rustaceanvim = function()
		local config = {
			server = {
				handlers = {
					['window/logMessages'] = function(err, result, ctx, config)
						if result and result.message:find 'overly long loop' then
							return
						end
						vim.lsp.handlers['window/logMessage'](err, result, ctx, config)
					end,
				},
			},
			tools = {
				code_actions = {
					ui_select_fallback = true,
				},
				enable_nextest = true,
				enable_clippy = true,
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
