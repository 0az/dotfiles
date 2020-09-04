function source-env --description 'Read environment variables from .env files'
	for f in $argv;
		export (
			sed -E '/^#/d' "$f" \
			| xargs -L 1
		)
	end
end
