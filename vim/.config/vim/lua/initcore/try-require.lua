-- Define and install a `try_require` global

local M = {
	pending_messages = {},
}

function M.try_require(_self, lib)
	local ok, result = pcall(require, lib)
	if not ok then
		if M.pending_messages ~= nil then
			table.insert(M.pending_messages, lib)
		else
			vim.notify_once(
				'try_require: failed to require modules: ' .. table.concat(M.pending_messages, ', '),
				vim.log.levels.WARN
			)
		end
		return nil
	end
	return result
end

function M.show_pending_messages()
	if M.pending_messages ~= nil and #M.pending_messages > 0 then
		vim.notify_once(
			'try_require: failed to require modules: ' .. table.concat(M.pending_messages, ', '),
			vim.log.levels.WARN
		)
		M.pending_messages = nil
	end
end

setmetatable(M, {
	__call = M.try_require,
})

_G.try_require = M

return M
