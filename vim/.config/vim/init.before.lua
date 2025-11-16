require('before.rustaceanvim').setup()

_G.try_require = function(lib)
	local ok, result = pcall(require, lib)
	if not ok then
		vim.notify_once('try_require: failed to require ' .. lib, vim.log.levels.WARN, {})
		return nil
	end
	return result
end
