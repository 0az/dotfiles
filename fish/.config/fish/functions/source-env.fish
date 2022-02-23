function source-env --description 'Read environment variables from .env files'
	for f in $argv
		for v in (
			sed -E -e '/^#/d' -e 's/^export //' "$f" \
			| xargs -L 1
		)
			export $v
		end
	end
end
