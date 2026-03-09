vim.api.nvim_create_user_command('ClearDiagnostics', function()
	vim.diagnostic.reset()
end, {})

try_require.show_pending_messages()
