function source-env --description 'Read environment variables from .env files'
	for f in $argv;
		export (cat $f | xargs -L 1)
	end
end
