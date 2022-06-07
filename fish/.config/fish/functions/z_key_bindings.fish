function z_key_bindings
	if not command -q z; or functions -q z
		return
	end
	if not command -q sk; or functions -q sk
		return
	end
	function z-cd-widget
		z -l | sed -E 's/^[[:digit:]]+ +//' | sk | read -l result
		if test -n "$result"
			cd -- $result
		end
	end

	bind \ez z-cd-widget
	if bind -M insert >/dev/null 2>&1
		bind -M insert \ez z-cd-widget
	end
end
