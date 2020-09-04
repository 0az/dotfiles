function source-env --description 'Read environment variables from .env files'
	for f in $argv;
		sed -E '/^#/d' "$f" \
		| begin
			while read line
				if ! export "$line"
					exit 1
				end
			end
		end
	end
end
