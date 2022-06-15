function z_key_bindings
	if not command -q z; and not functions -q z
		return
	end
	if not command -q sk; and not functions -q sk
		return
	end

	function z-cd-widget
		z -l | sed -E 's/^[0-9.]+ +//' | sk | read -l result
		if test -n "$result"
			cd -- $result
		end
	end

	bind \ez z-cd-widget
	if bind -M insert >/dev/null 2>&1
		bind -M insert \ez z-cd-widget
	end
end
