function _unison_completer
	if test -z '$UNISON'
		set UNISON $HOME/.unison
	end
	pushd $UNISON

	find . \
		\( -path ./backup -prune -o -type f \) \
		-a -iname '*.prf' \
		-a -not -regex '.*/_.*' \
	| sed 's@^./@@; s@\.prf$@@'

	popd
end

complete -c unison -f -a "(_unison_completer)"
